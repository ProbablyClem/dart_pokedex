// Screen for displaying the details of a Pokemon, appears when a Pokemon is tapped in the list
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/api_service.dart';
import 'package:pokedex/pokemon.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsScreen({Key? key, required this.pokemon})
      : super(key: key);

  @override
  State<PokemonDetailsScreen> createState() => PokemonDetailsState();
}

class PokemonDetailsState extends State<PokemonDetailsScreen> {
  PokemonDetails? details;

  @override
  void initState() {
    super.initState();
    ApiService().getPokemonDetails(widget.pokemon.id).then((value) {
      setState(() {
        details = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pokemon.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'pokemon-${widget.pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.imageUrl,
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
              widget.pokemon.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            if (details != null) ...[
              const SizedBox(height: 16),
              Text(
                'Height: ${details?.height}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
