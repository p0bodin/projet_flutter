import 'package:flutter/material.dart';
import 'exercise_detail_page.dart';

// --- SPORTS PAGE ---
class SportsPage extends StatelessWidget {
  const SportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sports Team"), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSportTile(
            context,
            "Basketball",
            Icons.sports_basketball,
            "https://images.unsplash.com/photo-1546519638-68e109498ee2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
          _buildSportTile(
            context,
            "Football",
            Icons.sports_soccer,
            "https://images.unsplash.com/photo-1579952363873-27f3bde9be2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
          _buildSportTile(
            context,
            "Tennis",
            Icons.sports_tennis,
            "https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
          _buildSportTile(
            context,
            "Volleyball",
            Icons.sports_volleyball,
            "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
          _buildSportTile(
            context,
            "Ping-Pong",
            Icons.sports_tennis,
            "https://images.unsplash.com/photo-1565895917534-1f1282141cd8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
          _buildSportTile(
            context,
            "Badminton",
            Icons.sports_tennis,
            "https://images.unsplash.com/photo-1554224311-beee415c201f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
          _buildSportTile(
            context,
            "Rugby",
            Icons.sports_football,
            "https://images.unsplash.com/photo-1461896836934-ffe607ba8211?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
          ),
        ],
      ),
    );
  }

  Widget _buildSportTile(BuildContext context, String name, IconData icon, String imageUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFDEE2E6),
      child: ListTile(
        leading: Icon(icon, size: 40, color: const Color(0xFF5E548E)),
        title: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: const Text("Log your game time"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseDetailPage(
                exerciseTitle: name,
                imageUrl: imageUrl,
              ),
            ),
          );
        },
      ),
    );
  }
}
