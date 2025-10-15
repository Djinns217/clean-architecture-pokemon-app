import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/random_pokemon_repository.dart';

class GetRandomPokemonId implements UseCase<Pokemon, NoParams> {
  final PokemonRandomRepository repository;

  GetRandomPokemonId(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(NoParams params) async {
    return await repository.getRandomPokemonId();
  }
}

