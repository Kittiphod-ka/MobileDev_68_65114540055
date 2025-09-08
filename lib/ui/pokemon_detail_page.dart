import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class PokemonDetailPage extends StatelessWidget {
  final teamCtrl = Get.find<TeamController>();
  final client = GetConnect();

  Future<Map<String, dynamic>> fetchPokemonDetails(String name) async {
    final response =
        await client.get("https://pokeapi.co/api/v2/pokemon/$name");
    if (response.statusCode == 200) {
      return response.body;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Details")),
      body: Obx(() {
        if (teamCtrl.team.isEmpty) {
          return const Center(
            child: Text("โปรดเลือก Pokémon ก่อน",
                style: TextStyle(fontSize: 18)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: teamCtrl.team.length,
          itemBuilder: (context, index) {
            final poke = teamCtrl.team[index];
            final name = poke["name"]!;

            return FutureBuilder<Map<String, dynamic>>(
              future: fetchPokemonDetails(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Card(
                    child: ListTile(
                      title: Text(name.capitalizeFirst ?? ""),
                      subtitle: const Text("Failed to load details"),
                    ),
                  );
                }

                final data = snapshot.data!;
                final id = data["id"];
                final height = data["height"];
                final weight = data["weight"];
                final baseExp = data["base_experience"];
                final types = (data["types"] as List)
                    .map((t) => t["type"]["name"])
                    .join(", ");
                final abilities = (data["abilities"] as List)
                    .map((a) => a["ability"]["name"])
                    .join(", ");

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.network(
                      poke["image"]!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      name.capitalizeFirst ?? "",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: $id"),
                        Text("Height: $height"),
                        Text("Weight: $weight"),
                        Text("Base Exp: $baseExp"),
                        Text("Types: $types"),
                        Text("Abilities: $abilities"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
