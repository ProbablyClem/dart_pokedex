import 'dart:convert';

import 'package:flutter/widgets.dart';
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
  final List<Type> types;
  final List<Stat> stats;
  PokemonDetails(
      {required this.height, required this.types, required this.stats});

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    final height = json['height'].toString();
    final types =
        json['types'].map<Type>((type) => Type.fromJson(type['type'])).toList();
    final stats =
        json['stats'].map<Stat>((stat) => Stat.fromJson(stat)).toList();

    return PokemonDetails(height: height, types: types, stats: stats);
  }
}

class Type {
  final String name;
  final String url;

  Type({required this.name, required this.url});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(name: json['name'], url: json['url']);
  }
}

class Stat {
  final String name;
  final int value;

  Stat({required this.name, required this.value});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(name: json['stat']['name'], value: json['base_stat']);
  }
}
