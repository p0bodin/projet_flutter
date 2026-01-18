import 'package:shared_preferences/shared_preferences.dart';

class UserStatsService {
  static Future<Map<String, int>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'level': prefs.getInt('level') ?? 0,
      'health': prefs.getInt('health') ?? 0,
      'strength': prefs.getInt('strength') ?? 0,
      'dexterity': prefs.getInt('dexterity') ?? 0,
      'endurance': prefs.getInt('endurance') ?? 0,
      'intelligence': prefs.getInt('intelligence') ?? 0,
    };
  }

  static Future<void> incrementStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Incrémenter toutes les stats
    final currentLevel = prefs.getInt('level') ?? 0;
    final currentHealth = prefs.getInt('health') ?? 0;
    final currentStrength = prefs.getInt('strength') ?? 0;
    final currentDexterity = prefs.getInt('dexterity') ?? 0;
    final currentEndurance = prefs.getInt('endurance') ?? 0;
    final currentIntelligence = prefs.getInt('intelligence') ?? 0;
    
    await prefs.setInt('level', currentLevel + 1);
    await prefs.setInt('health', currentHealth + 1);
    await prefs.setInt('strength', currentStrength + 1);
    await prefs.setInt('dexterity', currentDexterity + 1);
    await prefs.setInt('endurance', currentEndurance + 1);
    await prefs.setInt('intelligence', currentIntelligence + 1);
  }

  static Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', 0);
    await prefs.setInt('health', 0);
    await prefs.setInt('strength', 0);
    await prefs.setInt('dexterity', 0);
    await prefs.setInt('endurance', 0);
    await prefs.setInt('intelligence', 0);
  }
}
