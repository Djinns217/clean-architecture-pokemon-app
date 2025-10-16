import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/failure.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/core/util/input_converter.dart';
import 'package:trivia_app/features/random_pokemon/domain/entities/pokemon.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_concrete_pokemon_by_id.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_random_pokemon_id.dart';
import 'package:trivia_app/features/random_pokemon/presentation/bloc/random_pokemon_bloc.dart';

@GenerateMocks([GetConcretePokemonById, GetRandomPokemonId])
@GenerateMocks([InputConverter])
import 'random_pokemon_bloc_test.mocks.dart';

void main() {
  late PokemonBloc bloc;
  late MockGetRandomPokemonById mockGetRandomPokemonById;
  late MockGetRandomPokemonId mockGetRandomPokemonId;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomPokemonById = MockGetRandomPokemonById();
    mockGetRandomPokemonId = MockGetRandomPokemonId();
    mockInputConverter = MockInputConverter();

    bloc = PokemonBloc(
      concrete: mockGetRandomPokemonById,
      random: mockGetRandomPokemonId,
      inputConverter: mockInputConverter,
    );
  });

  blocTest<PokemonBloc, PokemonState>(
    'initial state should be Empty',
    build: () => bloc,
    verify: (bloc) {
      expect(bloc.state, equals(Empty()));
    },
  );

  group('GetRandomPokemonForConcreteId', () {
    final tIdString = "1";
    final tIdParsed = 1;
    final tPokemon = Pokemon(id: 1, name: "Test pokemon");

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tIdParsed));

    blocTest<PokemonBloc, PokemonState>(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetRandomPokemonById.call(any))
            .thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (bloc) => bloc.add(GetConcretePokemonByIdEvent(tIdString)),
      verify: (_) {
        verify(mockInputConverter.stringToUnsignedInteger(tIdString));
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetConcretePokemonByIdEvent(tIdString)),
      expect: () => [
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      'should get data from the concrete use case',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetRandomPokemonById(any))
            .thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (bloc) => bloc.add(GetConcretePokemonByIdEvent(tIdString)),
      verify: (_) {
        verify(mockGetRandomPokemonById(Params(id: tIdParsed)));
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetRandomPokemonById(any))
            .thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (bloc) => bloc.add(GetConcretePokemonByIdEvent(tIdString)),
      expect: () => [
        Loading(),
        Loaded(pokemon: tPokemon),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetRandomPokemonById(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetConcretePokemonByIdEvent(tIdString)),
      expect: () => [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetRandomPokemonById(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetConcretePokemonByIdEvent(tIdString)),
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetRandomPokemonForRandomId', () {
    final tPokemon = Pokemon(id: 1, name: "Test pokemon");

    blocTest<PokemonBloc, PokemonState>(
      'should get data from the concrete use case',
      build: () {
        when(mockGetRandomPokemonId(any))
            .thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (bloc) => bloc.add(GetRandomPokemonIdEvent()),
      verify: (_) {
        verify(mockGetRandomPokemonId.call(NoParams()));
      },
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetRandomPokemonId(any))
            .thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (bloc) => bloc.add(GetRandomPokemonIdEvent()),
      expect: () => [
        Loading(),
        Loaded(pokemon: tPokemon),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetRandomPokemonId(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetRandomPokemonIdEvent()),
      expect: () => [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<PokemonBloc, PokemonState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomPokemonId(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetRandomPokemonIdEvent()),
      expect: () => [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
