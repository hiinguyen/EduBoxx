import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../shell/block_states.dart';
import '../../theme/breakpoints.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';

/// The four status families of app-direction section 3.4.
enum StatusTone { positive, notice, negative, neutral }

/// A stamped status word. Colour reinforces the word; it never replaces it.
class StatusStamp extends StatelessWidget {
  const StatusStamp({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = EduPalette.of(context);
    final (fg, fill, ink, border) = switch (tone) {
      StatusTone.positive => (
        palette.positive,
        palette.positiveFill,
        palette.positiveInk,
        palette.positiveBorder,
      ),
      StatusTone.notice => (
        palette.notice,
        palette.noticeFill,
        palette.noticeInk,
        palette.noticeBorder,
      ),
      StatusTone.negative => (
        palette.negative,
        EduColors.negativeFill,
        EduColors.negativeInk,
        EduColors.negativeBorder,
      ),
      StatusTone.neutral => (
        palette.muted,
        palette.neutralFill,
        palette.neutralInk,
        palette.neutralBorder,
      ),
    };
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.statusSemantics(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(EduRadius.small),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: EduFonts.mono,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 18 / 12,
                color: ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A page's title block plus its scrollable body. Student and parent screens
/// cap the reading width; teacher screens use the canvas width.
class LearningPage extends StatelessWidget {
  const LearningPage({
    super.key,
    required this.title,
    required this.children,
    this.action,
    this.subtitle,
    this.capped = true,
    this.headerKey,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final List<Widget> children;
  final bool capped;
  final Key? headerKey;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final window = WindowClass.of(MediaQuery.sizeOf(context).width);
    final density = EduDensity.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (headerKey != null)
          KeyedSubtree(key: headerKey, child: const SizedBox.shrink()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: EduSpace.s16),
              action!,
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: EduSpace.s4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: EduPalette.of(context).muted,
            ),
          ),
        ],
        SizedBox(
          height: AppLocalizations.of(context).appName.isEmpty
              ? 0
              : density.gap,
        ),
        ...children,
      ],
    );
    final body = Padding(
      padding:
          padding ??
          EdgeInsets.fromLTRB(
            window.gutter,
            density.gap,
            window.gutter,
            EduSpace.s32,
          ),
      child: capped
          ? Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: EduSize.readingMaxWidth,
                ),
                child: content,
              ),
            )
          : content,
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: [body],
    );
  }
}

/// A card with a small eyebrow/title and optional trailing action.
class LearningPanel extends StatelessWidget {
  const LearningPanel({
    super.key,
    required this.child,
    this.title,
    this.action,
  });

  final Widget child;
  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return EduPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ?action,
              ],
            ),
          if (title != null) const SizedBox(height: EduSpace.s16),
          child,
        ],
      ),
    );
  }
}

/// A labelled field: label above, never a floating label or a placeholder as
/// the label (app-direction house rule 11).
class LearningField extends StatelessWidget {
  const LearningField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: EduSpace.s8),
        child,
      ],
    );
  }
}

/// A neutral sentence used for empty states inside a block.
class EmptySentence extends StatelessWidget {
  const EmptySentence(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: EduPalette.of(context).muted,
    ),
  );
}

/// "dd/MM" or "dd/MM/yyyy, HH:mm" in the mono timestamp face.
String learningDate(DateTime? value, {bool withTime = false}) {
  if (value == null) return '';
  final local = value.toLocal();
  final date =
      '${local.day.toString().padLeft(2, '0')}/'
      '${local.month.toString().padLeft(2, '0')}/'
      '${local.year}';
  if (!withTime) return date;
  return '$date, ${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

/// "2:05" for a duration.
String learningDuration(Duration value) {
  final minutes = value.inMinutes;
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
