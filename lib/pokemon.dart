import 'dart:convert';

import 'package:pokedex/api_service.dart';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  PokemonDetails? _details;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final int id = int.parse(json['url'].split('/')[6]);
    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }

  Future<PokemonDetails> getDetails() async {
    _details ??= await ApiService().getPokemonDetails(id);
    return Future(() => _details!);
  }
}

class PokemonDetails {
  final String height;
  PokemonDetails({required this.height});

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    final height = json['height'].toString();
    return PokemonDetails(height: height);
  }
}
