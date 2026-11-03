import 'dart:io';

import 'package:video_player/video_player.dart';

VideoPlayerController createVideoController({
  required String? localPath,
  required Uri networkUrl,
}) => localPath == null
    ? VideoPlayerController.networkUrl(networkUrl)
    : VideoPlayerController.file(File(localPath));
