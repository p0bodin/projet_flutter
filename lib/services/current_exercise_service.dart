import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CurrentExerciseService {
  static Future<void> saveCurrentExercise({
    required String exercise,
    int? series,
    int? reps,
    int? rest,
    int? intensity,
    String? trainingTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final exerciseData = {
      'exercise': exercise,
      'series': series,
      'reps': reps,
      'rest': rest,
      'intensity': intensity,
      'trainingTime': trainingTime,
      'date': DateTime.now().toString().split('.')[0],
    };
    
    // Récupérer la liste existante
    final List<Map<String, dynamic>> exercises = await getAllCurrentExercises();
    
    // Ajouter le nouvel exercice
    exercises.add(exerciseData);
    
    // Sauvegarder la liste mise à jour
    await prefs.setString('currentExercises', jsonEncode(exercises));
  }

  static Future<Map<String, dynamic>?> getCurrentExercise() async {
    final exercises = await getAllCurrentExercises();
    return exercises.isNotEmpty ? exercises.first : null;
  }

  static Future<List<Map<String, dynamic>>> getAllCurrentExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final String? exercisesJson = prefs.getString('currentExercises');
    
    if (exercisesJson != null) {
      final List<dynamic> decoded = jsonDecode(exercisesJson);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    
    // Migration: vérifier s'il y a un ancien exercice unique
    final String? oldExerciseJson = prefs.getString('currentExercise');
    if (oldExerciseJson != null) {
      final oldExercise = Map<String, dynamic>.from(jsonDecode(oldExerciseJson));
      await prefs.remove('currentExercise');
      await prefs.setString('currentExercises', jsonEncode([oldExercise]));
      return [oldExercise];
    }
    
    return [];
  }

  static Future<void> removeExercise(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final exercises = await getAllCurrentExercises();
    
    if (index >= 0 && index < exercises.length) {
      exercises.removeAt(index);
      await prefs.setString('currentExercises', jsonEncode(exercises));
    }
  }

  static Future<void> clearCurrentExercise() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentExercises');
    await prefs.remove('currentExercise');
  }
}
