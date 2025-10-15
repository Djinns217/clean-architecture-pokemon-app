import 'package:flutter/material.dart';
import 'package:trivia_app/features/random_pokemon/presentation/pages/random_pokemon_page.dart';
import 'package:trivia_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        hintColor: Colors.green.shade600,
      ),
      home: const RandomPokemonPage()
    );
  }
}