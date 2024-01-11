import 'dart:convert';
import 'package:pokedex/pokemon.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ApiService {
  final cache = DefaultCacheManager();

  List<Pokemon> pokemonList = [];
  Map<int, PokemonDetails> pokemonDetails = {};
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
    const cacheKey = 'api_response.json';
    final file = await cache.getSingleFile(cacheKey);
    if (file.existsSync()) {
      final jsonData = await file.readAsString();
      pokemonList = decode(jsonData);
    } else {
      pokemonList = await fetchPokemonList();
      await cache.putFile(cacheKey, utf8.encode(jsonEncode(pokemonList)));
    }
    return pokemonList;
  }

  Future<PokemonDetails> fetchPokemonDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
    if (response.statusCode == 200) {
      return PokemonDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Pokemon details');
    }
  }

  Future<PokemonDetails> getPokemonDetails(int id) async {
    if (pokemonDetails.containsKey(id)) {
      return pokemonDetails[id]!;
    }

    final cacheKey = '$id.details.json';
    final file = await cache.getSingleFile(cacheKey);
    if (file.existsSync()) {
      final jsonData = await file.readAsString();
      pokemonDetails[id] = PokemonDetails.fromJson(jsonDecode(jsonData));
    } else {
      pokemonDetails[id] = await fetchPokemonDetails(id);
      await cache.putFile(
          cacheKey, utf8.encode(jsonEncode(pokemonDetails[id])));
    }
    return pokemonDetails[id]!;
  }
}

List<Pokemon> decode(String jsonData) {
  final List<dynamic> data = jsonDecode(jsonData)['results'];
  return data.map((json) => Pokemon.fromJson(json)).toList();
}
