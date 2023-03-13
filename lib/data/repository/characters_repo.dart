import 'package:flutterblockapp/constants/strings.dart';
import 'package:flutterblockapp/data/models/quote.dart';
import 'package:flutterblockapp/data/web_services/characters_web_services_rest.dart';
import 'package:flutterblockapp/data/web_services/charcters_web_services_graphql.dart';

import '../models/character.dart';

class CharactersRepository {
  final CharactersWebServicesRest charactersWebServicesRest;
  final CharactersWebServicesGraphQl charactersWebServicesGraphQl;

  CharactersRepository(
      this.charactersWebServicesGraphQl, this.charactersWebServicesRest);

  Future<List<Character>> getAllCharacters({required ApiType apiType}) async {
    if (apiType == ApiType.restApi) {
      final characters = await charactersWebServicesRest.getAllCharacters();
      return characters
          .map((character) => Character.fromJson(character, apiType: apiType))
          .toList();
    } else {
      final characters = await charactersWebServicesGraphQl.getAllCharacters();
      return characters
          .map((character) => Character.fromJson(character, apiType: apiType))
          .toList();
    }
  }

  Future<List<Quote>> getAllQuotes() async {
    final quotes = await charactersWebServicesRest.getAllQuotes();
    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
