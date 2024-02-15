import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pokemon_detail.dart';
import 'pokemon.dart';

class PokemonList extends StatefulWidget {
  final List<Pokemon> pokemonList;

  const PokemonList({super.key, required this.pokemonList});

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

  CachedNetworkImage getImage(Pokemon pokemon) {
    return CachedNetworkImage(
      imageUrl: pokemon.imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          Image.asset('images/silhouette.png'),
      errorListener: (value) =>
          {}, // expected case, we don't need to do anything
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: _filterPokemonList,
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 250),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(200),
            ),
            labelText: 'Search Pokémon',
            prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'images/pokeball.png',
                  width: 32,
                )),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredPokemonList.length,
            itemBuilder: (context, index) {
              final Pokemon pokemon = filteredPokemonList[index];
              return ListTile(
                title: Text(pokemon.name),
                leading: getImage(pokemon),
                onTap: () {
                  // Add navigation to the Pokemon details screen or any other action
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetailsScreen(pokemon: pokemon)));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PokemonDetailsScreen(pokemon: pokemon)));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
