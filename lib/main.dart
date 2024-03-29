import 'package:pokedex/api_service.dart';
import 'package:pokedex/pokemon.dart';
import 'package:pokedex/pokemon_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokedex App",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PokedexScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Pokemon>> _pokemonList;

  @override
  void initState() {
    super.initState();
    _pokemonList = _apiService.fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(222, 21, 55, 1),
      body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FutureBuilder<List<Pokemon>>(
            future: _pokemonList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<Pokemon> pokemonList = snapshot.data!;
                return PokemonList(pokemonList: pokemonList);
              }
            },
          )),
    );
  }
}
