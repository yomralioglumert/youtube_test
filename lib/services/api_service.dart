import 'dart:convert';

import 'package:youtube_test/models/channel_model.dart';
import 'package:youtube_test/models/video_model.dart';
import 'package:youtube_test/utilities/keys.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService._instantiate(); // Private constructor

  static final APIService instance =
      APIService._instantiate(); // Singleton instance

  final String _baseUrl = 'www.googleapis.com'; // Base URL
  String _nextPageToken = ""; // Next page token

  Future<ChannelModel> fetchChannel(String channelId) async {
    Map<String, String> parameters = {
      "part": "snippet, contentDetails, statistics",
      "id": channelId,
      "key": API_KEY
    };
    Uri uri = Uri.https(_baseUrl, "/youtube/v3/channels", parameters);

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    // Get channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)["items"][0];
      ChannelModel channel = ChannelModel.fromMap(data);

      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    }
    throw json.decode(response.body)["error"]["message"];
  }

  Future<List<Video>> fetchVideosFromPlaylist({String? playlistId}) async {
    Map<String, String> parameters = {
      "part": "snippet",
      "playlistId": playlistId!,
      "maxResults": "8",
      "pageToken": _nextPageToken,
      "key": API_KEY
    };
    Uri uri = Uri.https(_baseUrl, "/youtube/v3/playlistItems", parameters);

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    // Get Playlist Videos

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _nextPageToken = data["nextPageToken"] ?? "";
      List<dynamic> videosJson = data["items"];

      // Feetch first 8 videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(Video.fromMap(json["snippet"])),
      );
      return videos;
    }
    throw json.decode(response.body)["error"]["message"];
  }
}
