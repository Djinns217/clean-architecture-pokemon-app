import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/pokemon/{id} endpoint.
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getConcretePokemonById(int number);

  /// Calls the https://pokeapi.co/api/v2/pokemon/random_id endpoint with a random id.
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getRandomPokemonId(int randomnumber);
}

class PokemonRemoteDataSourceImpl
    implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonModel> getConcretePokemonById(int number) async {
    return _getPokemonfromUrl('https://pokeapi.co/api/v2/pokemon/$number');
  }

  @override
  Future<PokemonModel> getRandomPokemonId(int randomnumber) {
    return _getPokemonfromUrl('https://pokeapi.co/api/v2/pokemon/$randomnumber');
  }

  Future<PokemonModel> _getPokemonfromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return PokemonModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
