import 'package:flutter/material.dart';


// --- FIGHT PAGE ---
class FightPage extends StatelessWidget {
  const FightPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(height: 200, color: Colors.blueGrey, child: const Center(child: Text("PVP ARENA STYLE"))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [Expanded(child: ElevatedButton(onPressed: (){}, child: const Text("Friendly"))), const SizedBox(width: 10), Expanded(child: ElevatedButton(onPressed: (){}, child: const Text("Ranked")))]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.grey),
                title: Text("Friend ${index+1}"),
                subtitle: Text("Level ${8+index} - Strength Lvl ${6+index}"),
                trailing: const Icon(Icons.favorite_border),
              ),
            ),
          )
        ],
      ),
    );
  }
}
