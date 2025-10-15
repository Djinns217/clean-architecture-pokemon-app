import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/models/random_pokemon_model.dart';

abstract class RandomPokemonRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/pokemon/{id} endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<RandomPokemonModel> getConcretePokemonById(int number);

  /// Calls the https://pokeapi.co/api/v2/pokemon/random_id endpoint with a random id.
  /// Throws a [ServerException] for all error codes.
  Future<RandomPokemonModel> getRandomPokemonId();
}

class RandomPokemonRemoteDataSourceImpl
    implements RandomPokemonRemoteDataSource {
  final http.Client client;

  RandomPokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<RandomPokemonModel> getConcretePokemonById(int number) async {
    return _getPokemonfromUrl('https://pokeapi.co/api/v2/pokemon/$number');
  }

  @override
  Future<RandomPokemonModel> getRandomPokemonId() {
    return _getPokemonfromUrl('https://pokeapi.co/api/v2/pokemon/random');
  }

  Future<RandomPokemonModel> _getPokemonfromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return RandomPokemonModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
