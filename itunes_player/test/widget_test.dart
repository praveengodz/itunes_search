// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../lib/utilities/app_strings.dart';

void main() {
  test('test success endpoint', () async {
    expectRequestSentTo('https://itunes.apple.com/search?term=');
  });

  test('test failure endpoint', () async {
    expectRequestSentTo('https://apple.com/search?term=');
  });

  test('test responds body', () async {
    expectRequestContainsBody("high");
  });
}

void expectRequestSentTo(String endpoint) {
  String url = AppStrings.apiBaseUrl + 'search?term=';
  expect(url, endpoint);
}

Future<void> expectRequestContainsBody(String fileName) async {
  var body =  await fetchSongList(fileName);
  final Map <dynamic,dynamic> expectedBody = {
    "wrapperType": "track",
    "kind": "song",
    "artistId": 27496674,
    "collectionId": 714602877,
    "trackId": 714604010,
    "artistName": "James Blunt",
    "collectionName": "Back To Bedlam",
    "trackName": "High",
    "collectionCensoredName": "Back To Bedlam",
    "trackCensoredName": "High",
    "artistViewUrl": "https://music.apple.com/us/artist/james-blunt/27496674?uo=4",
    "collectionViewUrl": "https://music.apple.com/us/album/high/714602877?i=714604010&uo=4",
    "trackViewUrl": "https://music.apple.com/us/album/high/714602877?i=714604010&uo=4",
    "previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/Music6/v4/e4/97/e4/e497e4ce-a9ee-2987-1ef3-938d65780f94/mzaf_1649782100294538139.plus.aac.p.m4a",
    "artworkUrl30": "https://is3-ssl.mzstatic.com/image/thumb/Music6/v4/5e/40/4a/5e404ae7-3a48-d86b-24ac-45ba41cff050/source/30x30bb.jpg",
    "artworkUrl60": "https://is3-ssl.mzstatic.com/image/thumb/Music6/v4/5e/40/4a/5e404ae7-3a48-d86b-24ac-45ba41cff050/source/60x60bb.jpg",
    "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music6/v4/5e/40/4a/5e404ae7-3a48-d86b-24ac-45ba41cff050/source/100x100bb.jpg",
    "collectionPrice": 9.99,
    "trackPrice": 1.29,
    "releaseDate": "2004-10-11T07:00:00Z",
    "collectionExplicitness": "explicit",
    "trackExplicitness": "notExplicit",
    "discCount": 1,
    "discNumber": 1,
    "trackCount": 11,
    "trackNumber": 1,
    "trackTimeMillis": 242776,
    "country": "USA",
    "currency": "USD",
    "primaryGenreName": "Pop",
    "isStreamable": true
  };
  expect(body, expectedBody["results"][0]);
}

Future<Map <dynamic,dynamic>> fetchSongList(String searchString) async {
  http.Client client = http.Client();
  String url = AppStrings.apiBaseUrl + 'search?term=$searchString';
  final response = await client.get(url);
  var parsedJson = json.decode(response.body);
  return parsedJson;
}