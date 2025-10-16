part of 'random_pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class GetConcretePokemonByIdEvent extends PokemonEvent {
  final String idString;

  const GetConcretePokemonByIdEvent(this.idString);

  @override
  List<Object> get props => [idString];
}

class GetRandomPokemonIdEvent extends PokemonEvent {}
