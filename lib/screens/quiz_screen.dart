import 'dart:async';
import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/question.dart';
import '../widgets/shared_widgets.dart';

enum _AnswerState { idle, selected, correct, incorrect }

class QuizScreen extends StatefulWidget {
  final String? category;
  final List<Question>? questions;

  const QuizScreen({super.key, this.category, this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  bool _initialized = false;
  String _category = 'Flutter Basics';

  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _correctCount = 0;

  static const int _timerSeconds = 15;
  int _secondsLeft = _timerSeconds;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      if (widget.questions != null && widget.questions!.isNotEmpty) {
        // Use provided questions (AI-generated)
        _questions = widget.questions!;
        _category = widget.category ?? 'Custom Topic';
      } else {
        // Use route arguments and predefined questions
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        _category = args?['category'] as String? ?? 'Flutter Basics';
        
        if (_category == 'Flutter Basics' || _category == 'Dart Logic') {
          _questions = kQuizQuestions.where((q) => q.category == _category).toList();
        } else {
          // Fallback mock questions
          _questions = [
            Question(
              questionText: 'What is the primary purpose of $_category?',
              options: [
                'To manage state and data flows',
                'To structure and render user interfaces',
                'To optimize database query performance',
                'To handle network requests asynchronously',
              ],
              correctAnswerIndex: 1,
              category: _category,
              difficulty: 'Medium',
            ),
            Question(
              questionText: 'Which tool is most commonly used with $_category?',
              options: [
                'Command Line Interface (CLI)',
                'Graphical User Interface (GUI)',
                'Integrated Development Environment (IDE)',
                'Software Development Kit (SDK)',
              ],
              correctAnswerIndex: 2,
              category: _category,
              difficulty: 'Easy',
            ),
            Question(
              questionText: 'What is a common best practice in $_category development?',
              options: [
                'Writing monolithic code without separation of concerns',
                'Avoiding code reviews and automated testing',
                'Modularizing code and keeping components reusable',
                'Using global variables for all state management',
              ],
              correctAnswerIndex: 2,
              category: _category,
              difficulty: 'Medium',
            ),
          ];
        }
      }
      
      _initialized = true;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _timerSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
        if (!_answered) _onTimeExpired();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onTimeExpired() {
    setState(() {
      _answered = true;
      _selectedIndex = null;
    });
  }

  void _onOptionTapped(int index) {
    if (_answered) return;
    _timer?.cancel();
    final isCorrect = _questions[_currentIndex].isCorrect(index);
    if (isCorrect) _correctCount++;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });
  }

  void _onNext() {
    if (_currentIndex >= _questions.length - 1) {
      Navigator.pushReplacementNamed(
        context,
        '/results',
        arguments: {
          'correct': _correctCount,
          'total': _questions.length,
          'category': _category,
        },
      );
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _answered = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _AnswerState _stateFor(int optionIndex) {
    if (!_answered) return _AnswerState.idle;
    final correctIndex = _questions[_currentIndex].correctAnswerIndex;
    if (optionIndex == correctIndex) return _AnswerState.correct;
    if (optionIndex == _selectedIndex) return _AnswerState.incorrect;
    return _AnswerState.idle;
  }

  String get _timerLabel {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Ambient decorative shapes (Artistic BG matching canvas)
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.primaryContainer.withValues(alpha: 0.15), Colors.transparent],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.1,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.0,
              height: MediaQuery.of(context).size.width * 1.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.tertiary.withValues(alpha: 0.1), Colors.transparent],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
          ),

          // Top App Bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 64 + MediaQuery.of(context).padding.top,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu), 
                    color: theme.colorScheme.onSurfaceVariant,
                    onPressed: () {},
                  ),
                  Text(
                    'Smart Quiz',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                  AppBarAvatar(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ],
              ),
            ),
          ),

          // Main Quiz Content
          Positioned.fill(
            top: 64 + MediaQuery.of(context).padding.top,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q.category.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary, letterSpacing: 2)),
                            const SizedBox(height: 4),
                            Text('Question ${_currentIndex + 1} of ${_questions.length}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.timer, size: 18, color: theme.colorScheme.tertiary),
                              const SizedBox(width: 8),
                              Text(_timerLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / _questions.length,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      q.questionText,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500, 
                        height: 1.2,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Full width items as per new design
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 4.0, // Adjust based on visual height
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return _AnswerOption(
                          label: String.fromCharCode(65 + i),
                          text: q.options[i],
                          state: _stateFor(i),
                          onTap: () => _onOptionTapped(i),
                        );
                      },
                      childCount: q.options.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _answered ? _onNext : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next Question'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          elevation: _answered ? 4 : 0,
                          shadowColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final _AnswerState state;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.text,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color borderColor;
    Color bgColor;
    Color textColor = theme.colorScheme.onSurface;
    Widget? icon;

    switch (state) {
      case _AnswerState.correct:
        borderColor = const Color(0xFF16A34A);
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF16A34A);
        icon = const Icon(Icons.check, color: Colors.white, size: 16);
        break;
      case _AnswerState.incorrect:
        borderColor = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFDC2626);
        icon = const Icon(Icons.close, color: Colors.white, size: 16);
        break;
      case _AnswerState.selected:
        borderColor = theme.colorScheme.primary;
        bgColor = theme.colorScheme.primary.withValues(alpha: 0.05);
        textColor = theme.colorScheme.primary;
        icon = Icon(Icons.check, color: theme.colorScheme.onPrimary, size: 16);
        break;
      case _AnswerState.idle:
        borderColor = Colors.transparent;
        bgColor = Colors.white.withValues(alpha: 0.7);
        icon = Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary));
        break;
    }

    return GestureDetector(
      onTap: state == _AnswerState.idle ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: state == _AnswerState.idle ? theme.colorScheme.outlineVariant.withValues(alpha: 0.4) : borderColor, 
            width: 1
          ),
          boxShadow: state == _AnswerState.idle 
            ? null 
            : [BoxShadow(color: borderColor.withValues(alpha: 0.1), blurRadius: 8, spreadRadius: 1)],
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (state == _AnswerState.correct) ? const Color(0xFF16A34A) : (state == _AnswerState.incorrect) ? const Color(0xFFDC2626) : (state == _AnswerState.selected) ? theme.colorScheme.primary : Colors.transparent,
                border: state == _AnswerState.idle ? Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3), width: 2) : null,
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(text, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: textColor)),
            )
          ],
        ),
      ),
    );
  }
}
