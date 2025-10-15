import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';

class RandomPokemonModel extends Pokemon {
  const RandomPokemonModel({required super.id, required super.name});

  factory RandomPokemonModel.fromJson(Map<String, dynamic> json) {
    return RandomPokemonModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
