import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuestsService {
  // Liste des quêtes disponibles
  static final List<Map<String, String>> availableQuests = [
    {'title': 'Morning Warrior', 'description': 'Complete a workout before 10 AM'},
    {'title': 'Consistency King', 'description': 'Train 3 days in a row'},
    {'title': 'Cardio Champion', 'description': 'Do 30 minutes of cardio'},
    {'title': 'Strength Builder', 'description': 'Complete 5 strength exercises'},
    {'title': 'Flexibility Master', 'description': 'Stretch for 15 minutes'},
  ];

  static Future<void> toggleQuest(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final activeQuests = await getActiveQuests();
    
    final quest = availableQuests[index];
    final questWithIndex = {...quest, 'originalIndex': index.toString()};
    
    // Vérifier si la quête est déjà active
    final existingIndex = activeQuests.indexWhere(
      (q) => q['originalIndex'] == index.toString()
    );
    
    if (existingIndex >= 0) {
      // Décocher : retirer de la liste
      activeQuests.removeAt(existingIndex);
    } else {
      // Cocher : ajouter à la liste
      activeQuests.add(questWithIndex);
    }
    
    await prefs.setString('active_quests', jsonEncode(activeQuests));
  }

  static Future<List<Map<String, dynamic>>> getActiveQuests() async {
    final prefs = await SharedPreferences.getInstance();
    final String? questsJson = prefs.getString('active_quests');
    
    if (questsJson != null) {
      final List<dynamic> decoded = jsonDecode(questsJson);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    
    return [];
  }

  static Future<bool> isQuestActive(int index) async {
    final activeQuests = await getActiveQuests();
    return activeQuests.any((q) => q['originalIndex'] == index.toString());
  }

  static Future<void> completeQuest(int activeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final activeQuests = await getActiveQuests();
    
    if (activeIndex >= 0 && activeIndex < activeQuests.length) {
      final quest = activeQuests[activeIndex];
      
      // Ajouter à l'historique
      final history = await getQuestHistory();
      final completedQuest = Map<String, dynamic>.from(quest);
      completedQuest['completedAt'] = DateTime.now().toString().split('.')[0];
      history.insert(0, completedQuest);
      await prefs.setString('quest_history', jsonEncode(history));
      
      // Retirer des quêtes actives
      activeQuests.removeAt(activeIndex);
      await prefs.setString('active_quests', jsonEncode(activeQuests));
    }
  }

  static Future<List<Map<String, dynamic>>> getQuestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('quest_history');
    
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    
    return [];
  }

  static Future<void> clearQuestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quest_history');
  }
}
