import 'package:flutter/material.dart';

class PokemonTypes extends StatelessWidget {
  final List<String> types;

  PokemonTypes({required this.types});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: types.map((type) {
        return Chip(
          label: Text(type),
          backgroundColor: _getTypeColor(type),
        );
      }).toList(),
    );
  }

  Color _getTypeColor(String type) {
    // You can customize the colors based on your design
    switch (type.toLowerCase()) {
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.red;
      case 'flying':
        return Colors.blue;
      case 'poison':
        return Colors.purple;
      // Add more cases for other types
      default:
        return Colors.grey;
    }
  }
}
