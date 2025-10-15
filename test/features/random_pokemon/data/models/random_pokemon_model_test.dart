import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/features/random_pokemon/data/models/random_pokemon_model.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tRandomPokemonModel = RandomPokemonModel(id: 1, name: "bulbasaur");

  test('should be a subclass of RandomPokemon entity', () async {
    expect(tRandomPokemonModel, isA<RandomPokemon>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture( 'pokemon.json'));
      //act
      final result = RandomPokemonModel.fromJson(jsonMap);
      //assert
      expect(result, tRandomPokemonModel);
  });
});

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      //act
      final result = tRandomPokemonModel.toJson();
      //assert
      final expectedMap = {
        "id": 1,
        "name": "bulbasaur",
      };
      expect(result, expectedMap);
    });
  });

}