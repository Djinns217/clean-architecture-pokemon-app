import 'package:flutter/material.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';

class PokemonDisplay extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonDisplay({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            pokemon.id.toString(),
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                  child: Text(
                pokemon.name,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        ],
      ),
    );
  }
}