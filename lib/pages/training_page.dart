import 'package:flutter/material.dart';
import 'sports_page.dart';
import 'exercise_detail_page.dart';
import '../services/activities_storage.dart';

// --- TRAINING PAGE ---
class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String _selectedTab = "Upper body";
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final activities = await ActivityStorage.getActivities();
    setState(() {
      _activities = activities;
    });
  }

  Future<void> _clearHistory() async {
    await ActivityStorage.clearActivities();
    setState(() {
      _activities = [];
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Historic cleared successfully!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[400],
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            child: const Text("Training", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _buildCategoryChip(context, "Upper body", _selectedTab == "Upper body"),
                _buildCategoryChip(context, "Lower body", _selectedTab == "Lower body"),
                _buildCategoryChip(context, "Cardio", _selectedTab == "Cardio"),
                _buildCategoryChip(context, "Sports", _selectedTab == "Sports", isLink: true),
                _buildCategoryChip(context, "Historic", _selectedTab == "Historic"),
              ],
            ),
          ),
          
          Expanded(
            child: _selectedTab == "Historic"
                ? _buildHistoricView()
                : ListView(
                    children: _getExercisesForTab(_selectedTab),
                  ),
          )
        ],
      ),
    );
  }

  List<Widget> _getExercisesForTab(String tab) {
    if (tab == "Upper body") {
      return [
        _buildExerciseTile(context, "Bench press", "Upper body"),
        _buildExerciseTile(context, "Dumbbell curl", "Upper body"),
        _buildExerciseTile(context, "Horizontal rowing", "Upper body"),
        _buildExerciseTile(context, "Pull-ups", "Upper body"),
        _buildExerciseTile(context, "Shoulder press", "Upper body"),
        _buildExerciseTile(context, "Lateral raises", "Upper body"),
        _buildExerciseTile(context, "Tricep dips", "Upper body"),
        _buildExerciseTile(context, "Barbell rows", "Upper body"),
        _buildExerciseTile(context, "Incline press", "Upper body"),
        _buildExerciseTile(context, "Face pulls", "Upper body"),
        _buildExerciseTile(context, "Push ups", "Upper body"),
        _buildExerciseTile(context, "Rowing", "Upper body"),
      ];
    } else if (tab == "Lower body") {
      return [
        _buildExerciseTile(context, "Squats", "Lower body"),
        _buildExerciseTile(context, "Deadlifts", "Lower body"),
        _buildExerciseTile(context, "Leg press", "Lower body"),
        _buildExerciseTile(context, "Leg curl", "Lower body"),
        _buildExerciseTile(context, "Leg extension", "Lower body"),
        _buildExerciseTile(context, "Lunges", "Lower body"),
        _buildExerciseTile(context, "Calf raises", "Lower body"),
        _buildExerciseTile(context, "Hip thrusts", "Lower body"),
        _buildExerciseTile(context, "Bulgarian split squats", "Lower body"),
        _buildExerciseTile(context, "Step-ups", "Lower body"),
      ];
    } else if (tab == "Cardio") {
      return [
        _buildExerciseTile(context, "Running", "Cardio"),
        _buildExerciseTile(context, "Cycling", "Cardio"),
        _buildExerciseTile(context, "Swimming", "Cardio"),
        _buildExerciseTile(context, "Rowing", "Cardio"),
        _buildExerciseTile(context, "Jump rope", "Cardio"),
        _buildExerciseTile(context, "Hiking", "Cardio"),
      ];
    }
    return [];
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip( 
        label: Text(label),
        backgroundColor: isSelected ? const Color(0xFF5E548E).withValues(alpha: 0.3) : Colors.grey[200],
        onPressed: () {
          if (isLink && label == "Sports") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SportsPage()));
          } else {
            setState(() => _selectedTab = label);
          }
        },
      ),
    );
  }

  Widget _buildHistoricView() {
    return _activities.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No activities yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        : Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Your Activities",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Clear Historic"),
                                  content: const Text("Are you sure you want to delete all activities?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _clearHistory();
                                      },
                                      child: const Text("Clear", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text("Clear", style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._activities.map((activity) => _buildActivityCard(
                        date: activity['date'],
                        exercise: activity['exercise'],
                        series: activity['series'],
                        reps: activity['reps'],
                        rest: activity['rest'],
                        intensity: activity['intensity'],
                        trainingTime: activity['trainingTime'],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildActivityCard({
    required String date,
    required String exercise,
    int? series,
    int? reps,
    int? rest,
    int? intensity,
    String? trainingTime,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFDEE2E6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exercise,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (series != null && reps != null && rest != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActivityStat("Series", series.toString()),
                  _buildActivityStat("Reps", reps.toString()),
                  _buildActivityStat("Rest (min)", rest.toString()),
                ],
              )
            else if (intensity != null && trainingTime != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActivityStat("Intensity", intensity.toString()),
                  _buildActivityStat("Duration", trainingTime),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5E548E)),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }


  Widget _buildExerciseTile(BuildContext context, String title, String subtitle) {
    final exerciseImages = {
      // Upper body
      "Bench press": "https://images.unsplash.com/photo-1541534227574-75925b47b93f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Dumbbell curl": "https://images.unsplash.com/photo-1566241142559-40e1dab266c6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Horizontal rowing": "https://images.unsplash.com/photo-1598971668194-2800a0868ff2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Pull-ups": "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Shoulder press": "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Lateral raises": "https://images.unsplash.com/photo-1585081919301-d68bb1e56f4c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Tricep dips": "https://images.unsplash.com/photo-1590127957257-5fc5005a1efc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Barbell rows": "https://images.unsplash.com/photo-1574258495101-e6eb995e5ffc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Incline press": "https://images.unsplash.com/photo-1536126613408-ebf12864da65?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Face pulls": "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Push ups": "https://images.unsplash.com/photo-1589906950481-4a98b6e6d4ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      // Lower body
      "Squats": "https://images.unsplash.com/photo-1520868369591-8b5cf50b28b5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Deadlifts": "https://images.unsplash.com/photo-1552969014-ef4d0c6decfd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Leg press": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Leg curl": "https://images.unsplash.com/photo-1586370485868-e1ca2c7d3d1f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Leg extension": "https://images.unsplash.com/photo-1605296867004-952d768bfd3d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Lunges": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Calf raises": "https://images.unsplash.com/photo-1540497077202-348b34a33cf5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Hip thrusts": "https://images.unsplash.com/photo-1595909352602-8b46eaa8d185?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Bulgarian split squats": "https://images.unsplash.com/photo-1609899753584-1f82acf1350c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Step-ups": "https://images.unsplash.com/photo-1589826776705-7d5b2b0ad896?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      // Cardio
      "Running": "https://images.unsplash.com/photo-1462684590857-2a5ad9d642af?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Cycling": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Swimming": "https://images.unsplash.com/photo-1576610616656-d3aa5d1f4fabc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Rowing": "https://images.unsplash.com/photo-1599439810694-cd5fb71b4de6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      "Jump rope": "https://images.unsplash.com/photo-1517836357463-d25ddfcbf042?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    };

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFDEE2E6),
      child: ListTile(
        leading: Container(width: 50, height: 50, color: Colors.grey[400], child: const Icon(Icons.fitness_center)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.favorite_border),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExerciseDetailPage(
                exerciseTitle: title,
                imageUrl: exerciseImages[title],
              ),
            ),
          );
        },
      ),
    );
  }
}
