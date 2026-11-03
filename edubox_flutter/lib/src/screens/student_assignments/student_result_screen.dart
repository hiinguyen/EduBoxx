import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show SubmissionResult, SubmissionStatus;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';

class StudentResultScreen extends StatefulWidget {
  const StudentResultScreen({
    super.key,
    required this.assignmentId,
    required this.title,
  });

  final int assignmentId;
  final String title;

  @override
  State<StudentResultScreen> createState() => _StudentResultScreenState();
}

class _StudentResultScreenState extends State<StudentResultScreen> {
  SubmissionResult? _result;
  bool _pending = false;
  BackendError? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final result = await backend.assignments.submissionFor(widget.assignmentId);
    final pending = await backend.assignments.hasPendingSubmission(
      widget.assignmentId,
    );
    if (!mounted) return;
    setState(() {
      _result = result.valueOrNull;
      _pending = pending;
      _error = result.errorOrNull;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: LearningPage(
        title: widget.title,
        children: [
          if (_loading)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (result == null)
            Text(
              _error is OfflineNoCacheError
                  ? l10n.contentNeedsInternet
                  : l10n.resultError,
            )
          else
            LearningPanel(
              title: l10n.resultTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_pending)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: StatusStamp(
                        label: l10n.statusPendingSync,
                        tone: StatusTone.notice,
                        icon: Icons.cloud_upload_outlined,
                      ),
                    )
                  else
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _status(l10n, result),
                    ),
                  const SizedBox(height: EduSpace.s24),
                  if (result.score != null) ...[
                    Text(
                      l10n.resultScore,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: EduPalette.of(context).muted,
                      ),
                    ),
                    Text(
                      l10n.resultScoreValue(
                        _figure(result.score!),
                        _figure(result.maxScore ?? 10),
                      ),
                      style: TextStyle(
                        fontFamily: EduFonts.mono,
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                        height: 40 / 32,
                        color: EduPalette.of(context).ink,
                      ),
                    ),
                  ],
                  if (_pending) ...[
                    const SizedBox(height: EduSpace.s12),
                    Text(l10n.resultPending),
                  ],
                  if (result.late) ...[
                    const SizedBox(height: EduSpace.s12),
                    StatusStamp(
                      label: l10n.resultLate,
                      tone: StatusTone.negative,
                      icon: Icons.schedule,
                    ),
                  ],
                  const SizedBox(height: EduSpace.s32),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.resultBack),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static Widget _status(AppLocalizations l10n, SubmissionResult result) =>
      switch (result.status) {
        SubmissionStatus.graded => StatusStamp(
          label: l10n.statusGraded,
          tone: StatusTone.positive,
          icon: Icons.check,
        ),
        SubmissionStatus.submitted => StatusStamp(
          label: l10n.statusSubmittedAwaitingGrade,
          icon: Icons.schedule,
        ),
        SubmissionStatus.gradingFailed => StatusStamp(
          label: l10n.statusGradingFailed,
          tone: StatusTone.negative,
          icon: Icons.error_outline,
        ),
        SubmissionStatus.inProgress => StatusStamp(
          label: l10n.statusInProgress,
          icon: Icons.timer_outlined,
        ),
      };

  static String _figure(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1).replaceAll('.', ',');
}
