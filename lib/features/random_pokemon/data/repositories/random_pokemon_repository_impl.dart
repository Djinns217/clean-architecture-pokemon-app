import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/models/random_pokemon_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/random_pokemon_local_data_source.dart';
import '../datasources/random_pokemon_remote_data_source.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/random_pokemon_repository.dart';

typedef Future<RandomPokemonModel> _ConcreteOrRandomChooser();

class RandomPokemonRepositoryImpl implements PokemonRandomRepository {
  final RandomPokemonRemoteDataSource remoteDataSource;
  final RandomPokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RandomPokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Pokemon>> getConcretePokemonById(int id) async {
    return await _getPokemon(() {
      return remoteDataSource.getConcretePokemonById(id);
    });
  }

  @override
  Future<Either<Failure, Pokemon>> getRandomPokemonId() async {
    return await _getPokemon(() {
      return remoteDataSource.getRandomPokemonId();
    });
  }

  Future<Either<Failure, Pokemon>> _getPokemon(
    _ConcreteOrRandomChooser getConcreteOrRandom, 
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePokemon = await getConcreteOrRandom();
        localDataSource.cacheRandomPokemon(remotePokemon);
        return Right(remotePokemon);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPokemon = await localDataSource.getLastRandomPokemon();
        return Right(localPokemon);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
