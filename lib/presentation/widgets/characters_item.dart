import 'package:flutter/material.dart';
import 'package:flutterblockapp/constants/colors.dart';
import 'package:flutterblockapp/constants/strings.dart';
import 'package:flutterblockapp/data/models/character.dart';

class CharactersItem extends StatelessWidget {
  final Character character;
  final ApiType apiType;

  const CharactersItem({Key? key, required this.character, required this.apiType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: MyColors.myWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: (){
          final arguments = {'character': character , 'apiType': apiType};
          Navigator.of(context).pushNamed(charactersDetailsScreen, arguments: arguments);
        },
        child: GridTile(
          child: Hero(
            tag: character.id.toString(),
            child: Container(
              color: MyColors.myGrey,
              child: character.image.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: ('assets/images/loading.gif'),
                      image: character.image)
                  : Image.asset('assets/images/failed.jpg'),
            ),
          ),
          footer: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.black54,
            alignment: Alignment.bottomCenter,
            child: Text(
              character.name,
              style: const TextStyle(
                  fontSize: 18,
                  color: MyColors.myWhite,
                  fontWeight: FontWeight.bold,

              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
