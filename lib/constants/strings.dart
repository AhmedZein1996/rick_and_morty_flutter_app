import 'package:graphql_flutter/graphql_flutter.dart';

const baseUrl = 'https://rickandmortyapi.com/api/';
const charactersScreen = '/';
const charactersDetailsScreen = 'characters_details';

//const isRestOrGraphQl = '';
enum ApiType{
  restApi,
  graphQlApi
}


GraphQLClient graphQLClient = GraphQLClient(
  cache: GraphQLCache(store: HiveStore()),
  link: HttpLink('https://rickandmortyapi.com/graphql'),
);

const charactersQuery = """
query {
  characters {
    results {
      id
      name
      species
      status
      gender
      image
      episode{
        id
        name
        episode 
       
      }
    }
  }
}
""";
