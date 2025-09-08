import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  final ApiService api = Get.find<ApiService>();
  final box = GetStorage();

  var pokemons = <Map<String, String>>[].obs;
  var selected = <Map<String, String>>[].obs; // ทีมที่กำลังเลือก
  var teams = <Map<String, dynamic>>[].obs;   // เก็บหลายทีม
  var teamName = "My Pokémon Team".obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadPokemons();
    loadSavedTeams();
  }

  void loadPokemons() async {
    pokemons.value = await api.fetchPokemons();
  }

  void togglePokemon(Map<String, String> poke) {
    final exists = selected.any((p) => p["name"] == poke["name"]);
    if (exists) {
      selected.removeWhere((p) => p["name"] == poke["name"]);
    } else if (selected.length < 3) {
      selected.add(poke);
    } else {
      Get.snackbar("Limit Reached", "You can only select 3 Pokémon!");
    }
  }

  void saveTeam() {
    if (selected.isEmpty) {
      Get.snackbar("Error", "No Pokémon selected!");
      return;
    }

    final newTeam = {
      "name": teamName.value,
      "pokemons": List<Map<String, String>>.from(selected)
    };

    teams.add(newTeam);
    saveToStorage();

    // reset selection
    selected.clear();
    teamName.value = "My Pokémon Team";
  }

  void saveToStorage() {
    box.write("teams", teams.toList());
  }

  void loadSavedTeams() {
    final saved = box.read("teams");
    if (saved != null) {
      teams.value = List<Map<String, dynamic>>.from(saved);
    }
  }

  void resetSelected() {
    selected.clear();
  }

  void editTeamName(String name) {
    teamName.value = name.trim().isEmpty ? "My Pokémon Team" : name.trim();
  }
}
