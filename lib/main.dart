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

            // ✅ แสดงทีมทั้งหมด
            ...teamCtrl.teams.asMap().entries.map((entry) {
              final index = entry.key;
              final team = entry.value;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🖼️ แสดงรูปโปเกมอนแนวนอน
                      Row(
                        children: (team["pokemons"] as List)
                            .take(3) // ✅ แสดงสูงสุด 3 ตัว
                            .map<Widget>((poke) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: CircleAvatar(
                                    radius: 24, // ✅ ขยายให้ใหญ่ขึ้น
                                    backgroundImage:
                                        NetworkImage(poke["image"]),
                                  ),
                                ))
                            .toList(),
                      ),

                      const SizedBox(width: 16), // ✅ เว้นระยะรูปกับข้อความ

                      // 📝 ข้อมูลทีม
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              team["name"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "${(team["pokemons"] as List).length} Pokémon",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // 👉 ปุ่ม action
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              Get.to(() => TeamPreviewPage(team: team));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              teamCtrl.teams.removeAt(index);
                              teamCtrl.saveToStorage();
                              Get.snackbar(
                                "Deleted",
                                "${team["name"]} has been removed",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
