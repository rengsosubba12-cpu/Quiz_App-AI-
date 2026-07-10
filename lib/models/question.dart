/// Represents a single quiz question with its answer options.
class Question {
  /// The full text of the question.
  final String questionText;

  /// List of possible answer strings (typically A–D).
  final List<String> options;

  /// Zero-based index of the correct answer in [options].
  final int correctAnswerIndex;

  /// Category label, e.g. "Flutter Basics", "Dart Logic".
  final String category;

  /// Difficulty label, e.g. "Easy", "Medium", "Hard".
  final String difficulty;

  const Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    this.difficulty = 'Medium',
  });

  /// Returns `true` if the given [selectedIndex] is the correct answer.
  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;

  /// Convenience getter for the correct answer string.
  String get correctAnswer => options[correctAnswerIndex];
}
