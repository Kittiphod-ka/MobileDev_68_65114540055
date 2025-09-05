import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  final ApiService api = Get.find<ApiService>();
  final box = GetStorage();

  var pokemons = <Map<String, String>>[].obs;
  var team = <Map<String, String>>[].obs;
  var teamName = "My Pokémon Team".obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadPokemons();
    loadSavedTeam();
  }

  void loadPokemons() async {
    pokemons.value = await api.fetchPokemons();
  }

  void togglePokemon(Map<String, String> poke) {
    final exists = team.any((p) => p["name"] == poke["name"]);

    if (exists) {
      team.removeWhere((p) => p["name"] == poke["name"]);
    } else if (team.length < 3) {
      team.add(poke);
    } else {
      Get.snackbar("Limit Reached", "You can only select 3 Pokémon!");
    }
    saveTeam();
  }

  void resetTeam() {
    team.clear();
    saveTeam();
  }

  void saveTeam() {
    box.write("team", team.toList());
    box.write("teamName", teamName.value);
  }

  void loadSavedTeam() {
    final savedTeam = box.read("team");
    final savedName = box.read("teamName");

    if (savedTeam != null) {
      team.value = List<Map<String, String>>.from(
          savedTeam.map((e) => Map<String, String>.from(e)));
    }
    if (savedName != null) {
      teamName.value = savedName;
    }
  }

  void editTeamName(String name) {
    teamName.value = name.trim().isEmpty ? "My Pokémon Team" : name.trim();
    saveTeam();
  }
}
