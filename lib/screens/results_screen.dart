import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../models/quiz_record.dart';
import '../providers/app_state.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _hasSaved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasSaved) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final correct = args?['correct'] as int? ?? 0;
      final total = args?['total'] as int? ?? 1;
      final category = args?['category'] as String? ?? 'Flutter Basics';
      final percentage = total == 0 ? 0 : ((correct / total) * 100).round();

      final String badgePath;
      if (percentage <= 30) {
        badgePath = 'assets/images/silver.png';
      } else if (percentage <= 60) {
        badgePath = 'assets/images/gold.png';
      } else {
        badgePath = 'assets/images/platinum.png';
      }

      // Save to AppState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppState>().addQuizRecord(
              QuizRecord(
                category: category,
                correct: correct,
                total: total,
                completedAt: DateTime.now(),
                badge: badgePath,
              ),
            );
      });
      _hasSaved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final correct = args?['correct'] as int? ?? 0;
    final total = args?['total'] as int? ?? 1;
    final category = args?['category'] as String? ?? 'Flutter Basics';
    final percentage = total == 0 ? 0 : ((correct / total) * 100).round();

    String achievementTitle;
    String achievementDesc;
    String badgePath;
    Color medalColor;

    if (percentage <= 30) {
      achievementTitle = 'Silver Explorer';
      achievementDesc = 'Good try, but keep practicing!';
      badgePath = 'assets/images/silver.png';
      medalColor = const Color(0xFFC0C0C0); // Silver
    } else if (percentage <= 60) {
      achievementTitle = 'Gold Achiever';
      achievementDesc = 'Great job, you are getting better!';
      badgePath = 'assets/images/gold.png';
      medalColor = const Color(0xFFFFD700); // Gold
    } else {
      achievementTitle = 'Platinum Scholar';
      achievementDesc = 'Excellent work! Perfect or near perfect!';
      badgePath = 'assets/images/platinum.png';
      medalColor = const Color(0xFFE5E4E2); // Platinum
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Background blobs
          Positioned.fill(
            child: Container(color: theme.colorScheme.surface),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.primaryContainer.withValues(alpha: 0.3), Colors.transparent],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.tertiary.withValues(alpha: 0.15), Colors.transparent],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),

          // Top App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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
                    icon: const Icon(Icons.close),
                    color: theme.colorScheme.onSurfaceVariant,
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                  ),
                  Text(
                    'Results',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 48), // Balance for close button
                ],
              ),
            ),
          ),

          // Main Content
          Positioned.fill(
            top: 64 + MediaQuery.of(context).padding.top,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                // Achievement Badge
                SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            'ACHIEVEMENT UNLOCKED',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Badge Image (highly detailed anime style badge from Stitch design)
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: medalColor.withValues(alpha: 0.4),
                                blurRadius: 32,
                                spreadRadius: 8,
                              )
                            ],
                            border: Border.all(color: medalColor.withValues(alpha: 0.5), width: 4),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              badgePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.emoji_events, size: 80, color: medalColor),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          achievementTitle,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          achievementDesc,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                // Stats Bento Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'PERFORMANCE SUMMARY',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem(
                                title: 'SCORE',
                                value: '$percentage%',
                                color: theme.colorScheme.primary,
                              ),
                              Container(width: 1, height: 40, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                              _StatItem(
                                title: 'CORRECT',
                                value: '$correct/$total',
                                color: const Color(0xFF16A34A),
                              ),
                              Container(width: 1, height: 40, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                              _StatItem(
                                title: 'TIME',
                                value: '02:45', // Mock time
                                color: theme.colorScheme.tertiary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
                // Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async {
                              if (category == 'Flutter Basics' || category == 'Dart Logic') {
                                Navigator.pushNamed(context, '/quiz', arguments: {'category': category});
                              } else {
                                // Custom Category - trigger dynamic generation cycle
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16),
                                            Text('Generating fresh quiz questions...'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                try {
                                  final questions = await _generateQuestionsForTopic(category);
                                  if (context.mounted) {
                                    Navigator.pop(context); // Dismiss dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizScreen(
                                          category: category,
                                          questions: questions,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(context); // Dismiss dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to generate quiz: $e')),
                                    );
                                  }
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Restart Quiz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
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

  Future<List<Question>> _generateQuestionsForTopic(String topic) async {
    const String apiKey = 'AQ.Ab8RN6JWXms5ak5H_lw4PgNs_2t36XU7d9q5Y2DzmAo2y6Mkkg';
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
You are a quiz generator. Generate exactly 10 multiple-choice questions about the topic: '$topic'. You MUST return the response ONLY as a raw JSON array of objects. Do not include markdown formatting, backticks, or intro/outro text. Each object must have this exact structure:
{
  "questionText": "The question here?",
  "options": ["Option A", "Option B", "Option C", "Option D"],
  "correctAnswerIndex": 2
}
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final responseText = response.text;

    if (responseText == null) {
      throw Exception('No response from AI');
    }

    final cleanedText = responseText.trim();
    final jsonData = jsonDecode(cleanedText) as List<dynamic>;

    return jsonData.map((item) {
      final map = item as Map<String, dynamic>;
      return Question(
        questionText: map['questionText'] as String,
        options: List<String>.from(map['options'] as List),
        correctAnswerIndex: map['correctAnswerIndex'] as int,
        category: topic,
        difficulty: 'Medium',
      );
    }).toList();
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatItem({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(title, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
