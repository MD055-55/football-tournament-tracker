import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tournament_model.dart';
import '../../models/team_model.dart';
import '../../models/player_model.dart';
import '../../models/match_model.dart';
import '../../models/news_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tournaments
  Future<void> createTournament(Tournament tournament) async {
    await _firestore
        .collection('tournaments')
        .doc(tournament.id)
        .set(tournament.toFirestore());
  }

  Future<Tournament?> getTournament(String id) async {
    final doc = await _firestore.collection('tournaments').doc(id).get();
    if (doc.exists) {
      return Tournament.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<Tournament>> getTournamentsStream() {
    return _firestore.collection('tournaments').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Tournament.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateTournament(Tournament tournament) async {
    await _firestore
        .collection('tournaments')
        .doc(tournament.id)
        .update(tournament.toFirestore());
  }

  Future<void> deleteTournament(String id) async {
    await _firestore.collection('tournaments').doc(id).delete();
  }

  // Teams
  Future<void> createTeam(Team team) async {
    await _firestore.collection('teams').doc(team.id).set(team.toFirestore());
  }

  Future<Team?> getTeam(String id) async {
    final doc = await _firestore.collection('teams').doc(id).get();
    if (doc.exists) {
      return Team.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<Team>> getTeamsByTournamentStream(String tournamentId) {
    return _firestore
        .collection('teams')
        .where('tournamentId', isEqualTo: tournamentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Team.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateTeam(Team team) async {
    await _firestore
        .collection('teams')
        .doc(team.id)
        .update(team.toFirestore());
  }

  Future<void> deleteTeam(String id) async {
    await _firestore.collection('teams').doc(id).delete();
  }

  // Players
  Future<void> createPlayer(Player player) async {
    await _firestore
        .collection('players')
        .doc(player.id)
        .set(player.toFirestore());
  }

  Future<Player?> getPlayer(String id) async {
    final doc = await _firestore.collection('players').doc(id).get();
    if (doc.exists) {
      return Player.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<Player>> getPlayersByTeamStream(String teamId) {
    return _firestore
        .collection('players')
        .where('teamId', isEqualTo: teamId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Player>> getPlayersByTournamentStream(String tournamentId) {
    return _firestore
        .collection('players')
        .where('tournamentId', isEqualTo: tournamentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
    });
  }

  Future<void> updatePlayer(Player player) async {
    await _firestore
        .collection('players')
        .doc(player.id)
        .update(player.toFirestore());
  }

  Future<void> deletePlayer(String id) async {
    await _firestore.collection('players').doc(id).delete();
  }

  // Matches
  Future<void> createMatch(Match match) async {
    await _firestore
        .collection('matches')
        .doc(match.id)
        .set(match.toFirestore());
  }

  Future<Match?> getMatch(String id) async {
    final doc = await _firestore.collection('matches').doc(id).get();
    if (doc.exists) {
      return Match.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<Match>> getMatchesByTournamentStream(String tournamentId) {
    return _firestore
        .collection('matches')
        .where('tournamentId', isEqualTo: tournamentId)
        .orderBy('kickoffTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Match.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Match>> getLiveMatchesStream(String tournamentId) {
    return _firestore
        .collection('matches')
        .where('tournamentId', isEqualTo: tournamentId)
        .where('status', isEqualTo: MatchStatus.live.index)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Match.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateMatch(Match match) async {
    await _firestore
        .collection('matches')
        .doc(match.id)
        .update(match.toFirestore());
  }

  Future<void> deleteMatch(String id) async {
    await _firestore.collection('matches').doc(id).delete();
  }

  // News
  Future<void> createNews(News news) async {
    await _firestore
        .collection('news')
        .doc(news.id)
        .set(news.toFirestore());
  }

  Future<News?> getNews(String id) async {
    final doc = await _firestore.collection('news').doc(id).get();
    if (doc.exists) {
      return News.fromFirestore(doc);
    }
    return null;
  }

  Stream<List<News>> getNewsByTournamentStream(String tournamentId) {
    return _firestore
        .collection('news')
        .where('tournamentId', isEqualTo: tournamentId)
        .orderBy('publishedAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => News.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateNews(News news) async {
    await _firestore
        .collection('news')
        .doc(news.id)
        .update(news.toFirestore());
  }

  Future<void> deleteNews(String id) async {
    await _firestore.collection('news').doc(id).delete();
  }
}
