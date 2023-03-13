
import 'package:flutterblockapp/data/models/character.dart';

import '../../data/models/quote.dart';

abstract class CharactersState{}

class CharactersInitial extends CharactersState{

}
class CharactersLoaded extends CharactersState{

  final List<Character> characters;
  CharactersLoaded(this.characters);
}
class QuotesLoaded extends CharactersState{
  final List<Quote> quotes;
  QuotesLoaded(this.quotes);
}