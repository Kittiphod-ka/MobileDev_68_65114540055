import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class TeamPreviewPage extends StatelessWidget {
  final teamCtrl = Get.find<TeamController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Pokémon Team")),
      body: Obx(() {
        if (teamCtrl.team.isEmpty) {
          return const Center(child: Text("No Pokémon selected yet!"));
        }
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                teamCtrl.teamName.value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            ...teamCtrl.team.map((poke) => Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Image.network(poke["image"]!, width: 40),
                    title: Text(poke["name"]!.capitalizeFirst ?? ""),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => teamCtrl.togglePokemon(poke),
                    ),
                  ),
                )),
          ],
        );
      }),
    );
  }
}
