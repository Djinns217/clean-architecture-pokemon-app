import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/network/network_info.dart';
import 'package:trivia_app/features/random_pokemon/data/datasources/random_pokemon_local_data_source.dart';
import 'package:trivia_app/features/random_pokemon/data/datasources/random_pokemon_remote_data_source.dart';
import 'package:trivia_app/features/random_pokemon/data/models/random_pokemon_model.dart';
import 'package:trivia_app/features/random_pokemon/data/repositories/random_pokemon_repository_impl.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';

// 👇 Cette ligne dit à Mockito de générer le fichier de mocks
/// flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([RandomPokemonRemoteDataSource])
@GenerateMocks([RandomPokemonLocalDataSource])
@GenerateMocks([NetworkInfo])
import 'random_pokemon_repository_impl_test.mocks.dart';

void main() {
  late RandomPokemonRepositoryImpl repository;
  late MockRandomPokemonRemoteDataSource mockRemoteDataSource;
  late MockRandomPokemonLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRandomPokemonRemoteDataSource();
    mockLocalDataSource = MockRandomPokemonLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RandomPokemonRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteRandomPokemon', () {
    final tId = 1;
    final tRandomPokemonModel =
        RandomPokemonModel(id: tId, name: 'test pokemon');
    final RandomPokemon tRandomPokemon = tRandomPokemonModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // 👇 ajoute ceci pour éviter le MissingStubError
      when(mockRemoteDataSource.getConcretePokemonById(any))
          .thenAnswer((_) async => RandomPokemonModel(id: 1, name: 'test'));

      //act
      repository.getConcretePokemonById(tId);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
 
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcretePokemonById(tId))
            .thenAnswer((_) async => tRandomPokemonModel);
        //act
        final result = await repository.getConcretePokemonById(tId);
        //assert
        verify(mockRemoteDataSource.getConcretePokemonById(tId));
        expect(result, equals(Right(tRandomPokemon)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcretePokemonById(tId))
            .thenAnswer((_) async => tRandomPokemonModel);
        //act
        await repository.getConcretePokemonById(tId);
        //assert
        verify(mockRemoteDataSource.getConcretePokemonById(tId));
        verify(mockLocalDataSource.cacheRandomPokemon(tRandomPokemonModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource.getConcretePokemonById(tId))
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcretePokemonById(tId);
        //assert
        verify(mockRemoteDataSource.getConcretePokemonById(tId));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastRandomPokemon())
            .thenAnswer((_) async => tRandomPokemonModel);
        //act
        final result = await repository.getConcretePokemonById(tId);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastRandomPokemon());
        expect(result, equals(Right(tRandomPokemon)));
      });

      test('should return Cache failure when there is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastRandomPokemon())
            .thenThrow(CacheException());
        //act
        final result = await repository.getConcretePokemonById(tId);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastRandomPokemon());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomPokemon', () {
    final tRandomPokemonModel =
        RandomPokemonModel(id: 123, name: 'test pokemon');
    final RandomPokemon tRandomPokemon = tRandomPokemonModel;
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // 👇 ajoute ceci pour éviter le MissingStubError
      when(mockRemoteDataSource.getRandomPokemonId())
          .thenAnswer((_) async => RandomPokemonModel(id: 1234, name: 'test'));

      //act
      repository.getRandomPokemonId();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
 
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomPokemonId())
            .thenAnswer((_) async => tRandomPokemonModel);
        //act
        final result = await repository.getRandomPokemonId();
        //assert
        verify(mockRemoteDataSource.getRandomPokemonId());
        expect(result, equals(Right(tRandomPokemon)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomPokemonId())
            .thenAnswer((_) async => tRandomPokemonModel);
        //act
        await repository.getRandomPokemonId();
        //assert
        verify(mockRemoteDataSource.getRandomPokemonId());
        verify(mockLocalDataSource.cacheRandomPokemon(tRandomPokemonModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource.getRandomPokemonId())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomPokemonId();
        //assert
        verify(mockRemoteDataSource.getRandomPokemonId());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastRandomPokemon())
            .thenAnswer((_) async => tRandomPokemonModel);
        //act
        final result = await repository.getRandomPokemonId();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastRandomPokemon());
        expect(result, equals(Right(tRandomPokemon)));
      });

      test('should return Cache failure when there is no cached data present',
          () async {
        //arrange
        when(mockLocalDataSource.getLastRandomPokemon())
            .thenThrow(CacheException());
        //act
        final result = await repository.getRandomPokemonId();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastRandomPokemon());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
