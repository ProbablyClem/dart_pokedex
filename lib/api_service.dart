import 'dart:convert';
import 'package:pokedex/pokemon.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ApiService {
  final cache = DefaultCacheManager();
  final cacheKey = 'api_response.json';
  List<Pokemon> pokemonList = [];

  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=10000'));
    if (response.statusCode == 200) {
      return decode(response.body);
    } else {
      throw Exception('Failed to load Pokemon list');
    }
  }

  // get list of pokemon from cache if available
  Future<List<Pokemon>> getPokemonList() async {
    if (pokemonList.isNotEmpty) {
      return pokemonList;
    }

    final file = await cache.getSingleFile(cacheKey);
    if (file != null && file.existsSync()) {
      final jsonData = await file.readAsString();
      pokemonList = decode(jsonData);
    } else {
      pokemonList = await fetchPokemonList();
      await cache.putFile(cacheKey, utf8.encode(jsonEncode(pokemonList)));
    }
    return pokemonList;
  }
}

List<Pokemon> decode(String jsonData) {
  final List<dynamic> data = jsonDecode(jsonData)['results'];
  return data.map((json) => Pokemon.fromJson(json)).toList();
}
