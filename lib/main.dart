import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/api_service.dart';
import 'controllers/team_controller.dart';
import 'ui/pokemon_grid.dart';

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
      home: PokemonGrid(),
    );
  }
}
