import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterblockapp/business_logic/cubit/characters_cubit.dart';
import 'package:flutterblockapp/business_logic/cubit/characters_state.dart';
import 'package:flutterblockapp/constants/colors.dart';
import 'package:flutterblockapp/constants/strings.dart';
import 'package:flutterblockapp/presentation/widgets/characters_item.dart';

import '../../data/models/character.dart';
import '../widgets/show_loaded_indicator.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> characters = [];
  List<Character> searchedCharacters = [];
  bool _isSearching = false;
  final _searchTextController = TextEditingController();
  final ApiType apiType = ApiType.graphQlApi;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).characters(apiType: apiType);
  }

  Widget _buildSearchFiled() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      autofocus: true,
      decoration: const InputDecoration(
          hintText: 'Find a character',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: MyColors.myGrey,
            fontSize: 18,
          )),
      style: const TextStyle(
        color: MyColors.myGrey,
        fontSize: 18,
      ),
      onChanged: (value) {
        addSearchedItemToSearchedCharacters(value);
      },
    );
  }

  addSearchedItemToSearchedCharacters(String value) {
    setState(() {
      searchedCharacters = characters
          .where((character) => character.name.toLowerCase().startsWith(value))
          .toList();
    });
  }

  Widget _buildAppBarTitle() {
    return Text(
     apiType == ApiType.restApi ? 'Rest Api Characters' : 'GraphQl Api Characters',
      style: const TextStyle(
        color: MyColors.myGrey,
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _stopSearching;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MyColors.myGrey,
            ))
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearching,
            icon: const Icon(
              Icons.search,
              color: MyColors.myGrey,
            ))
      ];
    }
  }

  void _startSearching() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    setState(() {
      _searchTextController.clear();
      _isSearching = false;
    });
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (BuildContext context, state) {
      if (state is CharactersLoaded) {
        characters = state.characters;
        return buildLoadedCharactersWidget();
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildLoadedCharactersWidget() {
    return _searchTextController.text.isNotEmpty
        ? checkIfLoadedOrSearchedCharactersIsNotEmpty(searchedCharacters)
        : checkIfLoadedOrSearchedCharactersIsNotEmpty(characters);
  }

  Widget checkIfLoadedOrSearchedCharactersIsNotEmpty(
      List<Character> loadedOrSearchedCharacters) {
    return loadedOrSearchedCharacters.isNotEmpty
        ? SingleChildScrollView(
            child: Container(
              color: MyColors.myGrey,
              child: Column(
                children: [
                  buildCharactersGridView(),
                ],
              ),
            ),
          )
        : const Center(
            child: Text(
              'There is no characters',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.myWhite),
            ),
          );
  }

  Widget buildCharactersGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _searchTextController.text.isNotEmpty
          ? searchedCharacters.length
          : characters.length,
      itemBuilder: (context, index) => CharactersItem(
        apiType: apiType,
        character: _searchTextController.text.isNotEmpty
            ? searchedCharacters[index]
            : characters[index],
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Please check your internet connnection....',
              style: TextStyle(
                color: MyColors.myGrey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset('assets/images/no_internet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        leading: _isSearching
            ? const BackButton(
                color: MyColors.myGrey,
              )
            : null,
        title: _isSearching ? _buildSearchFiled() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: buildBlocWidget(),
//      OfflineBuilder(
//        connectivityBuilder: (BuildContext context,
//            ConnectivityResult connectivity, Widget child) {
//          final bool connected = connectivity != ConnectivityResult.none;
//          if (connected) {
//            return buildBlocWidget();
//          } else {
//            return buildNoInternetWidget();
//          }
//        },
//        child: const ShowLoadingIndicator(),
//      ),
    );
  }
}
