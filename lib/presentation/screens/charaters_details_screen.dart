import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterblockapp/business_logic/cubit/characters_cubit.dart';
import 'package:flutterblockapp/business_logic/cubit/characters_state.dart';
import 'package:flutterblockapp/constants/colors.dart';
import 'package:flutterblockapp/constants/strings.dart';
import 'package:flutterblockapp/data/models/character.dart';
import 'package:flutterblockapp/data/models/quote.dart';
import 'package:flutterblockapp/presentation/format_episode_urls_to_episodes_and_seasons.dart';
import 'package:flutterblockapp/presentation/widgets/show_loaded_indicator.dart';

class CharactersDetailsScreen extends StatefulWidget {
  final Character character;
  final ApiType apiType;

  const CharactersDetailsScreen({Key? key, required this.character, required this.apiType})
      : super(key: key);

  @override
  State<CharactersDetailsScreen> createState() =>
      _CharactersDetailsScreenState();
}

class _CharactersDetailsScreenState extends State<CharactersDetailsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).quotes();
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.character.name,
          style: const TextStyle(
            color: MyColors.myWhite,
          ),
        ),
        background: Hero(
          tag: widget.character.id.toString(),
          child: Image.network(
            widget.character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  RichText charactersInfo(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Divider buildDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      height: 30,
      thickness: 2,
      endIndent: endIndent,
    );
  }

  Widget checkIfQuoteIsLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return const ShowLoadingIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(QuotesLoaded state) {
    final List<Quote> quotes = state.quotes;
    if (quotes.isNotEmpty) {
      int randomQuotesIndex = Random().nextInt(quotes.length);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style:
              const TextStyle(fontSize: 20, color: MyColors.myWhite, shadows: [
            Shadow(
              blurRadius: 7,
              color: MyColors.myYellow,
              offset: Offset(0, 0),
            ),
          ]),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuotesIndex].quote),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  String separateEpisodeNumberFromEpisodeUrlAndJoinTogether(ApiType apiType) {
    if(apiType == ApiType.restApi){
      String separator = " / ";
      final List<dynamic> formattedEpisodeSndSeasonList = formatEpisodeUrlsToEpisodesAndSeasonsList(widget.character.episodeAppearanceUrlsFromRest);
      String joinedNumbers = formattedEpisodeSndSeasonList.join(separator);
      return joinedNumbers;
    }else{
      return widget.character.episodeAppearanceFromGraphQl
          .join(' / ');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      charactersInfo('Gender : ', widget.character.gender),
                      buildDivider(290.0),
                      charactersInfo('species : ', widget.character.species),
                      buildDivider(280.0),
                      charactersInfo(
                        'Episode Appearance : ',
                          separateEpisodeNumberFromEpisodeUrlAndJoinTogether(widget.apiType)
                      ),
                      buildDivider(180.0),
                      charactersInfo('status : ', widget.character.status),
                      buildDivider(290.0),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersState>(
                          builder: (context, state) {
                        return checkIfQuoteIsLoaded(state);
                      })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
