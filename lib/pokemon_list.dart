import 'package:flutter/material.dart';
import 'pokemon.dart';

class PokemonList extends StatefulWidget {
  final List<Pokemon> pokemonList;

  PokemonList({required this.pokemonList});

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late List<Pokemon> filteredPokemonList;

  @override
  void initState() {
    super.initState();
    filteredPokemonList = widget.pokemonList;
  }

  void _filterPokemonList(String query) {
    setState(() {
      filteredPokemonList = widget.pokemonList
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: _filterPokemonList,
          decoration: InputDecoration(
            labelText: 'Search Pokémon',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredPokemonList.length,
            itemBuilder: (context, index) {
              final Pokemon pokemon = filteredPokemonList[index];
              return ListTile(
                title: Text(pokemon.name),
                leading: Image.network(pokemon.imageUrl),
                onTap: () {
                  // Add navigation to the Pokemon details screen or any other action
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetailsScreen(pokemon: pokemon)));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
