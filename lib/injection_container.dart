import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_app/core/network/network_info.dart';
import 'package:trivia_app/core/util/input_converter.dart';
import 'package:trivia_app/features/random_pokemon/data/datasources/pokemon_local_data_source.dart';
import 'package:trivia_app/features/random_pokemon/data/datasources/random_pokemon_remote_data_source.dart';
import 'package:trivia_app/features/random_pokemon/data/repositories/pokemon_repository_impl.dart';
import 'package:trivia_app/features/random_pokemon/domain/repositories/pokemon_repository.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_concrete_pokemon_by_id.dart';
import 'package:trivia_app/features/random_pokemon/domain/usecases/get_random_pokemon_id.dart';
import 'package:trivia_app/features/random_pokemon/presentation/bloc/random_pokemon_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

//sl means service locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Random Pokemon
  // Bloc
  sl.registerFactory(() => RandomPokemonBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetConcretePokemonById(sl()));
  sl.registerLazySingleton(() => GetRandomPokemonId(sl()));

  // Repository
  sl.registerLazySingleton<PokemonRepository>(
      () => PokemonRepositoryImpl(
            localDataSource: sl(),
            remoteDataSource: sl(),
            networkInfo: sl(),
          ));

  // Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(
      () => PokemonRemoteDataSourceImpl(
            client: sl(),
          ));
  sl.registerLazySingleton<PokemonLocalDataSource>(
      () => PokemonLocalDataSourceImpl(
            sharedPreferences: sl(),
          ));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}
