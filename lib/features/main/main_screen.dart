import 'package:flutter/material.dart';
import 'package:trash_hunt/features/main/home/views/home_screen.dart';
import 'package:trash_hunt/features/main/profile/views/profile_screen.dart';
import 'package:trash_hunt/features/main/quests/views/quest_screen.dart';
import 'package:trash_hunt/widgets/app_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, required this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    HomeScreen(),
    QuestScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
          currentIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i)
      ),
    );
  }
}
