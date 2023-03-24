
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterblockapp/business_logic/cubit/characters_state.dart';
import 'package:flutterblockapp/constants/strings.dart';
import 'package:flutterblockapp/data/models/character.dart';

import '../../data/repository/characters_repo.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> allCharacters = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> characters({required ApiType apiType}) {
    charactersRepository.getAllCharacters(apiType: apiType).then((allCharacters) {
      emit(CharactersLoaded(
        allCharacters,
      ));
      this.allCharacters = allCharacters;
    });
    return allCharacters;
  }

  void quotes() {

    charactersRepository.getAllQuotes().then((allQuotes) {
      emit(QuotesLoaded(
        allQuotes,
      ));
    });
  }
}
