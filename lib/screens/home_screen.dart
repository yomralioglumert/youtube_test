import 'package:flutter/material.dart';
import 'package:youtube_test/models/channel_model.dart';
import 'package:youtube_test/models/video_model.dart';
import 'package:youtube_test/screens/video_screen.dart';
import 'package:youtube_test/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.channelId});
  final String channelId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChannelModel? _channel;
  bool _isLoading = false;

  @override
  void initState() {
    _initChannel();
    super.initState();
  }

  _initChannel() async {
    ChannelModel channel =
        await APIService.instance.fetchChannel(widget.channelId);
    setState(() {
      _channel = channel;
    });
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance.fetchVideosFromPlaylist(
      playlistId: _channel!.uploadPlaylistId,
    );
    List<Video> allVideos = _channel!.videos!..addAll(moreVideos);
    setState(() {
      _channel!.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YouTube Channel"),
      ),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel!.videos!.length !=
                        int.parse(_channel!.videoCount!) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: 1 + _channel!.videos!.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildProfileInfo();
                  }
                  Video video = _channel!.videos![index - 1];
                  return _buildVideo(video);
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      height: 100.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_channel!.profilePictureUrl!),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel!.title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channel!.subscriptionCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(id: video.id!),
          ),
        );
      },
      child: Row(
        children: [
          Image(
            width: 150.0,
            image: NetworkImage(video.thumbnailUrl!),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Text(
              video.title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
