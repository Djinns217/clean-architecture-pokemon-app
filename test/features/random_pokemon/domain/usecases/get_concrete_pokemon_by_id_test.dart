import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/util/params.dart';

import 'package:trivia_app/features/random_pokemon/domain/entities/pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/pokemon_repository.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_concrete_pokemon_by_id.dart';

// 👇 Cette ligne dit à Mockito de générer le fichier de mocks
@GenerateMocks([PokemonRepository])
import 'get_concrete_pokemon_by_id_test.mocks.dart';

void main() {
  late GetConcretePokemonById usecase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetConcretePokemonById(mockPokemonRepository);
  });

  const tId = 1;
  final tPokemon = Pokemon(id: 1, name: 'test');

  test('should get random pokemon for the id from the repository', () async {
    // arrange
    when(mockPokemonRepository.getConcretePokemonById(any))
        .thenAnswer((_) async => Right(tPokemon));

    // act
    final result = await usecase(Params(id: tId));

    // assert
    expect(result, Right(tPokemon));
    verify(mockPokemonRepository.getConcretePokemonById(tId));
    verifyNoMoreInteractions(mockPokemonRepository);
  });
}
