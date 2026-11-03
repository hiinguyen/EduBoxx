import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        ChatRole,
        TutorChatDetail,
        TutorChatSummary,
        TutorErrorCode,
        TutorMessage,
        TutorEventType,
        TutorState,
        TutorSubject;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../app/loadable.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';

abstract final class StudentTutorKeys {
  static const screen = Key('screen.studentTutor');
  static const composer = Key('studentTutor.composer');
  static const send = Key('studentTutor.send');
  static const subject = Key('studentTutor.subject');
}

class StudentTutorScreen extends StatefulWidget {
  const StudentTutorScreen({super.key});

  @override
  State<StudentTutorScreen> createState() => _StudentTutorScreenState();
}

class _StudentTutorScreenState extends State<StudentTutorScreen> {
  Loadable<TutorState>? _state;
  Loadable<List<TutorChatSummary>>? _chats;
  late AppScope _scope;
  final _message = TextEditingController();
  final _scroll = ScrollController();
  TutorSubject? _subject;
  TutorChatDetail? _chat;
  int? _chatId;
  bool _streaming = false;
  String _draftReply = '';
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = AppScope.of(context);
    if (_state == null) {
      _state = Loadable(_scope.services.backend.tutor.state)
        ..addListener(_onState);
      _chats = Loadable(_scope.services.backend.tutor.chats)
        ..addListener(_onState);
      _scope.connectivity
        ..register(_reload)
        ..register(_chats!.load);
      unawaited(_reload());
    }
  }

  Future<void> _reload() async {
    await _state!.load();
    await _chats!.load();
    if (!mounted) return;
    final subjects = _state!.value?.subjects ?? const <TutorSubject>[];
    setState(() {
      _subject = subjects.isEmpty
          ? null
          : subjects.firstWhere(
              (item) => item.subject == _subject?.subject,
              orElse: () => subjects.first,
            );
    });
  }

  void _onState() {
    if (_state!.error is SessionExpiredError) {
      unawaited(_scope.session.expire());
    }
  }

  @override
  void dispose() {
    _scope.connectivity
      ..unregister(_reload)
      ..unregister(_chats!.load);
    _state!
      ..removeListener(_onState)
      ..dispose();
    _chats!
      ..removeListener(_onState)
      ..dispose();
    _message.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _newChat() {
    setState(() {
      _chat = null;
      _chatId = null;
      _draftReply = '';
      _error = null;
    });
  }

  Future<void> _openChat(TutorChatSummary summary) async {
    final l10n = AppLocalizations.of(context);
    final result = await _scope.services.backend.tutor.chat(summary.id);
    if (!mounted) return;
    if (result.isOk) {
      setState(() {
        _chat = result.valueOrNull;
        _chatId = summary.id;
        _draftReply = '';
        _error = null;
      });
    } else {
      setState(() => _error = l10n.tutorChatError);
    }
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final text = _message.text.trim();
    final state = _state!.value;
    if (text.isEmpty || _subject == null || state == null) {
      setState(() => _error = l10n.tutorEmptySubject);
      return;
    }
    if (!_scope.connectivity.isOnline) {
      return;
    }
    if (state.pausedForTest) return;
    if (state.remainingToday <= 0) return;
    final chatId = _chatId;
    final existing = _chat;
    final userMessage = text;
    _message.clear();
    setState(() {
      _streaming = true;
      _draftReply = '';
      _error = null;
      _chat = TutorChatDetail(
        id: chatId ?? -1,
        subject: _subject!.subject,
        title: userMessage,
        createdAt: _scope.services.clock().toUtc(),
        updatedAt: _scope.services.clock().toUtc(),
        messages: [
          for (final message in existing?.messages ?? const []) message,
          TutorMessage(
            id: -1,
            role: ChatRole.student,
            content: userMessage,
            createdAt: _scope.services.clock().toUtc(),
          ),
        ],
      );
    });
    try {
      await for (final event in _scope.services.backend.tutor.ask(
        subject: _subject!.subject,
        message: userMessage,
        chatId: chatId,
      )) {
        if (!mounted) return;
        switch (event.type) {
          case TutorEventType.delta:
            setState(() {
              _draftReply += event.delta ?? '';
              _chatId ??= event.chatId;
            });
          case TutorEventType.done:
            setState(() {
              _streaming = false;
              _chatId = event.chatId ?? _chatId;
            });
            await _refreshChat();
          case TutorEventType.error:
            setState(() {
              _streaming = false;
              _error = _errorFor(l10n, event.errorCode);
            });
        }
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _streaming = false;
        _error =
            error is BackendException && error.error is BackendUnreachableError
            ? l10n.tutorNeedsInternet
            : l10n.tutorError;
      });
    }
    if (mounted) {
      unawaited(_chats!.load());
      unawaited(_state!.load());
    }
  }

  Future<void> _refreshChat() async {
    final id = _chatId;
    if (id == null || id < 0) return;
    final result = await _scope.services.backend.tutor.chat(id);
    if (!mounted) return;
    if (result.isOk) {
      setState(() {
        _chat = result.valueOrNull;
        _draftReply = '';
      });
    }
  }

  String _errorFor(AppLocalizations l10n, TutorErrorCode? code) =>
      switch (code) {
        TutorErrorCode.dailyLimitReached => l10n.tutorDailyLimit,
        TutorErrorCode.subjectNotAllowed => l10n.tutorSubjectNotAllowed,
        TutorErrorCode.lockedDuringTest => l10n.tutorPaused,
        TutorErrorCode.emptyMessage => l10n.tutorEmptySubject,
        TutorErrorCode.noClass => l10n.tutorLoadError,
        TutorErrorCode.providerUnavailable => l10n.tutorError,
        null => l10n.tutorError,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = _state!.value;
    final chats = _chats!.value ?? const <TutorChatSummary>[];
    final disabled =
        _streaming ||
        !_scope.connectivity.isOnline ||
        state == null ||
        state.pausedForTest ||
        state.remainingToday <= 0;
    return ListenableBuilder(
      listenable: Listenable.merge([_state!, _chats!, _scope.connectivity]),
      builder: (context, _) => LearningPage(
        key: StudentTutorKeys.screen,
        title: l10n.tutorTitle,
        action: TextButton.icon(
          onPressed: _newChat,
          icon: const Icon(Icons.add_comment_outlined),
          label: Text(l10n.tutorNewChat),
        ),
        children: [
          if (state == null && _state!.error == null)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (state == null)
            BlockMessage(
              tone: _state!.error is OfflineNoCacheError
                  ? BlockTone.offline
                  : BlockTone.error,
              message: _state!.error is OfflineNoCacheError
                  ? l10n.tutorOfflineNoData
                  : l10n.tutorLoadError,
              action: _state!.error is OfflineNoCacheError
                  ? null
                  : RetryButton(onPressed: () => unawaited(_reload())),
            )
          else ...[
            LearningPanel(
              title: l10n.tutorSubject,
              child: DropdownButtonFormField<TutorSubject>(
                key: StudentTutorKeys.subject,
                initialValue: _subject,
                items: [
                  for (final subject in state.subjects)
                    DropdownMenuItem(
                      value: subject,
                      child: Text(
                        l10n.exerciseRowMeta(
                          subject.subject,
                          subject.className,
                        ),
                      ),
                    ),
                ],
                onChanged: _streaming
                    ? null
                    : (value) => setState(() => _subject = value),
              ),
            ),
            if (_chats!.value != null && chats.isNotEmpty) ...[
              const SizedBox(height: EduSpace.s16),
              LearningPanel(
                title: l10n.tutorConversations,
                child: Column(
                  children: [
                    for (final chat in chats.take(5))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(chat.title),
                        subtitle: Text(
                          l10n.chatRowMeta(
                            chat.subject,
                            learningDate(chat.updatedAt),
                          ),
                        ),
                        onTap: () => unawaited(_openChat(chat)),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: EduSpace.s16),
            LearningPanel(
              title: _chat?.subject ?? l10n.tutorTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final message in _chat?.messages ?? const [])
                    _MessageBubble(
                      role: message.role,
                      content: message.content,
                    ),
                  if (_draftReply.isNotEmpty)
                    _MessageBubble(
                      role: ChatRole.tutor,
                      content: _draftReply,
                      streaming: _streaming,
                    ),
                  if (_streaming && _draftReply.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: EduSpace.s8,
                      ),
                      child: Text(
                        l10n.tutorThinking,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: EduPalette.of(context).muted,
                        ),
                      ),
                    ),
                  if (state.pausedForTest)
                    BlockMessage(
                      tone: BlockTone.plain,
                      message: l10n.tutorPaused,
                      hint: l10n.tutorPausedHint,
                    )
                  else if (state.remainingToday <= 0)
                    BlockMessage(
                      tone: BlockTone.plain,
                      message: l10n.tutorDailyLimit,
                      hint: l10n.tutorDailyLimitHint,
                    )
                  else if (!_scope.connectivity.isOnline)
                    BlockMessage(
                      tone: BlockTone.offline,
                      message: l10n.tutorNeedsInternet,
                    ),
                  if (_error != null) ...[
                    const SizedBox(height: EduSpace.s8),
                    BlockMessage(
                      tone: BlockTone.error,
                      message: _error!,
                      action: TextButton(
                        onPressed: _streaming ? null : () => unawaited(_send()),
                        child: Text(l10n.retry),
                      ),
                    ),
                  ],
                  const SizedBox(height: EduSpace.s16),
                  TextField(
                    key: StudentTutorKeys.composer,
                    controller: _message,
                    minLines: 1,
                    maxLines: 4,
                    enabled: !disabled,
                    decoration: InputDecoration(
                      hintText: l10n.tutorMessageHint,
                    ),
                  ),
                  const SizedBox(height: EduSpace.s8),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FilledButton(
                      key: StudentTutorKeys.send,
                      onPressed: disabled ? null : () => unawaited(_send()),
                      child: _streaming
                          ? BusyLabel(label: l10n.tutorThinking)
                          : Text(l10n.tutorSend),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.role,
    required this.content,
    this.streaming = false,
  });

  final ChatRole role;
  final String content;
  final bool streaming;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isStudent = role == ChatRole.student;
    final palette = EduPalette.of(context);
    return Align(
      alignment: isStudent
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        margin: const EdgeInsets.only(bottom: EduSpace.s8),
        padding: const EdgeInsets.all(EduSpace.s12),
        decoration: BoxDecoration(
          color: isStudent ? palette.active : palette.sheet,
          border: Border.all(color: palette.rule),
          borderRadius: BorderRadius.circular(EduRadius.control),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isStudent ? l10n.tutorStudentLabel : l10n.tutorTutorLabel,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: palette.muted,
              ),
            ),
            const SizedBox(height: 4),
            Text(content),
            if (streaming)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.tutorThinking,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: palette.muted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
