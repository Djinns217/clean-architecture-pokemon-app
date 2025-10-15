import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/random_pokemon_repository.dart';

class GetRandomPokemonById implements UseCase<Pokemon, Params> {
  final PokemonRandomRepository repository;

  // api.com/pokemon/1
  // api.com/pokemon/random

  GetRandomPokemonById(this.repository);

  @override
  Future<Either<Failure, Pokemon>> call(Params params) async {
    return await repository.getConcretePokemonById(params.id);
  }
}

class Params extends Equatable {
  final int id;

  const Params({required this.id});
  
  @override
  List<Object?> get props => [id];
}
