import 'package:equatable/equatable.dart';

class RandomPokemon extends Equatable {
  final int id;
  final String name;

  const RandomPokemon({required this.id, required this.name});



  @override
  List<Object?> get props => [id, name];
}
