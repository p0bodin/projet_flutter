import 'package:flutter/material.dart';


// --- INVENTORY PAGE ---
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory"), centerTitle: true),
      body: Column(
        children: [
           SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: const [Chip(label: Text("Helmets")), Chip(label: Text("Chestplates")), Chip(label: Text("Pants"))])),
           Expanded(
             child: GridView.builder(
               padding: const EdgeInsets.all(10),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, crossAxisSpacing: 10, mainAxisSpacing: 10),
               itemCount: 9,
               itemBuilder: (context, index) => Container(
                 decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.shield, size: 40, color: index == 0 ? Colors.red : Colors.grey), // Exemple item rouge "blocked"
                     Text(index == 0 ? "Midas Chest" : "Iron Armor", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                   ],
                 ),
               ),
             ),
           )
        ],
      ),
    );
  }
}
