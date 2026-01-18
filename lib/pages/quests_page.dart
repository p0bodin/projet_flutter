import 'package:flutter/material.dart';
import '../services/quests_service.dart';

// --- QUESTS PAGE ---
class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage> {
  List<bool> _checkedStates = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadQuestStates();
  }

  Future<void> _loadQuestStates() async {
    for (int i = 0; i < QuestsService.availableQuests.length; i++) {
      final isActive = await QuestsService.isQuestActive(i);
      setState(() {
        _checkedStates[i] = isActive;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150, 
              color: Colors.brown[200], 
              child: const Center(
                child: Text(
                  "QUESTS", 
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: QuestsService.availableQuests.length,
                itemBuilder: (context, index) {
                  final quest = QuestsService.availableQuests[index];
                  return ListTile(
                    title: Text(quest['title']!),
                    subtitle: Text(quest['description']!),
                    trailing: Checkbox(
                      value: _checkedStates[index],
                      onChanged: (value) async {
                        await QuestsService.toggleQuest(index);
                        setState(() {
                          _checkedStates[index] = value ?? false;
                        });
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
