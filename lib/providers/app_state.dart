import 'package:flutter/material.dart';
import '../models/quiz_record.dart';
import '../widgets/shared_widgets.dart';

/// Global application state, exposed via Provider.
///
/// Manages:
/// - [themeMode] — Light vs Dark MaterialApp theme
/// - [isMusicOn] — Music/ambient sound toggle
/// - [selectedAvatarIndex] — Which of the 6 anime avatars the user selected
/// - [quizHistory] — List of completed quiz sessions, written to on results
class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isMusicOn = true;
  int _selectedAvatarIndex = 0.clamp(0, kAvatarUrls.length - 1);
  final List<QuizRecord> _quizHistory = [];

  // ── Getters ────────────────────────────────────────────────────────────────

  ThemeMode get themeMode => _themeMode;
  bool get isMusicOn => _isMusicOn;
  int get selectedAvatarIndex => _selectedAvatarIndex;
  List<QuizRecord> get quizHistory => List.unmodifiable(_quizHistory);

  /// Unique categories the user has ever played (derived from history).
  Set<String> get playedCategories =>
      _quizHistory.map((r) => r.category).toSet();

  // ── Mutators ───────────────────────────────────────────────────────────────

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleMusic() {
    _isMusicOn = !_isMusicOn;
    notifyListeners();
  }

  void setAvatar(int index) {
    _selectedAvatarIndex = index.clamp(0, kAvatarUrls.length - 1);
    notifyListeners();
  }

  void addQuizRecord(QuizRecord record) {
    _quizHistory.insert(0, record); // newest first
    notifyListeners();
  }
}
