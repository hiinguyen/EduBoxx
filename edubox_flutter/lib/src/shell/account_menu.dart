import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/theme_extensions.dart';
import '../theme/tokens.dart';

/// An icon button (tooltip = accessible name) that opens a menu with a
/// non-interactive header ([lines]: name, then muted details), a rule, and
/// one "Đăng xuất" item.
class AccountMenuButton extends StatelessWidget {
  const AccountMenuButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.lines,
    required this.onSignOut,
    this.busy = false,
  });

  final String tooltip;
  final Widget icon;
  final List<String> lines;
  final VoidCallback onSignOut;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final palette = EduPalette.of(context);
    return MenuAnchor(
      menuChildren: [
        if (lines.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              EduSpace.s16,
              EduSpace.s12,
              EduSpace.s16,
              EduSpace.s12,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lines.first, style: text.titleMedium),
                  for (final line in lines.skip(1))
                    Text(
                      line,
                      style: text.bodyMedium!.copyWith(color: palette.muted),
                    ),
                ],
              ),
            ),
          ),
        if (lines.isNotEmpty) const Divider(),
        MenuItemButton(
          key: const Key('shell.menuSignOut'),
          leadingIcon: const Icon(Icons.logout_outlined, size: 18),
          onPressed: busy ? null : onSignOut,
          child: Text(busy ? l10n.signOutBusy : l10n.signOut),
        ),
      ],
      builder: (context, controller, _) => Tooltip(
        // Keeps the control findable by its tooltip and is the accessible
        // name's single source: the tooltip itself is excluded from
        // semantics. Its own bubble is held back; the themed bubble below
        // is the one users see, and it carries no semantics.
        message: tooltip,
        excludeFromSemantics: true,
        triggerMode: TooltipTriggerMode.manual,
        waitDuration: const Duration(days: 1),
        child: RawTooltip(
          semanticsTooltip: null,
          tooltipBuilder: (context, animation) =>
              _UnspokenTooltip(animation: animation, message: tooltip),
          child: IconButton(
            key: const Key('shell.accountMenu'),
            icon: Semantics(label: tooltip, child: icon),
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
      ),
    );
  }
}

/// The themed tooltip bubble, excluded from semantics: the account button
/// already exposes exactly one accessible name.
class _UnspokenTooltip extends StatelessWidget {
  const _UnspokenTooltip({required this.animation, required this.message});

  final Animation<double> animation;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tooltipTheme = theme.tooltipTheme;
    return FadeTransition(
      opacity: animation,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints:
              tooltipTheme.constraints ??
              const BoxConstraints(minHeight: EduSpace.s24),
          child: Container(
            decoration: tooltipTheme.decoration,
            padding:
                tooltipTheme.padding ??
                const EdgeInsets.symmetric(
                  horizontal: EduSpace.s8,
                  vertical: EduSpace.s4,
                ),
            margin: tooltipTheme.margin,
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text(
                message,
                textAlign: tooltipTheme.textAlign ?? TextAlign.start,
                style: tooltipTheme.textStyle ?? theme.textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A full-circle initials disc (people are the only circles).
class InitialsDisc extends StatelessWidget {
  const InitialsDisc({super.key, required this.initials, this.size = 32});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = EduPalette.of(context);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: palette.active,
          shape: BoxShape.circle,
        ),
        child: Text(
          initials,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: palette.ink,
          ),
        ),
      ),
    );
  }
}

/// The extended rail's bottom user row: [leading], name and detail lines,
/// then a visible "Đăng xuất" text button (48dp).
class RailUserRow extends StatelessWidget {
  const RailUserRow({
    super.key,
    required this.lines,
    required this.onSignOut,
    this.leading,
    this.busy = false,
    this.firstLineIsName = true,
  });

  final Widget? leading;
  final List<String> lines;
  final VoidCallback onSignOut;
  final bool busy;

  /// False when the first line is not a name (the teacher's email row),
  /// so every line is muted body text.
  final bool firstLineIsName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final palette = EduPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: EduSpace.s8),
            ],
            Expanded(
              // One node for the identity lines ("name\nclass").
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lines.isNotEmpty)
                      Text(
                        lines.first,
                        style: firstLineIsName
                            ? text.titleSmall
                            : text.bodyMedium!.copyWith(color: palette.muted),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    for (final line in lines.skip(1))
                      Text(
                        line,
                        style: text.bodyMedium!.copyWith(color: palette.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: EduSpace.s8),
        TextButton.icon(
          key: const Key('shell.railSignOut'),
          onPressed: busy ? null : onSignOut,
          icon: const Icon(Icons.logout_outlined, size: 18),
          label: Text(busy ? l10n.signOutBusy : l10n.signOut),
        ),
      ],
    );
  }
}
