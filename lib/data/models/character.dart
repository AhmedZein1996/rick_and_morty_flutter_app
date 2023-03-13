import 'dart:developer';

import 'package:flutterblockapp/constants/strings.dart';

class Character {
  late final dynamic id;
  late final String name;
  late final String status;
  late final String species;
  late final String gender;
  late final String image;
  late final List<dynamic> episodeAppearanceUrlsFromRest;
  late final List<dynamic> episodeAppearanceFromGraphQl;

  Character.fromJson(Map<String, dynamic> json, {required ApiType apiType}) {
    try{
      id = json['id'];
      name = json['name'];
      status = json['status'];
      species = json['species'];
      gender = json['gender'];
      image = json['image'];
      if(apiType == ApiType.restApi) {
        episodeAppearanceUrlsFromRest = json['episode'];
        episodeAppearanceFromGraphQl = [];
      }else{
        episodeAppearanceFromGraphQl =
            (json['episode'] as List<dynamic>)
                .map((
                episode) => episode['episode'])
                .toList();
        episodeAppearanceUrlsFromRest = [];
      }
    }catch(e){
      log('hello from error : $e');
    }
  }
}

//class Episode {
//  final String id;
//  final String name;
//  final String episode;
//
//  Episode({ required this.episode});
//}
