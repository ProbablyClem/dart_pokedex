import 'package:flutter/material.dart';
import 'pokemon.dart';

class PokemonList extends StatelessWidget {
  final List<Pokemon> pokemonList;

  PokemonList({required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final Pokemon pokemon = pokemonList[index];
        return ListTile(
          title: Text(pokemon.name),
          leading: Image.network(pokemon.imageUrl),
          onTap: () {
            // Add navigation to the Pokemon details screen or any other action
            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetailsScreen(pokemon: pokemon)));
          },
        );
      },
    );
  }
}
