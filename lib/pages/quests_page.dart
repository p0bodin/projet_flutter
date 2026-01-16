import 'package:flutter/material.dart';

// --- QUESTS PAGE ---
class QuestsPage extends StatelessWidget {
  const QuestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 150, color: Colors.brown[200], child: const Center(child: Text("QUESTS IMAGE"))),
             Expanded(
               child: ListView.builder(
                 itemCount: 5,
                 itemBuilder: (context, index) => ListTile(
                   title: Text("Quest ${index + 1}"),
                   subtitle: const Text("Complete X, Y times"),
                   trailing: Checkbox(value: false, onChanged: (v){}),
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }
}
