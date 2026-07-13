import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/player_model.dart';
import '../../../providers/app_providers.dart';

class StandingsScreen extends ConsumerStatefulWidget {
  const StandingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends ConsumerState<StandingsScreen> {
  String selectedTournamentId = '';
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tournamentsAsync = ref.watch(tournamentsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics & Rankings'),
        elevation: 0,
      ),
      body: tournamentsAsync.when(
        data: (tournaments) {
          if (tournaments.isEmpty) {
            return const Center(
              child: Text('No tournaments available'),
            );
          }

          if (selectedTournamentId.isEmpty) {
            selectedTournamentId = tournaments.first.id;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedTournamentId,
                  items: tournaments
                      .map((t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTournamentId = value ?? '';
                    });
                  },
                ),
              ),
              _buildTabBar(),
              Expanded(
                child: _buildTabContent(context),
              ),
            ],
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(0, 'Top Scorers'),
          ),
          Expanded(
            child: _buildTab(1, 'Top Assists'),
          ),
          Expanded(
            child: _buildTab(2, 'MVP Ranking'),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    final playersAsync =
        ref.watch(playersByTournamentProvider(selectedTournamentId));

    return playersAsync.when(
      data: (players) {
        List<Player> sortedPlayers;

        switch (_currentTabIndex) {
          case 0:
            // Top Scorers
            sortedPlayers =
                List.from(players)..sort((a, b) => b.stats.goals.compareTo(a.stats.goals));
            break;
          case 1:
            // Top Assists
            sortedPlayers = List.from(players)
              ..sort((a, b) => b.stats.assists.compareTo(a.stats.assists));
            break;
          case 2:
            // MVP Ranking
            sortedPlayers = List.from(players)
              ..sort((a, b) => b.stats.averageRating.compareTo(a.stats.averageRating));
            break;
          default:
            sortedPlayers = players;
        }

        if (sortedPlayers.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedPlayers.length,
          itemBuilder: (context, index) {
            return _buildRankingCard(
              context,
              sortedPlayers[index],
              index + 1,
            );
          },
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text('Error: $error'),
        );
      },
    );
  }

  Widget _buildRankingCard(BuildContext context, Player player, int position) {
    String statValue;
    String statLabel;

    switch (_currentTabIndex) {
      case 0:
        statValue = player.stats.goals.toString();
        statLabel = 'Goals';
        break;
      case 1:
        statValue = player.stats.assists.toString();
        statLabel = 'Assists';
        break;
      case 2:
        statValue = player.stats.averageRating.toStringAsFixed(2);
        statLabel = 'Rating';
        break;
      default:
        statValue = '0';
        statLabel = '';
    }

    Color positionColor;
    if (position == 1) {
      positionColor = Colors.amber;
    } else if (position == 2) {
      positionColor = Colors.grey;
    } else if (position == 3) {
      positionColor = Colors.orange;
    } else {
      positionColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: positionColor,
              child: Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    player.teamId,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    statValue,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    statLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
