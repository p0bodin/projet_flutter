import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


// --- 3. PAGE HOME (STATS & AVATAR) ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_circle, size: 30),
                const Text("LEVELER", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Icon(Icons.settings, size: 30),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Name: Larry", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Level: 8", style: TextStyle(fontSize: 18)),
            const Text("Next level in: 90 XP", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  // Colonne de gauche : Quêtes journalières
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Daily Quests ->", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildMiniQuestCard("Headline", "Description du..."),
                        _buildMiniQuestCard("Headline", "Description du..."),
                        const Spacer(),
                        const Text("Health: 100\nStrength: 23\nDexterity: 30\nEndurance: 50\nIntelligence 72"),
                        const Spacer(),
                      ],
                    ),
                  ),
                  // Colonne de droite : Avatar
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: Image.network(
                        'https://via.placeholder.com/200x300.png?text=Knight+Avatar', // Image temporaire
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildMiniQuestCard(String title, String subtitle) {
    return Card(
      color: AppColors.cardBg,
      child: ListTile(
        leading: const Icon(Icons.change_history),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
      ),
    );
  }
}
