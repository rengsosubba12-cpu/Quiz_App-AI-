/// Data model for a completed quiz session.
class QuizRecord {
  final String category;
  final int correct;
  final int total;
  final DateTime completedAt;
  final String badge;

  const QuizRecord({
    required this.category,
    required this.correct,
    required this.total,
    required this.completedAt,
    required this.badge,
  });

  int get percentage => total == 0 ? 0 : ((correct / total) * 100).round();
}
