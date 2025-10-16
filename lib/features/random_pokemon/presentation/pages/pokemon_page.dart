import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_app/features/random_pokemon/presentation/bloc/pokemon_bloc.dart';
import 'package:trivia_app/injection_container.dart';

import '../widgets/widgets.dart';

class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Random Pokemon', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<PokemonBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PokemonBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              //Top Half
              BlocBuilder<PokemonBloc, PokemonState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start searching!');
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loaded) {
                    return PokemonDisplay(pokemon: state.pokemon);
                  } else if (state is Loading) {
                    return LoadingWidget();
                  }
                  return SizedBox.shrink(); // Default return statement
                },
              ),
              SizedBox(height: 20),
              //Bottom Half
              PokemonControls()
            ],
          ),
        ),
      ),
    );
  }
}