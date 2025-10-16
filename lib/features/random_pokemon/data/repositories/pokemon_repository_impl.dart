import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/exceptions.dart';
import 'package:trivia_app/features/random_pokemon/data/models/pokemon_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';

typedef Future<PokemonModel> _ConcreteOrRandomChooser();

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl({
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
