import 'package:get/get.dart';

class ApiService extends GetConnect {
  Future<List<Map<String, String>>> fetchPokemons() async {
    final response =
        await get("https://pokeapi.co/api/v2/pokemon?limit=50&offset=0");

    if (response.statusCode == 200) {
      final results = response.body['results'] as List;
      return results.map((p) {
        final name = p['name'].toString();
        final image =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${_extractId(p['url'])}.png";
        return {"name": name, "image": image};
      }).toList().cast<Map<String, String>>();
    }
    return [];
  }

  int _extractId(String url) {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }
}
