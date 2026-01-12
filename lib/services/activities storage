import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ActivityStorage {
  static Future<void> saveActivity({
    required String exercise,
    int? series,
    int? reps,
    int? rest,
    int? intensity,
    String? trainingTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? activitiesJson = prefs.getString('activities');
   
    List<Map<String, dynamic>> activities = [];
    if (activitiesJson != null) {
      activities = List<Map<String, dynamic>>.from(jsonDecode(activitiesJson));
    }


    activities.insert(0, {
      'exercise': exercise,
      'date': DateTime.now().toString().split('.')[0],
      'series': series,
      'reps': reps,
      'rest': rest,
      'intensity': intensity,
      'trainingTime': trainingTime,
    });


    await prefs.setString('activities', jsonEncode(activities));
  }


  static Future<void> clearActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activities');
  }


  static Future<List<Map<String, dynamic>>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? activitiesJson = prefs.getString('activities');
    if (activitiesJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(activitiesJson));
    }
    return [];
  }
}
