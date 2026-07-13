import 'package:cloud_firestore/cloud_firestore.dart';

class TeamStats {
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;
  final int cleanSheets;
  final int yellowCards;
  final int redCards;

  TeamStats({
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
    required this.cleanSheets,
    required this.yellowCards,
    required this.redCards,
  });

  factory TeamStats.empty() {
    return TeamStats(
      matchesPlayed: 0,
      wins: 0,
      draws: 0,
      losses: 0,
      goalsFor: 0,
      goalsAgainst: 0,
      goalDifference: 0,
      points: 0,
      cleanSheets: 0,
      yellowCards: 0,
      redCards: 0,
    );
  }

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      matchesPlayed: json['matchesPlayed'] ?? 0,
      wins: json['wins'] ?? 0,
      draws: json['draws'] ?? 0,
      losses: json['losses'] ?? 0,
      goalsFor: json['goalsFor'] ?? 0,
      goalsAgainst: json['goalsAgainst'] ?? 0,
      goalDifference: json['goalDifference'] ?? 0,
      points: json['points'] ?? 0,
      cleanSheets: json['cleanSheets'] ?? 0,
      yellowCards: json['yellowCards'] ?? 0,
      redCards: json['redCards'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'goalDifference': goalDifference,
      'points': points,
      'cleanSheets': cleanSheets,
      'yellowCards': yellowCards,
      'redCards': redCards,
    };
  }
}

class Team {
  final String id;
  final String tournamentId;
  final String name;
  final String? shieldUrl;
  final String? primaryColor;
  final String? secondaryColor;
  final String? coach;
  final List<String> playerIds;
  final TeamStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  Team({
    required this.id,
    required this.tournamentId,
    required this.name,
    this.shieldUrl,
    this.primaryColor,
    this.secondaryColor,
    this.coach,
    required this.playerIds,
    required this.stats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Team.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Team(
      id: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      name: data['name'] ?? '',
      shieldUrl: data['shieldUrl'],
      primaryColor: data['primaryColor'],
      secondaryColor: data['secondaryColor'],
      coach: data['coach'],
      playerIds: List<String>.from(data['playerIds'] ?? []),
      stats: TeamStats.fromJson(data['stats'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'name': name,
      'shieldUrl': shieldUrl,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'coach': coach,
      'playerIds': playerIds,
      'stats': stats.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Team copyWith({
    String? id,
    String? tournamentId,
    String? name,
    String? shieldUrl,
    String? primaryColor,
    String? secondaryColor,
    String? coach,
    List<String>? playerIds,
    TeamStats? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      name: name ?? this.name,
      shieldUrl: shieldUrl ?? this.shieldUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      coach: coach ?? this.coach,
      playerIds: playerIds ?? this.playerIds,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
