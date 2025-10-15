part of 'random_pokemon_bloc.dart';

abstract class RandomPokemonEvent extends Equatable {
  const RandomPokemonEvent();

  @override
  List<Object> get props => [];
}

class GetRandomPokemonForConcreteId extends RandomPokemonEvent {
  final String idString;

  const GetRandomPokemonForConcreteId(this.idString);

  @override
  List<Object> get props => [idString];
}

class GetRandomPokemonForRandomId extends RandomPokemonEvent {}
