import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/core/util/params.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/pokemon_repository.dart';

class GetConcretePokemonById implements UseCase<Pokemon, Params> {
  final PokemonRepository repository;

  // api.com/pokemon/1
  // api.com/pokemon/random

  GetConcretePokemonById(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(Params params) async {
    return await repository.getConcretePokemonById(params.id);
  }
}


