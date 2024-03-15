import 'package:youtube_test/models/video_model.dart';

class ChannelModel {
  final String? id;
  final String? title;
  final String? profilePictureUrl;
  final String? subscriptionCount;
  final String? videoCount;
  final String? uploadPlaylistId;
  List<Video>? videos;

  ChannelModel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriptionCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos,
  });
  factory ChannelModel.fromMap(Map<String, dynamic> map) {
    return ChannelModel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriptionCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}
