// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/core/util/input_converter.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_concrete_pokemon_by_id.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_random_pokemon_id.dart';

part 'random_pokemon_event.dart';
part 'random_pokemon_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class RandomPokemonBloc extends Bloc<RandomPokemonEvent, RandomPokemonState> {
  final GetConcretePokemonById getConcreteRandomPokemon;
  final GetRandomPokemonId getRandomPokemon;
  final InputConverter inputConverter;

  RandomPokemonBloc({
    required GetConcretePokemonById concrete,
    required GetRandomPokemonId random,
    required this.inputConverter,
  })  : getConcreteRandomPokemon = concrete,
        getRandomPokemon = random,
        super(Empty()) {
    on<RandomPokemonEvent>(_onRandomPokemonEvent);
  }

  Future<void> _onRandomPokemonEvent(
    RandomPokemonEvent event,
    Emitter<RandomPokemonState> emit,
  ) async {
    if (event is GetRandomPokemonForConcreteId) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.idString);

      await inputEither.fold(
        (failure) {
          emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (integer) async {
          emit(Loading());
          final failureOrPokemon =
              await getConcreteRandomPokemon(Params(id: integer));
          _eitherLoadedOrErrorState(failureOrPokemon, emit);
        },
      );
    } else if (event is GetRandomPokemonForRandomId) {
      emit(Loading());
      final failureOrPokemon = await getRandomPokemon(NoParams());
      _eitherLoadedOrErrorState(failureOrPokemon, emit);
    }
  }

  void _eitherLoadedOrErrorState(Either<Failure, Pokemon> failureOrPokemon,
      Emitter<RandomPokemonState> emit) {
    failureOrPokemon.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (pokemon) => emit(Loaded(pokemon: pokemon)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
