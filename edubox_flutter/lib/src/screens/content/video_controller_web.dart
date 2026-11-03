import 'package:video_player/video_player.dart';

VideoPlayerController createVideoController({
  required String? localPath,
  required Uri networkUrl,
}) => VideoPlayerController.networkUrl(networkUrl);
