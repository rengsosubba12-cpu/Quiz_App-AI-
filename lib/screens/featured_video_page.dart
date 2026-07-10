import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Featured Video - Chill Update page.
/// Displays a functional, responsive YouTube player in full screen.
class FeaturedVideoPage extends StatefulWidget {
  const FeaturedVideoPage({super.key});

  @override
  State<FeaturedVideoPage> createState() => _FeaturedVideoPageState();
}

class _FeaturedVideoPageState extends State<FeaturedVideoPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'kF-gtBQ-BUk',
      autoPlay: true,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Featured Video - Chill Update'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: 9 / 16, // Shorts are vertical
        ),
      ),
    );
  }
}
