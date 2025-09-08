import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class PokemonGrid extends StatelessWidget {
  final teamCtrl = Get.find<TeamController>();

  PokemonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: teamCtrl.teamName.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Your Team"),
        actions: [
          // 🔗 Reset team
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: teamCtrl.resetSelected,
          ),
        ],
      ),
      body: Column(
        children: [
          // ✏️ กรอกชื่อทีม
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Team Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                teamCtrl.editTeamName(value);
              },
            ),
          ),

          // 💡 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Pokémon...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                teamCtrl.searchQuery.value = value.toLowerCase();
              },
            ),
          ),

          // 👥 Selected preview
          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: teamCtrl.selected.isEmpty
                    ? const Text("No Pokémon selected",
                        textAlign: TextAlign.center)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: teamCtrl.selected.map((poke) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(poke["image"]!),
                              ),
                              const SizedBox(height: 4),
                              Text(poke["name"]!.capitalize ?? "",
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          );
                        }).toList(),
                      ),
              )),

          // 🟪 Pokémon Grid
          Expanded(
            child: Obx(() {
              final filtered = teamCtrl.pokemons.where((p) {
                return p["name"]!
                    .toLowerCase()
                    .contains(teamCtrl.searchQuery.value);
              }).toList();

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final poke = filtered[i];
                  final selected = teamCtrl.selected
                      .any((p) => p["name"] == poke["name"]);

                  return GestureDetector(
                    onTap: () => teamCtrl.togglePokemon(poke),
                    child: AnimatedScale(
                      scale: selected ? 0.95 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: selected
                                ? Colors.deepPurple
                                : Colors.grey.shade300,
                            width: selected ? 2.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(poke["image"]!,
                                width: 60, height: 60),
                            const SizedBox(height: 6),
                            Text(poke["name"]!.capitalize ?? ""),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // 📥 Save team button
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                teamCtrl.saveTeam();
                Get.back(); // กลับไปหน้า Main หลังบันทึก
                Get.snackbar("Saved", "Your team has been saved!");
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              child: const Text("Save Team"),
            ),
          ),
        ],
      ),
    );
  }
}
