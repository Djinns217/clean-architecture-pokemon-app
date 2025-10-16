import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/datasources/random_pokemon_remote_data_source.dart';
import 'package:trivia_app/features/random_pokemon/data/models/pokemon_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';
@GenerateMocks([http.Client])
import 'random_pokemon_remote_data_source_test.mocks.dart';

void main() {
  late RandomPokemonRemoteDataSourceImpl? dataSource;
  late MockClient mockHttpClient;

  setUp((){
    mockHttpClient = MockClient();
    dataSource = RandomPokemonRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(fixture('pokemon.json'), 200));
  }

  void setUpMockHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcretePokemonById',() {
    final tId = 1;
    final tPokemonModel = PokemonModel.fromJson(json.decode(fixture('pokemon.json')));

    test(
      '''should perform a GET request on a URL with number 
      being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource!.getConcretePokemonById(tId);
        // assert
        verify(mockHttpClient.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$tId'), headers: {
          'Content-Type': 'application/json',
        }));

      });

    test(
      'should return RandomPokemonModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource!.getConcretePokemonById(tId);
        // assert
        expect(result, equals(tPokemonModel));
      });


    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource!.getConcretePokemonById;
        // assert
        expect(() => call(tId), throwsA(TypeMatcher<ServerException>()));
      });

  });

  group('getRandomPokemonId',() {
    final tPokemonModel = PokemonModel.fromJson(json.decode(fixture('pokemon.json')));

    test(
      '''should perform a GET request on a URL with number 
      being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource!.getRandomPokemonId();
        // assert
        verify(mockHttpClient.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/random'), headers: {
          'Content-Type': 'application/json',
        }));

      });

    test(
      'should return RandomPokemonModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource!.getRandomPokemonId();
        // assert
        expect(result, equals(tPokemonModel));
      });


    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource!.getRandomPokemonId;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      });

  });
}
