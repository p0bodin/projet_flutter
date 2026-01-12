import 'package:flutter/material.dart';
import 'main_screen.dart' show MainScreen;


// --- 1. PAGE DE LOGIN ---
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("LEVELER", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const Spacer(),
              // Placeholder pour l'image du chevalier
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                child: const Icon(Icons.person_4, size: 100, color: Colors.grey),
              ),
              const Spacer(),
              _buildSocialButton(Icons.g_mobiledata, "Continue with Google"),
              const SizedBox(height: 12),
              _buildSocialButton(Icons.facebook, "Continue with Facebook"),
              const SizedBox(height: 12),
              _buildSocialButton(Icons.apple, "Continue with Apple"),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5E548E), foregroundColor: Colors.white),
                onPressed: () {
                  // Navigation vers le menu principal
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
                },
                child: const Text("ENTER THE DUNGEON (DEMO)"),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSocialButton(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
