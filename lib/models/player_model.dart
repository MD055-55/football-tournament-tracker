import 'package:cloud_firestore/cloud_firestore.dart';

enum PlayerPosition {
  goalkeeper,
  defender,
  midfielder,
  forward,
}

class PlayerStats {
  final int matchesPlayed;
  final int starts;
  final int substitutions;
  final int goals;
  final int assists;
  final int mvpAwards;
  final double averageRating;
  final double bestRating;
  final int yellowCards;
  final int redCards;
  final int cleanSheets;
  final int goalsAgainst;

  PlayerStats({
    required this.matchesPlayed,
    required this.starts,
    required this.substitutions,
    required this.goals,
    required this.assists,
    required this.mvpAwards,
    required this.averageRating,
    required this.bestRating,
    required this.yellowCards,
    required this.redCards,
    this.cleanSheets = 0,
    this.goalsAgainst = 0,
  });

  factory PlayerStats.empty() {
    return PlayerStats(
      matchesPlayed: 0,
      starts: 0,
      substitutions: 0,
      goals: 0,
      assists: 0,
      mvpAwards: 0,
      averageRating: 0.0,
      bestRating: 0.0,
      yellowCards: 0,
      redCards: 0,
    );
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      matchesPlayed: json['matchesPlayed'] ?? 0,
      starts: json['starts'] ?? 0,
      substitutions: json['substitutions'] ?? 0,
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      mvpAwards: json['mvpAwards'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      bestRating: (json['bestRating'] ?? 0.0).toDouble(),
      yellowCards: json['yellowCards'] ?? 0,
      redCards: json['redCards'] ?? 0,
      cleanSheets: json['cleanSheets'] ?? 0,
      goalsAgainst: json['goalsAgainst'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchesPlayed': matchesPlayed,
      'starts': starts,
      'substitutions': substitutions,
      'goals': goals,
      'assists': assists,
      'mvpAwards': mvpAwards,
      'averageRating': averageRating,
      'bestRating': bestRating,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'cleanSheets': cleanSheets,
      'goalsAgainst': goalsAgainst,
    };
  }
}

class Player {
  final String id;
  final String teamId;
  final String tournamentId;
  final String name;
  final int number;
  final PlayerPosition position;
  final String? photoUrl;
  final PlayerStats stats;
  final List<String> matchHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Player({
    required this.id,
    required this.teamId,
    required this.tournamentId,
    required this.name,
    required this.number,
    required this.position,
    this.photoUrl,
    required this.stats,
    required this.matchHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Player.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Player(
      id: doc.id,
      teamId: data['teamId'] ?? '',
      tournamentId: data['tournamentId'] ?? '',
      name: data['name'] ?? '',
      number: data['number'] ?? 0,
      position: PlayerPosition.values[data['position'] ?? 0],
      photoUrl: data['photoUrl'],
      stats: PlayerStats.fromJson(data['stats'] ?? {}),
      matchHistory: List<String>.from(data['matchHistory'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamId': teamId,
      'tournamentId': tournamentId,
      'name': name,
      'number': number,
      'position': position.index,
      'photoUrl': photoUrl,
      'stats': stats.toJson(),
      'matchHistory': matchHistory,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Player copyWith({
    String? id,
    String? teamId,
    String? tournamentId,
    String? name,
    int? number,
    PlayerPosition? position,
    String? photoUrl,
    PlayerStats? stats,
    List<String>? matchHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Player(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      number: number ?? this.number,
      position: position ?? this.position,
      photoUrl: photoUrl ?? this.photoUrl,
      stats: stats ?? this.stats,
      matchHistory: matchHistory ?? this.matchHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
