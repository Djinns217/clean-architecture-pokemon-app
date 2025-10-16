import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/datasources/pokemon_local_data_source.dart';
import 'package:trivia_app/features/random_pokemon/data/models/pokemon_model.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateMocks([SharedPreferences])
import 'random_pokemon_local_data_source_test.mocks.dart';

void main() {
  late PokemonLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PokemonLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastRandomPokemon', () {
    final tRandomPokemonModel = PokemonModel.fromJson(
      json.decode(fixture('pokemon_cached.json')),
    );
    test(
        'should return RandomPokemon from SharedPreferences when there is one in the cache',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('pokemon_cached.json'));
      // Act
      final result = await dataSource.getLastRandomPokemon();
      // Assert
      verify(mockSharedPreferences.getString(CACHED_RANDOM_POKEMON));
      expect(result, equals(tRandomPokemonModel));
    });

    test('should throw CacheException when there is not a cache value',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // Act
      final call = dataSource.getLastRandomPokemon;
      // Assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cachedRandomPokemon', () {
    final tRandomPokemonModel =
        PokemonModel(id: 1, name: "random pokemon test");
    test('should call SharedPreferences to cache the data', () async {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) => Future.value(true));
      //Act
      dataSource.cacheRandomPokemon(tRandomPokemonModel);
      //assert
      final expectedJsonString = json.encode(tRandomPokemonModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_RANDOM_POKEMON, expectedJsonString));
    });
  });
}
