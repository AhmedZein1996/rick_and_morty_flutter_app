import 'dart:developer';

import 'package:flutterblockapp/constants/strings.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CharactersWebServicesGraphQl {
  List<dynamic> result = [];
  Future<List<dynamic>> getAllCharacters() async {
    QueryResult<dynamic> result = await graphQLClient
        .query(
      QueryOptions(
        document: gql(charactersQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    try {
        return result.data!['characters']['results'];
    } catch(e){
      log('error is : $e');
      return [];
    }
//

//        .then(
//      (result) {
//        log('charactersQuery from webservigraphql is : ${result.data!['characters']['results']}');
//        this.result = result.data!['characters']['results'];
//      },
//    ).catchError((error) {
//      log('error is : $error');
//    });

  }
}
