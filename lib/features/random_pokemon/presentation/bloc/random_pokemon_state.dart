part of 'random_pokemon_bloc.dart';

abstract class RandomPokemonState extends Equatable {
  const RandomPokemonState();
  
  @override
  List<Object> get props => [];
}

class Empty extends RandomPokemonState {}

class Loading extends RandomPokemonState {}

class Loaded extends RandomPokemonState {
  final Pokemon pokemon;

  const Loaded({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class Error extends RandomPokemonState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}
