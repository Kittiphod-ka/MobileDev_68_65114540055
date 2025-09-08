import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/team_controller.dart';
import 'services/api_service.dart';
import 'ui/pokemon_grid.dart';
import 'ui/team_preview_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.lazyPut<ApiService>(() => ApiService());
  Get.lazyPut<TeamController>(() => TeamController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Team Builder',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final teamCtrl = Get.find<TeamController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Team Builder")),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => PokemonGrid());
              },
              child: const Text("Create New Team"),
            ),
            const SizedBox(height: 20),
            Text("Saved Teams:",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...teamCtrl.teams.asMap().entries.map((entry) {
              final team = entry.value;
              return Card(
                child: ListTile(
                  title: Text(team["name"]),
                  subtitle:
                      Text("${(team["pokemons"] as List).length} Pokémon"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Get.to(() => TeamPreviewPage(team: team));
                  },
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
