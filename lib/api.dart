import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youflutter/models/video.dart';

const API_KEY = 'AIzaSyAN5JKaVJ0W0J_VAW7JMKYVn14kNdfK_sE';
const int MAX_RESULT = 10;

/**
 * References API Endpoint
 * 
 * - https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10
 * 
 * - https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken
 * 
 * - http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json
 * 
 */

class Api {
  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;

    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=$MAX_RESULT');

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=$MAX_RESULT&pageToken=$_nextToken');

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded['items'].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }
}