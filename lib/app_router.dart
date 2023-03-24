import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterblockapp/business_logic/cubit/characters_cubit.dart';
import 'package:flutterblockapp/constants/strings.dart';
import 'package:flutterblockapp/data/repository/characters_repo.dart';
import 'package:flutterblockapp/data/web_services/characters_web_services_rest.dart';
import 'package:flutterblockapp/presentation/screens/charaters_details_screen.dart';
import 'package:flutterblockapp/presentation/screens/characters_screen.dart';

import 'data/models/character.dart';
import 'data/web_services/charcters_web_services_graphql.dart';

class AppRouter {
  late final CharactersCubit charactersCubit;
  late final CharactersRepository charactersRepository;

  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServicesGraphQl(), CharactersWebServicesRest());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: const CharactersScreen(),
          ),
        );
      case charactersDetailsScreen:
        final Map arguments = settings.arguments as Map;
        final Character character = arguments['character'];
        final ApiType apiType = arguments['apiType'];
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (BuildContext context) => CharactersCubit(charactersRepository),
              child: CharactersDetailsScreen(
                    character: character,
                    apiType: apiType,
                  ),
            ));
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: const CharactersScreen(),
          ),
        );
    }
  }
}
