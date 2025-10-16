import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/core/util/params.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/pokemon_repository.dart';

class GetRandomPokemonId implements UseCase<Pokemon, Params> {
  final PokemonRepository repository;

  GetRandomPokemonId(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(Params params) async {
    return await repository.getRandomPokemonId(params.id);
  }
}

