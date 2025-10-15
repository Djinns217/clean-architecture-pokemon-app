import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/random_pokemon.dart';

abstract class PokemonRandomRepository {
  Future<Either<Failure, RandomPokemon>> getConcretePokemonById(int number);
  Future<Either<Failure, RandomPokemon>> getRandomPokemonId();
}