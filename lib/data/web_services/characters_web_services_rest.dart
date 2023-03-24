
import 'package:dio/dio.dart';
import 'package:flutterblockapp/constants/strings.dart';

class CharactersWebServicesRest {
  late Dio dio;

  CharactersWebServicesRest() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('character');
      return response.data['results'];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getAllQuotes() async {

    const url = 'https://zenquotes.io/api/quotes';

    try {
      Response response = await Dio().get(
        url,
      );
        return response.data;
    } catch (e) {
      return [];
    }
  }
}
