import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';
import 'dart:io';

class YoutubeViewer extends StatefulWidget {
  final String videoUrl;
  final bool? autoPlayVideo;

  const YoutubeViewer({
    Key? key,
    required this.videoUrl,
    this.autoPlayVideo,
  }) : super(key: key);

  @override
  _YoutubeViewerState createState() => _YoutubeViewerState();
}

class _YoutubeViewerState extends State<YoutubeViewer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(widget.videoUrl) ?? "", // livestream example
      params: YoutubePlayerParams(
        loop: false,
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        autoPlay: widget.autoPlayVideo ?? true,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        useHybridComposition: true,
        playsInline: false,
      ),
    )..listen((value) {
        if (value.isReady && !value.hasPlayed) {
          _controller
            ..hidePauseOverlay()
            ..hideTopMenu();
        }
        if (value.hasPlayed) {
          _controller.hideEndScreen();
        }
      });

    _controller.onExitFullscreen = () async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    };



    _controller.onEnterFullscreen = () async {
      if(Platform.isAndroid){
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(
      aspectRatio: 16 / 9,
    );
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: player,
    );
  }
}
