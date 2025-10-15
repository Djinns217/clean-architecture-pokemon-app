import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/models/random_pokemon_model.dart';

abstract class RandomPokemonLocalDataSource {
  /// Gets the cached [RandomPokemonModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<RandomPokemonModel> getLastRandomPokemon();

  Future<void> cacheRandomPokemon(RandomPokemonModel pokemonToCache);
}

// ignore: constant_identifier_names
const CACHED_RANDOM_POKEMON = 'CACHED_RANDOM_POKEMON';

class RandomPokemonLocalDataSourceImpl implements RandomPokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  RandomPokemonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<RandomPokemonModel> getLastRandomPokemon() {
    final jsonString = sharedPreferences.getString(CACHED_RANDOM_POKEMON);
    if (jsonString != null) {
      return Future.value(RandomPokemonModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheRandomPokemon(RandomPokemonModel pokemonToCache) {
    return sharedPreferences.setString(
      CACHED_RANDOM_POKEMON,
      json.encode(
        pokemonToCache.toJson(),
      ),
    );
  }
}
