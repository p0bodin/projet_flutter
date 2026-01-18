import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExerciseHistoryService {
  static Future<void> addToHistory(Map<String, dynamic> exercise) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    
    // Ajouter la date de complétion
    final completedExercise = Map<String, dynamic>.from(exercise);
    completedExercise['completedAt'] = DateTime.now().toString().split('.')[0];
    
    history.insert(0, completedExercise); // Ajouter au début de la liste
    
    await prefs.setString('exercise_history', jsonEncode(history));
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('exercise_history');
    
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    
    return [];
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('exercise_history');
  }

  static Future<void> removeFromHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setString('exercise_history', jsonEncode(history));
    }
  }
}
