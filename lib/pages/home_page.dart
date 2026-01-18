import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../theme/app_colors.dart';
import '../services/current_exercise_service.dart';
import '../services/activities_storage.dart';
import '../services/quests_service.dart';
import '../services/user_stats_service.dart';
import 'current_exercise_detail_page.dart';


// --- 3. PAGE HOME (STATS & AVATAR) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _currentExercises = [];
  List<Map<String, dynamic>> _activeQuests = [];
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();
  String _userName = "ludo";
  Map<String, int> _stats = {
    'level': 0,
    'health': 0,
    'strength': 0,
    'dexterity': 0,
    'endurance': 0,
    'intelligence': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentExercise();
    _loadSavedImage();
    _loadUserName();
    _loadActiveQuests();
    _loadStats();
  }

  Future<void> _loadCurrentExercise() async {
    final exercises = await CurrentExerciseService.getAllCurrentExercises();
    setState(() {
      _currentExercises = exercises;
    });
  }

  Future<void> _loadActiveQuests() async {
    final quests = await QuestsService.getActiveQuests();
    setState(() {
      _activeQuests = quests;
    });
  }

  Future<void> _loadStats() async {
    final stats = await UserStatsService.getStats();
    setState(() {
      _stats = stats;
    });
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('avatar_image_path');
    if (imagePath != null && await File(imagePath).exists()) {
      setState(() {
        _avatarImage = File(imagePath);
      });
    }
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_image_path', path);
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (name != null) {
      setState(() {
        _userName = name;
      });
    }
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  Future<void> _editUserName() async {
    final TextEditingController controller = TextEditingController(text: _userName);
    
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Your name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _userName = newName;
      });
      await _saveUserName(newName);
    }
  }

  Future<void> _refreshCurrentExercise() async {
    await _loadCurrentExercise();
  }

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      
      if (photo != null) {
        setState(() {
          _avatarImage = File(photo.path);
        });
        await _saveImagePath(photo.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icônes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.account_circle, size: 30),
                const Text("LEVELER", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Icon(Icons.settings, size: 30),
              ],
            ),
            const SizedBox(height: 20),
            
            // Ligne du haut : Image à gauche, Nom/Level/Stats à droite
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar (image) à gauche
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: _avatarImage != null
                        ? DecorationImage(
                            image: FileImage(_avatarImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    ),
                    child: _avatarImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Nom, Level et Stats à droite
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _editUserName,
                        child: Text("Name: $_userName", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Text("Level: ${_stats['level']}", style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 12),
                      Text(
                        "Health: ${_stats['health']}\nStrength: ${_stats['strength']}\nDexterity: ${_stats['dexterity']}\nEndurance: ${_stats['endurance']}\nIntelligence: ${_stats['intelligence']}",
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Current Quests
            if (_activeQuests.isNotEmpty) ...[
              const Text("Current Quests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _activeQuests.length,
                      itemBuilder: (context, index) {
                        final quest = _activeQuests[index];
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(quest['title'] ?? 'Quest'),
                                  content: Text(quest['description'] ?? ''),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Complete', style: TextStyle(color: Colors.green)),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (result == true) {
                                await QuestsService.completeQuest(index);
                                await UserStatsService.incrementStats();
                                await _loadActiveQuests();
                                await _loadStats();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Quest "${quest['title']}" completed!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Card(
                              color: AppColors.cardBg,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      quest['title'] ?? 'Quest',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      quest['description'] ?? '',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Current Exercise en dessous sur toute la largeur
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Current Exercises", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _currentExercises.isNotEmpty
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: ListView.builder(
                              itemCount: _currentExercises.length,
                              itemBuilder: (context, index) {
                                final exercise = _currentExercises[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final result = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('${exercise['exercise']}'),
                                          content: const Text('What do you want to do?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('View Details'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Mark as Completed', style: TextStyle(color: Colors.green)),
                                            ),
                                          ],
                                        ),
                                      );
                                      
                                      if (result == true) {
                                        // Ajouter à l'historique avant de supprimer
                                        await ActivityStorage.saveActivity(
                                          exercise: exercise['exercise'] ?? 'Unknown',
                                          series: exercise['series'],
                                          reps: exercise['reps'],
                                          rest: exercise['rest'],
                                          intensity: exercise['intensity'],
                                          trainingTime: exercise['trainingTime'],
                                        );
                                        await UserStatsService.incrementStats();
                                        await CurrentExerciseService.removeExercise(index);
                                        await _refreshCurrentExercise();
                                        await _loadStats();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${exercise['exercise']} succeeded!'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } else if (result == false) {
                                        final navResult = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CurrentExerciseDetailPage(exercise: exercise),
                                          ),
                                        );
                                        if (navResult == true) {
                                          await _refreshCurrentExercise();
                                        }
                                      }
                                    },
                                    child: _buildCurrentExerciseCard(exercise),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const Center(
                          child: Text("No exercise in progress", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                  ),
                ],
              ),
            ),
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

  Widget _buildCurrentExerciseCard(Map<String, dynamic> exerciseData) {
    final exercise = exerciseData['exercise'] ?? 'Unknown'; 
    final series = exerciseData['series'];  
    final reps = exerciseData['reps'];
    final rest = exerciseData['rest'];
    final intensity = exerciseData['intensity'];
    final trainingTime = exerciseData['trainingTime'];

    return Card(
      color: AppColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (series != null) Text("Series: $series", style: const TextStyle(fontSize: 12)),
            if (reps != null) Text("Reps: $reps", style: const TextStyle(fontSize: 12)),
            if (rest != null) Text("Rest: ${rest}min", style: const TextStyle(fontSize: 12)),
            if (intensity != null) Text("Intensity: $intensity/10", style: const TextStyle(fontSize: 12)),
            if (trainingTime != null) Text("Time: $trainingTime", style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
