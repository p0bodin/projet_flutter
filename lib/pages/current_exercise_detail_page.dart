import 'package:flutter/material.dart';
import '../services/activities_storage.dart';
import '../services/current_exercise_service.dart';


class CurrentExerciseDetailPage extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const CurrentExerciseDetailPage({
    super.key,
    required this.exercise,
  });

  @override
  State<CurrentExerciseDetailPage> createState() => _CurrentExerciseDetailPageState();
}

class _CurrentExerciseDetailPageState extends State<CurrentExerciseDetailPage> {
  late final TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _markAsDone() async {
    // Save to history (only when Done is clicked)
    await ActivityStorage.saveActivity(
      exercise: widget.exercise['exercise'] ?? 'Unknown',
      series: widget.exercise['series'],
      reps: widget.exercise['reps'],
      rest: widget.exercise['rest'],
      intensity: widget.exercise['intensity'],
      trainingTime: widget.exercise['trainingTime'],
    );

    // Clear current exercise
    await CurrentExerciseService.clearCurrentExercise();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Exercise completed! Added to training history."),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true); // Return true to refresh home page
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise['exercise'] ?? 'Unknown';
    final series = widget.exercise['series'];
    final reps = widget.exercise['reps'];
    final rest = widget.exercise['rest'];
    final intensity = widget.exercise['intensity'];
    final trainingTime = widget.exercise['trainingTime'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Exercise Details", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailsSection(),
                  const SizedBox(height: 24),
                  _buildFeedbackSection(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                onPressed: _markAsDone,
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text("Done", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    final series = widget.exercise['series'];
    final reps = widget.exercise['reps'];
    final rest = widget.exercise['rest'];
    final intensity = widget.exercise['intensity'];
    final trainingTime = widget.exercise['trainingTime'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Exercise Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (series != null) _buildDetailRow("Series", series.toString()),
          if (reps != null) _buildDetailRow("Repetitions", reps.toString()),
          if (rest != null) _buildDetailRow("Rest Time", "${rest}min"),
          if (intensity != null) _buildDetailRow("Intensity", "$intensity/10"),
          if (trainingTime != null) _buildDetailRow("Training Time", trainingTime),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Feedback (Optional)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "How did you feel? Any notes?",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
