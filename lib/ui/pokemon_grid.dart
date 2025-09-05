import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import 'team_preview_page.dart';

class PokemonGrid extends StatelessWidget {
  final teamCtrl = Get.find<TeamController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(teamCtrl.teamName.value)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final controller =
                  TextEditingController(text: teamCtrl.teamName.value);
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text("Edit Team Name"),
                        content: TextField(controller: controller),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("Cancel")),
                          ElevatedButton(
                              onPressed: () {
                                teamCtrl.editTeamName(controller.text);
                                Navigator.pop(ctx);
                              },
                              child: const Text("Save")),
                        ],
                      ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: teamCtrl.resetTeam,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Pokémon...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => teamCtrl.searchQuery.value = value,
            ),
          ),

          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: teamCtrl.team.isEmpty
                    ? const Text("No Pokémon selected",
                        textAlign: TextAlign.center)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: teamCtrl.team.map((poke) {
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(poke["image"]!),
                                  ),
                                  GestureDetector(
                                    onTap: () => teamCtrl.togglePokemon(poke),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Icons.close,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(poke["name"]!.capitalizeFirst ?? "",
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          );
                        }).toList(),
                      ),
              )),

          Expanded(
            child: Obx(() {
              final filtered = teamCtrl.pokemons
                  .where((p) => p["name"]!
                      .toLowerCase()
                      .contains(teamCtrl.searchQuery.value.toLowerCase()))
                  .toList();

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
                  return PokemonCard(poke: poke);
                },
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () => Get.to(() => TeamPreviewPage()),
              child: const Text("View My Team",
                  style: TextStyle(fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }
}

class PokemonCard extends StatefulWidget {
  final Map<String, String> poke;
  const PokemonCard({super.key, required this.poke});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool isHovered = false;
  bool isPressed = false;

  final teamCtrl = Get.find<TeamController>();

  @override
  Widget build(BuildContext context) {
    final selected = teamCtrl.team
        .any((p) => p["name"] == widget.poke["name"]);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) {
          setState(() => isPressed = false);
          teamCtrl.togglePokemon(widget.poke);
        },
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedScale(
          scale: isPressed ? 0.95 : (isHovered ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isHovered || selected
                    ? Colors.deepPurple
                    : Colors.grey.shade300,
                width: isHovered || selected ? 2.5 : 1,
              ),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(widget.poke["image"]!,
                        width: 60, height: 60),
                    const SizedBox(height: 8),
                    Text(
                      widget.poke["name"]!.capitalizeFirst ?? "",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                AnimatedOpacity(
                  opacity: selected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.check_circle,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
