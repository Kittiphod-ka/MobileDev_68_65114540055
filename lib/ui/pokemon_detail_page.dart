import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';

class PokemonDetailPage extends StatelessWidget {
  final Map<String, dynamic> team;
  PokemonDetailPage({super.key, required this.team});

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
    final pokemons = team["pokemons"] as List;

    return Scaffold(
      appBar: AppBar(title: Text("${team["name"]} - Details")),
      body: ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final poke = pokemons[index];
          final name = poke["name"];

          return FutureBuilder<Map<String, dynamic>>(
            future: fetchPokemonDetails(name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return ListTile(
                  title: Text(name.toString().capitalize ?? ""),
                  subtitle: const Text("Failed to load details"),
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
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Image.network(poke["image"], width: 60, height: 60),
                  title: Text(name.toString().capitalize ?? ""),
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
      ),
    );
  }
}
