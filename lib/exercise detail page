import 'package:flutter/material.dart';
import 'exercise_page.dart';
import '../services/activity_storage.dart';


class ExerciseDetailPage extends StatefulWidget {
  final String exerciseTitle;
  final String? imageUrl;
 
  const ExerciseDetailPage({
    super.key,
    required this.exerciseTitle,
    this.imageUrl,
  });


  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}


class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  late final TextEditingController _timeController;
  late final TextEditingController _seriesController;
  late final TextEditingController _repsController;


  double _intensity = 5.0;
  bool _trainingWithGame = true;
  bool _trainingOnly = false;
  bool _gameTime = false;


  final Color _primaryColor = const Color(0xFF5E548E);
  final Color _cardColor = const Color(0xFFE9ECEF);


  final List<String> ballSports = [
    "Basketball",
    "Football",
    "Tennis",
    "Volleyball",
    "Ping-Pong",
    "Badminton",
    "Rugby",
  ];


  bool _isBallSport() {
    return ballSports.contains(widget.exerciseTitle);
  }


  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController();
    _seriesController = TextEditingController();
    _repsController = TextEditingController();
  }


  @override
  void dispose() {
    _timeController.dispose();
    _seriesController.dispose();
    _repsController.dispose();
    super.dispose();
  }


  void _validateAndReset() {
    // Save activity to history
    if (_isBallSport()) {
      // Sports activity
      ActivityStorage.saveActivity(
        exercise: widget.exerciseTitle,
        intensity: _intensity.toInt(),
        trainingTime: _timeController.text.isNotEmpty ? "${_timeController.text} hours" : "N/A",
      );
    } else {
      // Exercise activity
      ActivityStorage.saveActivity(
        exercise: widget.exerciseTitle,
        series: _seriesController.text.isNotEmpty ? int.tryParse(_seriesController.text) : null,
        reps: _repsController.text.isNotEmpty ? int.tryParse(_repsController.text) : null,
        rest: _timeController.text.isNotEmpty ? int.tryParse(_timeController.text) : null,
      );
    }
   
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Validated! Activity saved to history!"),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exerciseTitle,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 16),


                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                      image: widget.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(widget.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.imageUrl == null
                        ? const Center(child: Text("Animation/Video"))
                        : null,
                  ),
                  const SizedBox(height: 24),


                  if (_isBallSport()) ...[
                    _buildSectionCard(
                      title: "Feeling on the intensity",
                      subtitle: "Rate your sport's session",
                      content: Column(
                        children: [
                          const SizedBox(height: 10),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: _primaryColor,
                              inactiveTrackColor: _primaryColor.withValues(alpha: 0.2),
                              thumbColor: _primaryColor,
                              overlayColor: _primaryColor.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: _intensity,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              onChanged: (value) => setState(() => _intensity = value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSectionCard(
                      title: "Training time",
                      subtitle: "Enter your training time in hours",
                      content: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Text Here",
                            labelText: "Enter",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ),
                    _buildSectionCard(
                      title: "Type of training",
                      subtitle: null,
                      content: Column(
                        children: [
                          _buildSwitchRow("Training with game times", _trainingWithGame,
                              (v) => setState(() => _trainingWithGame = v)),
                          _buildSwitchRow(
                              "Training only", _trainingOnly, (v) => setState(() => _trainingOnly = v)),
                          _buildSwitchRow("Game time", _gameTime, (v) => setState(() => _gameTime = v)),
                        ],
                      ),
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        final descriptions = {
                          "Bench press": "The bench press is performed in the following steps:\n1. Setup: Lie flat on a bench with your feet firmly planted on the floor, arching your back lightly while keeping your shoulders pinned back and down.\n2. Grip and Lift-Off: Grip the bar slightly wider than shoulder-width. Unrack the bar by extending your arms fully over your chest.\n3. Descent (Lowering): Lower the bar slowly and with control toward the middle of your chest, arms at about a 45-degree angle and your forearms remain vertical.\n4. Drive (Rising): Press the bar carefully by pushing your feet into the floor (leg drive) and extending your elbows fully.",
                          "Dumbbell curl": "The dumbbell curl is performed in the following steps:\n1. Setup: Stand with your feet shoulder-width apart, holding dumbbells at your sides with your arms fully extended and palms facing forward.\n2. Grip: Keep a firm grip with your palms facing each other or slightly forward.\n3. Curl: Bend your elbows and raise the dumbbells toward your shoulders in a controlled motion, keeping your elbows stationary.\n4. Lower: Slowly lower the dumbbells back to the starting position with control.",
                          "Horizontal rowing": "The horizontal rowing is performed in the following steps:\n1. Setup: Position yourself on a horizontal machine or bench with your feet firmly on the ground.\n2. Grip: Hold the handles with a firm grip at chest height, keeping your back straight.\n3. Pull: Pull the handles toward your chest, squeezing your shoulder blades together at the peak of the movement.\n4. Return: Slowly extend your arms back to the starting position with control.",
                          "Pull-ups": "Pull-ups are performed in the following steps:\n1. Setup: Hang from a pull-up bar with your hands slightly wider than shoulder-width apart, palms facing away.\n2. Grip: Maintain a firm grip on the bar throughout the movement.\n3. Pull: Pull yourself upward by engaging your back muscles, bringing your chin above the bar.\n4. Lower: Slowly lower yourself back to the starting position with control.",
                          "Shoulder press": "The shoulder press is performed in the following steps:\n1. Setup: Sit on a bench with your back against the backrest, feet firmly planted on the ground.\n2. Grip: Hold dumbbells or a barbell at shoulder height with elbows bent at 90 degrees.\n3. Press: Push the weight upward and slightly forward until your arms are fully extended overhead.\n4. Lower: Slowly lower the weight back to shoulder height with control.",
                          "Lateral raises": "Lateral raises are performed in the following steps:\n1. Setup: Stand with your feet shoulder-width apart, holding dumbbells at your sides with a slight bend in your elbows.\n2. Engage: Engage your core and maintain an upright posture throughout the movement.\n3. Raise: Lift the dumbbells out to the sides until they reach shoulder height, maintaining a slight elbow bend.\n4. Lower: Slowly lower the dumbbells back to your sides with control.",
                          "Tricep dips": "Tricep dips are performed in the following steps:\n1. Setup: Position yourself on parallel bars or a dip machine with your body upright.\n2. Lower: Lower your body by bending your elbows until your upper arms are parallel to the ground.\n3. Push: Push through your hands to raise your body back to the starting position.\n4. Repeat: Maintain controlled movement throughout the exercise.",
                          "Barbell rows": "Barbell rows are performed in the following steps:\n1. Setup: Stand with your feet hip-width apart, knees slightly bent, holding a barbell with hands slightly wider than shoulder-width.\n2. Hinge: Hinge forward at the hips, keeping your back straight until your torso is nearly parallel to the ground.\n3. Pull: Pull the barbell toward your chest, squeezing your back muscles at the top of the movement.\n4. Lower: Lower the barbell back down with control.",
                          "Incline press": "The incline press is performed in the following steps:\n1. Setup: Sit on an incline bench (set at 45 degrees) with your back firmly against the backrest.\n2. Grip: Hold dumbbells or a barbell at shoulder height with elbows bent at 90 degrees.\n3. Press: Push the weight upward and slightly forward until your arms are fully extended.\n4. Lower: Slowly lower the weight back to shoulder height with control.",
                          "Face pulls": "Face pulls are performed in the following steps:\n1. Setup: Stand facing a cable machine with the rope attachment set at head height.\n2. Grip: Hold the rope with both hands, elbows bent at 90 degrees.\n3. Pull: Pull the rope toward your face, spreading the rope ends apart as you pull.\n4. Squeeze: Squeeze your shoulder blades together at the top, then slowly return to the starting position.",
                          "Push ups": "Push ups are performed in the following steps:\n1. Setup: Start in a plank position with hands slightly wider than shoulder-width apart.\n2. Body: Keep your body straight from head to heels, engaging your core.\n3. Lower: Lower your body by bending your elbows until your chest nearly touches the ground.\n4. Push: Push through your hands to extend your arms and return to the starting position.",
                          // Lower body exercises
                          "Squats": "Squats are performed in the following steps:\n1. Setup: Stand with your feet shoulder-width apart, toes pointing slightly outward, hands held in front of you or behind your head.\n2. Lower: Bend your knees and hips, lowering your body as if sitting in a chair, keeping your chest up and weight in your heels.\n3. Bottom position: Descend until your thighs are parallel to the ground or lower, maintaining a straight back.\n4. Rise: Drive through your heels and extend your legs to return to the starting position.",
                          "Deadlifts": "Deadlifts are performed in the following steps:\n1. Setup: Stand with feet hip-width apart, barbell over mid-foot, shoulders over the bar.\n2. Grip: Grip the bar with hands slightly wider than shoulder-width, arms straight.\n3. Lift: Drive through your legs while maintaining a neutral spine, pulling the bar up along your body.\n4. Lockout: Stand fully upright, shoulders back, then lower the bar back to the ground with control.",
                          "Leg press": "Leg press is performed in the following steps:\n1. Setup: Sit on the leg press machine with your back and head against the padding.\n2. Position: Place your feet on the platform about hip-width apart, toes pointing slightly outward.\n3. Lower: Lower the weight by bending your knees until your thighs are about parallel to the ground.\n4. Push: Push through your heels to extend your legs and return to the starting position.",
                          "Leg curl": "Leg curl is performed in the following steps:\n1. Setup: Lie face down on the leg curl machine with the lever pad positioned just above your heels.\n2. Grip: Hold the handles for stability and engage your core.\n3. Curl: Bend your knees and curl the weight up toward your glutes, contracting your hamstrings.\n4. Lower: Slowly lower the weight back to the starting position with control.",
                          "Leg extension": "Leg extension is performed in the following steps:\n1. Setup: Sit on the leg extension machine with your back firmly against the pad.\n2. Position: Place your feet under the leg extension pad and grip the handles.\n3. Extend: Straighten your legs and lift the weight, fully extending your knees at the top.\n4. Lower: Slowly lower the weight back down, stopping just short of full leg bend.",
                          "Lunges": "Lunges are performed in the following steps:\n1. Setup: Stand with feet together, hands on hips or holding dumbbells.\n2. Step: Step forward with one leg, lowering your hips until both knees bend to about 90 degrees.\n3. Position: Keep your chest up and front knee over ankle.\n4. Push back: Push through your front heel and return to the starting position, then repeat with the other leg.",
                          "Calf raises": "Calf raises are performed in the following steps:\n1. Setup: Stand with feet hip-width apart, hands on a wall or holding dumbbells for balance.\n2. Rise: Push through your toes and raise your heels up as high as possible, standing on the balls of your feet.\n3. Hold: Hold the top position for a moment, feeling the calf muscles contract.\n4. Lower: Slowly lower your heels back to the ground with control.",
                          "Hip thrusts": "Hip thrusts are performed in the following steps:\n1. Setup: Sit on the ground with your upper back against a bench, feet flat on the ground in front of you.\n2. Position: Position a barbell or weight across your hips, holding it securely.\n3. Thrust: Drive through your heels and thrust your hips upward, squeezing your glutes at the top.\n4. Lower: Lower your hips back down to the starting position with control.",
                          "Bulgarian split squats": "Bulgarian split squats are performed in the following steps:\n1. Setup: Stand facing away from a bench, one foot elevated on the bench behind you.\n2. Position: Hold dumbbells at your sides or for balance.\n3. Lower: Lower your front knee toward the ground, bending until your front thigh is parallel to the ground.\n4. Rise: Push through your front heel to return to the starting position, repeat, then switch legs.",
                          "Step-ups": "Step-ups are performed in the following steps:\n1. Setup: Stand in front of a sturdy bench or step, holding dumbbells if desired.\n2. Step: Step up with one leg onto the bench, driving through your heel.\n3. Follow: Bring your back leg up to step fully onto the bench, standing upright at the top.\n4. Descend: Step back down with one leg, then the other, and repeat.",
                        };


                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExercisePage(
                              exerciseTitle: widget.exerciseTitle,
                              category: widget.exerciseTitle,
                              description: descriptions[widget.exerciseTitle] ?? "No description available",
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Text(
                              "Details of the exercise",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 16, color: Colors.black87),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: "Enter your serie(s)",
                      subtitle: null,
                      content: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _seriesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter series",
                          ),
                        ),
                      ),
                    ),
                    _buildSectionCard(
                      title: "Enter your repetitions",
                      subtitle: null,
                      content: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _repsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter rep",
                          ),
                        ),
                      ),
                    ),
                    _buildSectionCard(
                      title: "Rest time between series (mins)",
                      subtitle: null,
                      content: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter rest",
                          ),
                        ),
                      ),
                    ),
                  ],


                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
                onPressed: _validateAndReset,
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text("Validate the data", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center, color: Colors.white70),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                if (subtitle != null)
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                content,
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: _primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
