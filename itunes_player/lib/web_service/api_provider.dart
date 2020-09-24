import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:itunes_player/model/song_model.dart';
import 'package:itunes_player/utilities/app_strings.dart';

class ApiProvider {
  http.Client client = http.Client();

  Future<List<SongModel>> fetchSongList(String searchString) async {
    String url = AppStrings.apiBaseUrl + 'search?term=$searchString';

    final response = await client.get(url);
    var parsedJson = json.decode(response.body);
    if (int.parse(parsedJson['resultCount'].toString()) != 0) {
      return (parsedJson['results'] as List)
          .map((p) => SongModel.fromJson(p))
          .toList();
    } else if (int.parse(parsedJson['resultCount'].toString()) == 0) {
      throw "Result not available!";
    } else {
      throw response.reasonPhrase;
    }
  }
}
