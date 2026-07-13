import 'package:cloud_firestore/cloud_firestore.dart';

enum CompetitionSystem {
  league,
  groups,
  knockout,
  mixed,
}

class Tournament {
  final String id;
  final String name;
  final String? logoUrl;
  final String season;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> teamIds;
  final CompetitionSystem competitionSystem;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tournament({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.season,
    required this.startDate,
    required this.endDate,
    required this.teamIds,
    required this.competitionSystem,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tournament.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tournament(
      id: doc.id,
      name: data['name'] ?? '',
      logoUrl: data['logoUrl'],
      season: data['season'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      teamIds: List<String>.from(data['teamIds'] ?? []),
      competitionSystem: CompetitionSystem.values[
          data['competitionSystem'] ?? CompetitionSystem.league.index],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'season': season,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'teamIds': teamIds,
      'competitionSystem': competitionSystem.index,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Tournament copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? season,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? teamIds,
    CompetitionSystem? competitionSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      season: season ?? this.season,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      teamIds: teamIds ?? this.teamIds,
      competitionSystem: competitionSystem ?? this.competitionSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
