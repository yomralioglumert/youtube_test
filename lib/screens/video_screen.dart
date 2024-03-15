import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  const VideoScreen({super.key, required this.id});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video"),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
          },
          progressIndicatorColor: Colors.blueAccent,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
      ),
    );
  }
}
