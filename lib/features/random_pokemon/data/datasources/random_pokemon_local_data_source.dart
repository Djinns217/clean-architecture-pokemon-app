import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/models/random_pokemon_model.dart';

abstract class RandomPokemonLocalDataSource {
  /// Gets the cached [PokemonModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<PokemonModel> getLastRandomPokemon();

  Future<void> cacheRandomPokemon(PokemonModel pokemonToCache);
}

// ignore: constant_identifier_names
const CACHED_RANDOM_POKEMON = 'CACHED_RANDOM_POKEMON';

class RandomPokemonLocalDataSourceImpl implements RandomPokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  RandomPokemonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PokemonModel> getLastRandomPokemon() {
    final jsonString = sharedPreferences.getString(CACHED_RANDOM_POKEMON);
    if (jsonString != null) {
      return Future.value(PokemonModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheRandomPokemon(PokemonModel pokemonToCache) {
    return sharedPreferences.setString(
      CACHED_RANDOM_POKEMON,
      json.encode(
        pokemonToCache.toJson(),
      ),
    );
  }
}
