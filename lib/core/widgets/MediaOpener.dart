import 'dart:io';
// import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:colibri/core/common/media/media_data.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/features/feed/presentation/widgets/create_post_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:colibri/extensions.dart';

class MediaOpener extends StatefulWidget {
  final MediaData data;
  const MediaOpener({Key key, this.data}) : super(key: key);
  @override
  _MediaOpenerState createState() => _MediaOpenerState();
}

class _MediaOpenerState extends State<MediaOpener> {
  @override
  Widget build(BuildContext context) {
    switch (widget.data.type) {
      case MediaTypeEnum.IMAGE:
        return OpenImage(
          path: widget.data.path,
        );
        break;
      case MediaTypeEnum.VIDEO:
        return MyVideoPlayer(
          path: widget.data.path,
        );
        break;
      case MediaTypeEnum.GIF:
        return OpenImage(
          path: widget.data.path,
        );
        break;
      case MediaTypeEnum.EMOJI:
        return Container();
        break;
      default:
        return Container();
    }
  }
}

/// video player code...

class MyVideoPlayer extends StatefulWidget {
  final String path;
  final bool withAppBar;
  final bool fullVideoControls;
  final bool isComeHome;

  const MyVideoPlayer({
    Key key,
    this.path,
    this.withAppBar = true,
    this.fullVideoControls = false,
    this.isComeHome,
  }) : super(key: key);
  @override
  MyVideoPlayerState createState() => MyVideoPlayerState();
}

class MyVideoPlayerState extends State<MyVideoPlayer> {
  BetterPlayerController _betterPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    isPlaying = widget.fullVideoControls;
    playerControllerShow();
  }

  // This kicks of then playing video
  playerControllerShow() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      widget.path.contains("https")
          ? BetterPlayerDataSourceType.network
          : BetterPlayerDataSourceType.file,
      widget.path,
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        fit: BoxFit.fitHeight,
        controlsConfiguration: isPlaying
            ? const BetterPlayerControlsConfiguration(
                enablePlayPause: true,
              )
            : const BetterPlayerControlsConfiguration(
                enableFullscreen: false,
                showControlsOnInitialize: false,
                showControls: false,
              ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  void pause() {
    _betterPlayerController.pause();
  }

  void play() {
    _betterPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return widget.withAppBar ? withAppBarWidget() : withOutAppBarWidget();
  }

  Widget withAppBarWidget() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: "Video Player".toSubTitle1(
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: SafeArea(
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      ),
    );
  }

  Widget withOutAppBarWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        BetterPlayer(
          controller: _betterPlayerController,
        ),
        if (!widget.fullVideoControls)
          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              height: 45.toHeight,
              width: 45.toHeight,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black54),
              child: const Icon(
                FontAwesomeIcons.play,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
  }
}

class ModelVideoPlayer extends StatefulWidget {
  final String path;
  const ModelVideoPlayer({Key key, this.path}) : super(key: key);

  @override
  _ModelVideoPlayerState createState() => _ModelVideoPlayerState();
}

class _ModelVideoPlayerState extends State<ModelVideoPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: AwsomeVideoPlayer(
            widget.path,
            playOptions: VideoPlayOptions(
              seekSeconds: 10,
              aspectRatio: 16 / 9,
              loop: true,
              autoplay: false,
              allowScrubbing: false,
              startPosition: Duration(seconds: 0),
            ),
            videoStyle: VideoStyle(
              playIcon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5)),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 50),
              ),
              showPlayIcon: true,
              showReplayIcon: true,
              videoControlBarStyle: VideoControlBarStyle(
                progressStyle:
                    VideoProgressStyle(playedColor: AppColors.alertBg),
                bufferedColor: AppColors.alertBg,
                playIcon:
                    const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                pauseIcon: const Icon(
                  Icons.pause,
                  color: AppColors.white,
                  size: 16,
                ),
                rewindIcon: const Icon(
                  Icons.replay_30,
                  size: 16,
                  color: Colors.white,
                ),
                forwardIcon: const Icon(
                  Icons.forward_30,
                  size: 16,
                  color: Colors.white,
                ),
                fullscreenIcon: const Icon(
                  Icons.fullscreen,
                  size: 16,
                  color: Colors.white,
                ),
                fullscreenExitIcon: const Icon(
                  Icons.fullscreen_exit,
                  size: 16,
                  color: AppColors.alertBg,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OpenImage extends StatelessWidget {
  final String path;

  const OpenImage({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: "Gallery".toSubTitle1(
            color: AppColors.textColor, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: path.isValidUrl
              ? Image.network(path, headers: {'accept': 'image/*'})
              : FileImage(
                  File(path),
                ),
        ),
      ),
    );
  }
}
