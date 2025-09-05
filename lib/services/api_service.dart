import 'package:get/get.dart';

class ApiService extends GetConnect {
  Future<List<Map<String, String>>> fetchPokemons() async {
    final response =
        await get("https://pokeapi.co/api/v2/pokemon?limit=50");

    if (response.statusCode == 200) {
      final List results = response.body['results'];

      return results.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final name = entry.value['name'].toString();
        final image =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$index.png";
        return {"name": name, "image": image};
      }).toList();
    }
    return [];
  }
}
