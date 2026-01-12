import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home_page.dart';
import 'quests_page.dart';
import 'inventory_page.dart';
import 'fight_page.dart';
import 'training_page.dart';

// --- 2. STRUCTURE PRINCIPALE (NAVIGATION) ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Commence au Main Menu (Index 2)

  final List<Widget> _pages = [
    const QuestsPage(),
    const InventoryPage(),
    const HomePage(),
    const FightPage(),
    const TrainingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Nécessaire pour 5 items
        backgroundColor: Colors.grey[200],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Quests'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'Main Menu'), //
          BottomNavigationBarItem(icon: Icon(Icons.sports_martial_arts), label: 'Fight'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Training'),
        ],
      ),
    );
  }
}
