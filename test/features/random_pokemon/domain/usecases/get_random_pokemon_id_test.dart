import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/usecases/usecase.dart';

import 'package:trivia_app/features/random_pokemon/domain/entities/random_pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/random_pokemon_repository.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_random_pokemon_id.dart';

// 👇 Cette ligne dit à Mockito de générer le fichier de mocks
@GenerateMocks([PokemonRandomRepository])
import 'get_random_pokemon_id_test.mocks.dart';

void main() {
  late GetRandomPokemonId usecase;
  late MockPokemonRandomRepository mockPokemonRandomRepository;

  setUp(() {
    mockPokemonRandomRepository = MockPokemonRandomRepository();
    usecase = GetRandomPokemonId(mockPokemonRandomRepository);
  });

  final tPokemon = RandomPokemon(id: 1, name: 'test');

  test('should get random pokemon id from the repository', () async {
    // arrange
    when(mockPokemonRandomRepository.getRandomPokemonId())
        .thenAnswer((_) async => Right(tPokemon));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(tPokemon));
    verify(mockPokemonRandomRepository.getRandomPokemonId());
    verifyNoMoreInteractions(mockPokemonRandomRepository);
  });
}
