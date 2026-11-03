import 'package:edubox_client/edubox_client.dart' show ContentType;
import 'package:flutter/material.dart';

import 'ebook_reader_screen.dart';

/// Routes an e-book to the PDF reader and a video to the player.
class ContentViewerScreen extends StatelessWidget {
  const ContentViewerScreen({
    super.key,
    required this.contentId,
    required this.title,
    required this.type,
    this.pageCount,
  });

  final int contentId;
  final String title;
  final ContentType type;
  final int? pageCount;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ContentType.video => VideoLessonScreen(
        contentId: contentId,
        title: title,
      ),
      _ => EbookReaderScreen(
        contentId: contentId,
        title: title,
        knownPageCount: pageCount,
      ),
    };
  }
}
