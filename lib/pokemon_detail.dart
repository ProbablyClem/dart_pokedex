import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/api_service.dart';
import 'package:pokedex/pokemon.dart';
import 'dart:math' as math;
import 'package:pokedex/pokemon_types.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

// Custom Pokeball Loader Widget
class PokeballLoader extends StatefulWidget {
  const PokeballLoader({super.key});

  @override
  _PokeballLoaderState createState() => _PokeballLoaderState();
}

class _PokeballLoaderState extends State<PokeballLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: const PokeballWidget(),
      ),
    );
  }
}

class PokeballWidget extends StatelessWidget {
  const PokeballWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(color: Colors.black, width: 3),
                ),
              ),
            ),
            Positioned(
              top: 29,
              left: 0,
              right: 0,
              child: Container(
                width: 60,
                height: 2,
                color: Colors.black,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;
  final List<Pokemon> pokemonList;

  const PokemonDetailsScreen(
      {Key? key, required this.pokemon, required this.pokemonList})
      : super(key: key);

  @override
  _PokemonDetailsScreenState createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  PokemonDetails? details;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    // Fetch details
    var pokemonDetails =
        await ApiService().getPokemonDetails(widget.pokemon.id);
    if (mounted) {
      setState(() {
        details = pokemonDetails;
        isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.8;
    final double imageHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name),
        backgroundColor: details?.types.isNotEmpty ?? false
            ? getTypeColor(details!.types.first.name)
            : Colors.blue,
      ),
      body: isLoading
          ? const PokeballLoader()
          : SwipeDetector(
              onSwipeLeft: (offset) => onSwipeLeft(offset),
              onSwipeRight: (offset) => onSwipeRight(offset),
              child: details == null
                  ? const Center(child: Text('Failed to load Pokémon details.'))
                  : buildPokemonDetails(context, imageWidth, imageHeight)),
    );
  }

  Widget buildPokemonDetails(
      BuildContext context, double imageSize, double imageHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
            child: Text(
              widget.pokemon.name.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: getTypeColor(details!.types.first.name),
                  ),
            ),
          ),
          Text(
            "#" + widget.pokemon.id.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
          ),
          if (details != null && details!.types.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PokemonTypes(
                  types: details!.types.map((e) => e.name).toList()),
            ),
          Hero(
            tag: 'pokemon-${widget.pokemon.id}',
            child: CachedNetworkImage(
              imageUrl: widget.pokemon.imageUrl,
              height: 128,
              width: 128,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          //Abilities unordered list
          if (details != null && details!.abilities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    'Abilities',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Column(
                    children: details!.abilities
                        .map((ability) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 16.0),
                              child: Text(ability.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontStyle: FontStyle.italic)
                                  //italic
                                  ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          if (details != null && details!.stats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    'Stats',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  buildStats(context),
                ],
              ),
            ),
        ],
      ),
    );
  }

  //buildStats
  Widget buildStats(BuildContext context) {
    return Column(
      children: details!.stats
          .map((stat) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        stat.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: stat.value / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            getTypeColor(details!.types.first.name)),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return const Color(0xFFA8A878);
      case 'fighting':
        return const Color(0xFFC03028);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'ghost':
        return const Color(0xFF705898);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'fire':
        return const Color(0xFFF08030);
      case 'water':
        return const Color(0xFF6890F0);
      case 'grass':
        return const Color(0xFF78C850);
      case 'electric':
        return const Color(0xFFF8D030);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'ice':
        return const Color(0xFF98D8D8);
      case 'dragon':
        return const Color(0xFF7038F8);
      case 'dark':
        return const Color(0xFF705848);
      case 'fairy':
        return const Color(0xFFEE99AC);
      default:
        return Colors.grey;
    }
  }

  void onSwipeLeft(Offset offset) {
    if (widget.pokemon.id == 1) {
      return;
    }
    Pokemon nextPokemon = super.widget.pokemonList[super.widget.pokemon.id - 2];
    navigateToPokemon(nextPokemon, context);
  }

  void onSwipeRight(Offset offset) {
    Pokemon nextPokemon = super.widget.pokemonList[super.widget.pokemon.id];
    navigateToPokemon(nextPokemon, context);
  }

  void navigateToPokemon(Pokemon pokemon, BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PokemonDetailsScreen(
                  pokemon: pokemon,
                  pokemonList: super.widget.pokemonList,
                )));
  }
}
