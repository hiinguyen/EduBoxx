import 'package:flutter/painting.dart';

/// Raw design tokens from docs/design/app-direction.md (achromatic-ledger).
///
/// Widgets never use these directly: they read `Theme.of(context)` and the
/// theme extensions in `theme_extensions.dart`. Only `edu_theme.dart` and the
/// extensions read this file.
abstract final class EduColors {
  static const paper = Color(0xFFEEF2FA);
  static const sheet = Color(0xFFFFFFFF);
  static const ink = Color(0xFF161B29);
  static const muted = Color(0xFF4A5468);
  static const accent = Color(0xFF1D4ED8);
  static const accentPale = Color(0xFFDEE8FE);
  static const accentInk = Color(0xFF14318F);
  static const active = Color(0xFFE2E8F4);
  static const rule = Color(0xFFDCE2EF);
  static const control = Color(0xFF6C7891);
  static const disabled = Color(0xFF8B93A5);
  static const inverseAccent = Color(0xFFBBD0FF);
  static const hover = Color(0xFFF7F9FE);
  static const surfaceFallback = Color(0xFFE7EDF8);
  static const surfaceDim = Color(0xFFDFE6F3);

  // Status families (section 3.4): fg, fill, ink, border.
  static const negative = Color(0xFFB3261E);
  static const negativeFill = Color(0xFFFBE9E7);
  static const negativeInk = Color(0xFF7A1A14);
  static const negativeBorder = Color(0xFFEDB9B3);
  static const neutralFill = Color(0xFFE7EBF3);
  static const neutralInk = Color(0xFF2A3242);
  static const neutralBorder = Color(0xFFC9D0DE);

  // Positive and notice families used by status stamps.
  static const positive = Color(0xFF1E6F45);
  static const positiveFill = Color(0xFFE2F2E8);
  static const positiveInk = Color(0xFF0E4026);
  static const positiveBorder = Color(0xFFA9D5BA);
  static const notice = Color(0xFF8A5300);
  static const noticeFill = Color(0xFFFDF3D7);
  static const noticeInk = Color(0xFF5E3800);
  static const noticeBorder = Color(0xFFE9CF8A);
}

/// Font family names; they must match `flutter: fonts:` in pubspec.yaml.
abstract final class EduFonts {
  static const display = 'Bitter';
  static const body = 'BeVietnamPro';
  static const mono = 'IBMPlexMono';
}

/// The 4dp spacing scale (section 3.5).
abstract final class EduSpace {
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
  static const s48 = 48.0;
  static const s64 = 64.0;
}

/// The tight radius pair plus stamps (section 3.6). Nothing else is allowed.
abstract final class EduRadius {
  /// Cards, panels, tables, dialogs, menus.
  static const panel = 8.0;

  /// Buttons, text fields, answer options.
  static const control = 6.0;

  /// Stamps, chips, cover thumbnails, tooltips, skeleton bars.
  static const small = 4.0;
}

/// Fixed sizes used across screens.
abstract final class EduSize {
  /// Minimum tap target (Android guideline).
  static const tapTarget = 48.0;

  /// Student/pre-auth primary button and field height.
  static const primaryButton = 56.0;

  /// Pre-auth panel width (sign-in, account-not-set-up).
  static const authPanelWidth = 400.0;

  /// Reading-content cap for student and parent screens.
  static const readingMaxWidth = 760.0;

  /// Height of the app-wide offline / reconnecting strip.
  static const offlineStrip = 40.0;

  /// The index-card mark glyph.
  static const mark = 24.0;

  /// Inline status glyph next to an error or notice sentence.
  static const statusGlyph = 18.0;

  /// Rail widths.
  static const railCollapsed = 88.0;
  static const railExtended = 240.0;

  /// Hairline.
  static const hairline = 1.0;
}

/// Motion: feedback only, 150-200ms standard easing.
abstract final class EduMotion {
  static const fast = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 200);
}
