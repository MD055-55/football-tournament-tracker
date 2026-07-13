import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus {
  scheduled,
  live,
  finished,
  postponed,
  cancelled,
}

class MatchEvent {
  final String id;
  final String playerId;
  final String playerName;
  final int minute;
  final String type;
  final String? description;
  final DateTime timestamp;

  MatchEvent({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.minute,
    required this.type,
    this.description,
    required this.timestamp,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      id: json['id'] ?? '',
      playerId: json['playerId'] ?? '',
      playerName: json['playerName'] ?? '',
      minute: json['minute'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'playerName': playerName,
      'minute': minute,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class MatchStats {
  final int possession;
  final int shots;
  final int shotsOnTarget;
  final int corners;
  final int fouls;
  final int offsides;
  final int saves;
  final int passesCompleted;
  final int passAccuracy;

  MatchStats({
    required this.possession,
    required this.shots,
    required this.shotsOnTarget,
    required this.corners,
    required this.fouls,
    required this.offsides,
    required this.saves,
    required this.passesCompleted,
    required this.passAccuracy,
  });

  factory MatchStats.empty() {
    return MatchStats(
      possession: 0,
      shots: 0,
      shotsOnTarget: 0,
      corners: 0,
      fouls: 0,
      offsides: 0,
      saves: 0,
      passesCompleted: 0,
      passAccuracy: 0,
    );
  }

  factory MatchStats.fromJson(Map<String, dynamic> json) {
    return MatchStats(
      possession: json['possession'] ?? 0,
      shots: json['shots'] ?? 0,
      shotsOnTarget: json['shotsOnTarget'] ?? 0,
      corners: json['corners'] ?? 0,
      fouls: json['fouls'] ?? 0,
      offsides: json['offsides'] ?? 0,
      saves: json['saves'] ?? 0,
      passesCompleted: json['passesCompleted'] ?? 0,
      passAccuracy: json['passAccuracy'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'possession': possession,
      'shots': shots,
      'shotsOnTarget': shotsOnTarget,
      'corners': corners,
      'fouls': fouls,
      'offsides': offsides,
      'saves': saves,
      'passesCompleted': passesCompleted,
      'passAccuracy': passAccuracy,
    };
  }
}

class Match {
  final String id;
  final String tournamentId;
  final String homeTeamId;
  final String awayTeamId;
  final int homeGoals;
  final int awayGoals;
  final MatchStatus status;
  final DateTime kickoffTime;
  final String? venue;
  final String? referee;
  final int round;
  final List<MatchEvent> events;
  final Map<String, double> playerRatings;
  final String? homeTeamCaptain;
  final String? awayTeamCaptain;
  final String? mvpPlayerId;
  final int? additionalTime;
  final MatchStats homeStats;
  final MatchStats awayStats;
  final DateTime createdAt;
  final DateTime updatedAt;

  Match({
    required this.id,
    required this.tournamentId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeGoals,
    required this.awayGoals,
    required this.status,
    required this.kickoffTime,
    this.venue,
    this.referee,
    required this.round,
    required this.events,
    required this.playerRatings,
    this.homeTeamCaptain,
    this.awayTeamCaptain,
    this.mvpPlayerId,
    this.additionalTime,
    required this.homeStats,
    required this.awayStats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Match.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Match(
      id: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      homeTeamId: data['homeTeamId'] ?? '',
      awayTeamId: data['awayTeamId'] ?? '',
      homeGoals: data['homeGoals'] ?? 0,
      awayGoals: data['awayGoals'] ?? 0,
      status: MatchStatus.values[data['status'] ?? 0],
      kickoffTime: (data['kickoffTime'] as Timestamp).toDate(),
      venue: data['venue'],
      referee: data['referee'],
      round: data['round'] ?? 1,
      events: (data['events'] as List<dynamic>?)
              ?.map((e) => MatchEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      playerRatings: Map<String, double>.from(
        (data['playerRatings'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
            {},
      ),
      homeTeamCaptain: data['homeTeamCaptain'],
      awayTeamCaptain: data['awayTeamCaptain'],
      mvpPlayerId: data['mvpPlayerId'],
      additionalTime: data['additionalTime'],
      homeStats: MatchStats.fromJson(data['homeStats'] ?? {}),
      awayStats: MatchStats.fromJson(data['awayStats'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'homeGoals': homeGoals,
      'awayGoals': awayGoals,
      'status': status.index,
      'kickoffTime': Timestamp.fromDate(kickoffTime),
      'venue': venue,
      'referee': referee,
      'round': round,
      'events': events.map((e) => e.toJson()).toList(),
      'playerRatings': playerRatings,
      'homeTeamCaptain': homeTeamCaptain,
      'awayTeamCaptain': awayTeamCaptain,
      'mvpPlayerId': mvpPlayerId,
      'additionalTime': additionalTime,
      'homeStats': homeStats.toJson(),
      'awayStats': awayStats.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
