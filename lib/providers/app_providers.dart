import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tournament_model.dart';
import '../models/team_model.dart';
import '../models/player_model.dart';
import '../models/match_model.dart';
import '../models/news_model.dart';
import '../services/firebase_service.dart';

final firebaseServiceProvider = Provider((ref) => FirebaseService());

// Tournament Providers
final tournamentProvider =
    FutureProvider.family<Tournament?, String>((ref, id) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getTournament(id);
});

final tournamentsStreamProvider = StreamProvider<List<Tournament>>((ref) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getTournamentsStream();
});

// Team Providers
final teamProvider = FutureProvider.family<Team?, String>((ref, id) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getTeam(id);
});

final teamsByTournamentProvider =
    StreamProvider.family<List<Team>, String>((ref, tournamentId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getTeamsByTournamentStream(tournamentId);
});

// Player Providers
final playerProvider = FutureProvider.family<Player?, String>((ref, id) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getPlayer(id);
});

final playersByTeamProvider =
    StreamProvider.family<List<Player>, String>((ref, teamId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getPlayersByTeamStream(teamId);
});

final playersByTournamentProvider =
    StreamProvider.family<List<Player>, String>((ref, tournamentId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getPlayersByTournamentStream(tournamentId);
});

// Match Providers
final matchProvider = FutureProvider.family<Match?, String>((ref, id) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getMatch(id);
});

final matchesByTournamentProvider =
    StreamProvider.family<List<Match>, String>((ref, tournamentId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getMatchesByTournamentStream(tournamentId);
});

final liveMatchesProvider =
    StreamProvider.family<List<Match>, String>((ref, tournamentId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getLiveMatchesStream(tournamentId);
});

// News Providers
final newsProvider = FutureProvider.family<News?, String>((ref, id) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getNews(id);
});

final newsByTournamentProvider =
    StreamProvider.family<List<News>, String>((ref, tournamentId) {
  final service = ref.watch(firebaseServiceProvider);
  return service.getNewsByTournamentStream(tournamentId);
});
