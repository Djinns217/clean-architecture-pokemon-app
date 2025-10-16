import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/util/params.dart';
import 'package:trivia_app/core/util/random_number_generator.dart';

import 'package:trivia_app/features/random_pokemon/domain/entities/pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/pokemon_repository.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_random_pokemon_id.dart';

// 👇 Cette ligne dit à Mockito de générer le fichier de mocks
@GenerateMocks([PokemonRepository])
import 'get_random_pokemon_id_test.mocks.dart';

void main() {
  late GetRandomPokemonId usecase;
  late MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    usecase = GetRandomPokemonId(mockPokemonRepository);
  });

  
  final randomId = RandomNumberGenerator().generate();

  final tPokemon = Pokemon(id: randomId, name: 'test');

  test('should get random pokemon id from the repository', () async {
    // arrange
    when(mockPokemonRepository.getRandomPokemonId(randomId))
        .thenAnswer((_) async => Right(tPokemon));
    // act
    final result = await usecase(Params(id: randomId));

    // assert
    expect(result, Right(tPokemon));
    verify(mockPokemonRepository.getRandomPokemonId(randomId));
    verifyNoMoreInteractions(mockPokemonRepository);
  });
}
