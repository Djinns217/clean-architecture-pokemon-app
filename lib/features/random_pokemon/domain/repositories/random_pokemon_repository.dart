import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, Pokemon>> getConcretePokemonById(int number);
  Future<Either<Failure, Pokemon>> getRandomPokemonId();
}