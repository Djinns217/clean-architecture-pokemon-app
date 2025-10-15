import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_app/features/random_pokemon/presentation/bloc/random_pokemon_bloc.dart';

class PokemonControls extends StatefulWidget {
  const PokemonControls({
    super.key,
  });

  @override
  State<PokemonControls> createState() => _PokemonControlsState();
}

class _PokemonControlsState extends State<PokemonControls> {
  late String inputStr;
  late final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a number!',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            addConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary, // remplace accentColor
                  foregroundColor: Colors.white, // texte du bouton
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: addConcrete,
                child: const Text('Search'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary, // remplace accentColor
                  foregroundColor: Colors.white, // texte du bouton
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: addRandom,
                child: const Text('Get Random Pokemon'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    controller.clear();
    BlocProvider.of<RandomPokemonBloc>(context)
        .add(GetRandomPokemonForConcreteId(inputStr));
  }

  void addRandom() {
    controller.clear();
    BlocProvider.of<RandomPokemonBloc>(context)
        .add(GetRandomPokemonForRandomId());
  }
}