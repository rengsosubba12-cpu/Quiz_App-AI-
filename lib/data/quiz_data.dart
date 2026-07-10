import '../models/question.dart';

/// Mock quiz data — replace with a real API or local database later.
const List<Question> kQuizQuestions = [
  Question(
    questionText: 'What is the main building block of a Flutter UI?',
    options: ['Widget', 'Element', 'RenderObject', 'State'],
    correctAnswerIndex: 0,
    category: 'Flutter Basics',
    difficulty: 'Easy',
  ),
  Question(
    questionText: 'Which widget is used to lay out children in a horizontal line?',
    options: ['Column', 'Stack', 'Row', 'Wrap'],
    correctAnswerIndex: 2,
    category: 'Flutter Basics',
    difficulty: 'Easy',
  ),
  Question(
    questionText:
        'Which keyword in Dart is used to declare a variable whose value cannot be reassigned?',
    options: ['var', 'final', 'static', 'const'],
    correctAnswerIndex: 1,
    category: 'Dart Logic',
    difficulty: 'Easy',
  ),
  Question(
    questionText: 'What does the `async` keyword do in Dart?',
    options: [
      'Runs code on a separate thread',
      'Marks a function that returns a Future',
      'Suspends the entire app',
      'Makes a variable asynchronous',
    ],
    correctAnswerIndex: 1,
    category: 'Dart Logic',
    difficulty: 'Medium',
  ),
  Question(
    questionText:
        'Which Flutter widget provides a scrollable list of fixed-extent items?',
    options: ['ListView', 'GridView', 'ListWheelScrollView', 'CustomScrollView'],
    correctAnswerIndex: 2,
    category: 'Widgets',
    difficulty: 'Medium',
  ),
  Question(
    questionText: 'What is the purpose of the `BuildContext` in Flutter?',
    options: [
      'Stores the widget\'s state data',
      'Provides the location of a widget in the widget tree',
      'Handles platform-specific rendering',
      'Manages async streams',
    ],
    correctAnswerIndex: 1,
    category: 'Flutter Basics',
    difficulty: 'Medium',
  ),
  Question(
    questionText:
        'Which state management approach uses a `ChangeNotifier` and `Provider`?',
    options: ['Bloc', 'Riverpod', 'Provider', 'Redux'],
    correctAnswerIndex: 2,
    category: 'State Mgmt',
    difficulty: 'Medium',
  ),
  Question(
    questionText:
        'What is the difference between `StatelessWidget` and `StatefulWidget`?',
    options: [
      'StatelessWidget can rebuild; StatefulWidget cannot',
      'StatefulWidget has mutable state; StatelessWidget does not',
      'They are identical in functionality',
      'StatelessWidget supports animations; StatefulWidget does not',
    ],
    correctAnswerIndex: 1,
    category: 'Flutter Basics',
    difficulty: 'Easy',
  ),
  Question(
    questionText:
        'Which Dart feature allows a function to yield values lazily over time?',
    options: ['async/await', 'Future', 'Stream', 'Generator'],
    correctAnswerIndex: 2,
    category: 'Dart Logic',
    difficulty: 'Hard',
  ),
  Question(
    questionText:
        'In Flutter, what does `MediaQuery.of(context).size` return?',
    options: [
      'The widget\'s intrinsic size',
      'The screen\'s logical pixel dimensions',
      'The device\'s physical pixel count',
      'The safe area insets',
    ],
    correctAnswerIndex: 1,
    category: 'Flutter Basics',
    difficulty: 'Medium',
  ),
];
