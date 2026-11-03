import 'dart:convert';

/// One question's grading facts. The answer key never leaves the server.
class GradeQuestion {
  const GradeQuestion({
    required this.questionId,
    required this.multiSelect,
    required this.correctPositions,
  });

  final int questionId;
  final bool multiSelect;
  final Set<int> correctPositions;
}

/// The result of grading one answer sheet against one key snapshot.
class GradeResult {
  const GradeResult({
    required this.score,
    required this.maxScore,
    required this.correctCount,
    required this.questionCount,
  });

  final double score;
  final double maxScore;
  final int correctCount;
  final int questionCount;
}

/// Auto-grading for objective (single- or multi-select) questions. A
/// multi-select answer is correct only when the selected set equals the key;
/// unanswered and extra selections are wrong. Scores use the Vietnamese
/// 10-point scale.
abstract final class AutoGrader {
  static const double maxScore = 10;

  static GradeResult grade({
    required List<GradeQuestion> questions,
    required Map<int, List<int>> answers,
  }) {
    if (questions.isEmpty) {
      return const GradeResult(
        score: 0,
        maxScore: maxScore,
        correctCount: 0,
        questionCount: 0,
      );
    }
    var correct = 0;
    for (final question in questions) {
      final selected = (answers[question.questionId] ?? const <int>[]).toSet();
      if (selected.isNotEmpty &&
          selected.length == question.correctPositions.length &&
          selected.containsAll(question.correctPositions)) {
        correct++;
      }
    }
    final score = (correct / questions.length * maxScore * 10).round() / 10;
    return GradeResult(
      score: score,
      maxScore: maxScore,
      correctCount: correct,
      questionCount: questions.length,
    );
  }

  /// Serializes the key in the form stored on a submission at start/submit.
  static String snapshot(List<GradeQuestion> questions) => jsonEncode({
    'questions': {
      for (final question in questions)
        '${question.questionId}': question.correctPositions.toList()..sort(),
    },
  });

  /// Reads a key snapshot. Returns null when it is malformed or empty.
  static List<GradeQuestion>? readSnapshot(
    String? json,
    Map<int, bool> multiSelect,
  ) {
    if (json == null || json.isEmpty) return null;
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, Object?>) return null;
      final questions = decoded['questions'];
      if (questions is! Map<String, Object?>) return null;
      final result = <GradeQuestion>[];
      for (final entry in questions.entries) {
        final id = int.tryParse(entry.key);
        final positions = entry.value;
        if (id == null || positions is! List) return null;
        result.add(
          GradeQuestion(
            questionId: id,
            multiSelect: multiSelect[id] ?? false,
            correctPositions: {
              for (final value in positions)
                if (value is int) value,
            },
          ),
        );
      }
      return result.isEmpty ? null : result;
    } on FormatException {
      return null;
    }
  }

  /// Encodes a submission's answers as questionId -> positions.
  static String encodeAnswers(Map<int, List<int>> answers) => jsonEncode({
    for (final entry in answers.entries) '${entry.key}': entry.value..sort(),
  });

  /// Decodes stored answers; malformed data grades as unanswered.
  static Map<int, List<int>> decodeAnswers(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, Object?>) return {};
      return {
        for (final entry in decoded.entries)
          if (int.tryParse(entry.key) case final id?)
            if (entry.value is List)
              id: [
                for (final value in entry.value! as List)
                  if (value is int) value,
              ],
      };
    } on FormatException {
      return {};
    }
  }
}
