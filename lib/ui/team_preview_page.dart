import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pokemon_detail_page.dart';

class TeamPreviewPage extends StatelessWidget {
  final Map<String, dynamic> team;
  const TeamPreviewPage({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    final pokemons = team["pokemons"] as List;

    return Scaffold(
      appBar: AppBar(title: Text(team["name"])),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final poke = pokemons[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Colors.deepPurple.shade200, width: 1),
                  ),
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(poke["image"], width: 80, height: 80),
                      const SizedBox(height: 8),
                      Text(
                        (poke["name"] ?? "").toString().capitalize ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 📌 ปุ่มไปหน้า PokemonDetailPage
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => PokemonDetailPage(team: team));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("View Pokémon Details"),
            ),
          ),
        ],
      ),
    );
  }
}
