import 'dart:convert';
import 'dart:typed_data';

import '../config/edubox_config.dart';
import '../generated/protocol.dart';

/// Thrown when an uploaded file fails ingest validation.
class IngestRejected implements Exception {
  const IngestRejected(this.reason);

  final String reason;

  @override
  String toString() => 'IngestRejected($reason)';
}

/// The validated, normalized facts about an uploaded file.
class IngestResult {
  const IngestResult({
    required this.mimeType,
    required this.sizeBytes,
    this.pageCount,
    this.durationSeconds,
  });

  final String mimeType;
  final int sizeBytes;
  final int? pageCount;
  final int? durationSeconds;
}

/// Content ingest: validation plus metadata normalization, no transcoding
/// (the roadmap's 2026-10-29 ruling). PDF page count and MP4 duration are
/// read from the bytes; EPUB is not accepted in this build because no
/// offline EPUB reader ships, and a clear rejection is better than a file the
/// student cannot open.
abstract final class ContentIngest {
  static const pdfMagic = [0x25, 0x50, 0x44, 0x46, 0x2D]; // %PDF-
  static const mp4Ftyp = [0x66, 0x74, 0x79, 0x70]; // ftyp

  static IngestResult validate({
    required ContentType type,
    required FixtureBytes bytes,
    required String fileName,
    required LearningConfig limits,
  }) {
    if (bytes.bytes.isEmpty) {
      throw const IngestRejected('Tệp rỗng.');
    }
    final data = bytes.bytes;
    switch (type) {
      case ContentType.ebook:
        if (data.length > limits.maxEbookBytes) {
          throw IngestRejected(
            'Sách vượt quá dung lượng cho phép '
            '(${limits.maxEbookBytes ~/ (1024 * 1024)} MB).',
          );
        }
        if (!_startsWith(data, pdfMagic)) {
          throw const IngestRejected(
            'Chỉ nhận sách PDF. Tệp này không phải PDF hợp lệ.',
          );
        }
        final pages = pdfPageCount(data);
        if (pages < 1) {
          throw const IngestRejected('Không đọc được số trang của tệp PDF.');
        }
        return IngestResult(
          mimeType: 'application/pdf',
          sizeBytes: data.length,
          pageCount: pages,
        );
      case ContentType.video:
        if (data.length > limits.maxVideoBytes) {
          throw IngestRejected(
            'Video vượt quá dung lượng cho phép '
            '(${limits.maxVideoBytes ~/ (1024 * 1024)} MB).',
          );
        }
        if (data.length < 16 || !_containsAt(data, mp4Ftyp, 4, 12)) {
          throw const IngestRejected(
            'Chỉ nhận video MP4. Tệp này không phải MP4 hợp lệ.',
          );
        }
        final duration = mp4DurationSeconds(data);
        if (duration == null || duration <= 0) {
          throw const IngestRejected('Không đọc được thời lượng của video.');
        }
        return IngestResult(
          mimeType: 'video/mp4',
          sizeBytes: data.length,
          durationSeconds: duration,
        );
      case ContentType.exercise:
        throw const IngestRejected('Bài tập không có tệp đính kèm.');
    }
  }

  /// Counts `/Type /Page` (but not `/Pages`) objects in a PDF. This is a
  /// metadata read, not a renderer, and matches what the reader shows.
  static int pdfPageCount(Uint8List data) {
    final text = latin1.decode(data, allowInvalid: true);
    final direct = RegExp(
      r'/Type\s*/Page\b(?!s)',
      caseSensitive: false,
    ).allMatches(text).length;
    if (direct > 0) return direct;
    final tree = RegExp(
      r'/Count\s+(\d+)',
      caseSensitive: false,
    ).allMatches(text);
    var largest = 0;
    for (final match in tree) {
      final value = int.tryParse(match.group(1)!) ?? 0;
      if (value > largest) largest = value;
    }
    return largest;
  }

  /// Reads the `mvhd` atom's duration/timescale from an MP4.
  static int? mp4DurationSeconds(Uint8List data) {
    for (var index = 0; index + 24 <= data.length; index++) {
      if (data[index] != 0x6D ||
          data[index + 1] != 0x76 ||
          data[index + 2] != 0x68 ||
          data[index + 3] != 0x64) {
        continue;
      }
      // `index` is the first byte of the "mvhd" atom type; the version byte
      // is immediately after the 4-byte type.
      final version = data[index + 4];
      if (version == 0 && index + 24 <= data.length) {
        final timescale = _uint32(data, index + 16);
        final duration = _uint32(data, index + 20);
        if (timescale > 0) {
          return (duration + timescale - 1) ~/ timescale;
        }
      } else if (version == 1 && index + 36 <= data.length) {
        final timescale = _uint32(data, index + 24);
        final duration = _uint64(data, index + 28);
        if (timescale > 0) {
          return (duration + timescale - 1) ~/ timescale;
        }
      }
    }
    return null;
  }

  static bool _startsWith(Uint8List data, List<int> prefix) {
    if (data.length < prefix.length) return false;
    for (var index = 0; index < prefix.length; index++) {
      if (data[index] != prefix[index]) return false;
    }
    return true;
  }

  static bool _containsAt(
    Uint8List data,
    List<int> needle,
    int start,
    int end,
  ) {
    final limit = end < data.length - needle.length
        ? end
        : data.length - needle.length;
    for (var index = start; index <= limit; index++) {
      var match = true;
      for (var offset = 0; offset < needle.length; offset++) {
        if (data[index + offset] != needle[offset]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  static int _uint32(Uint8List data, int offset) =>
      (data[offset] << 24) |
      (data[offset + 1] << 16) |
      (data[offset + 2] << 8) |
      data[offset + 3];

  static int _uint64(Uint8List data, int offset) =>
      (_uint32(data, offset) << 32) | _uint32(data, offset + 4);
}

/// A tiny value object so ingest tests do not depend on Serverpod's ByteData.
class FixtureBytes {
  FixtureBytes(this.bytes);

  final Uint8List bytes;

  factory FixtureBytes.from(ByteData data) =>
      FixtureBytes(Uint8List.sublistView(data));
}
