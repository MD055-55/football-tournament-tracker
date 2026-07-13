import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class AppBottomNavigation extends ConsumerWidget {
  final int currentIndex;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups),
          label: 'Teams',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Players',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Stats',
        ),
      ],
      onTap: (index) {
        _navigateTo(context, index);
      },
    );
  }

  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/teams');
        break;
      case 3:
        context.go('/players');
        break;
      case 4:
        context.go('/standings');
        break;
    }
  }
}

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;

  const AppTopBar({
    Key? key,
    required this.title,
    this.actions,
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 0,
      actions: [
        ...?actions,
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMenuPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final int? bottomNavIndex;
  final List<Widget>? actions;

  const ScreenScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.bottomNavIndex,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: title,
        actions: actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavIndex != null
          ? AppBottomNavigation(currentIndex: bottomNavIndex!)
          : null,
    );
  }
}

class TournamentSelector extends StatelessWidget {
  final List tournaments;
  final String selectedId;
  final ValueChanged<String> onChanged;

  const TournamentSelector({
    Key? key,
    required this.tournaments,
    required this.selectedId,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: selectedId,
        decoration: InputDecoration(
          labelText: 'Select Tournament',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: tournaments
            .map((t) => DropdownMenuItem(
                  value: t.id,
                  child: Text(t.name),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class FilterChipGroup extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onSelected;

  const FilterChipGroup({
    Key? key,
    required this.options,
    this.selectedOption,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('All'),
              selected: selectedOption == null,
              onSelected: (selected) {
                onSelected(selected ? null : null);
              },
            ),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FilterChip(
                  label: Text(option),
                  selected: selectedOption == option,
                  onSelected: (selected) {
                    onSelected(selected ? option : null);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class RefreshIndicatorWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onRefresh;

  const RefreshIndicatorWrapper({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: child,
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
