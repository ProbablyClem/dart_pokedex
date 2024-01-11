// Screen for displaying the details of a Pokemon, appears when a Pokemon is tapped in the list
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pokemon.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsScreen({Key? key, required this.pokemon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'pokemon-${pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('images/silhouette.png'),
                errorListener: (value) =>
                    {}, // expected case, we don't need to do anything
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pokemon.name,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
