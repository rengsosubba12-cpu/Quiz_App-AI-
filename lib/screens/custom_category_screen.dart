import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/question.dart';
import '../screens/quiz_screen.dart';
import '../widgets/shared_widgets.dart';

/// Custom Category screen — dramatic Sahara typographic design.
class CustomCategoryScreen extends StatefulWidget {
  const CustomCategoryScreen({super.key});

  @override
  State<CustomCategoryScreen> createState() => _CustomCategoryScreenState();
}

class _CustomCategoryScreenState extends State<CustomCategoryScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _isLoading = false;

  // Note: In a real app, store this key in a .env file or secure storage
  // For this example, we'll use a placeholder. The user should replace this.
  static const String _apiKey = 'AQ.Ab8RN6JWXms5ak5H_lw4PgNs_2t36XU7d9q5Y2DzmAo2y6Mkkg';

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generateQuiz(String topic) async {
    if (topic.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a topic first!')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
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

      // Clean up the response text in case there are any leading/trailing characters
      final cleanedText = responseText.trim();
      final jsonData = jsonDecode(cleanedText) as List<dynamic>;

      final List<Question> questions = jsonData.map((item) {
        final map = item as Map<String, dynamic>;
        return Question(
          questionText: map['questionText'] as String,
          options: List<String>.from(map['options'] as List),
          correctAnswerIndex: map['correctAnswerIndex'] as int,
          category: topic,
          difficulty: 'Medium',
        );
      }).toList();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              category: topic,
              questions: questions,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate quiz: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A0E08) : const Color(0xFF2C1A0E),
      body: Stack(
        children: [
          // Dramatic desert background blobs
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFC2652A).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8C3C3C).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const AppBarAvatar(),
                    ],
                  ),
                ),

                // Dramatic headline area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 48, 28, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: const Color(0xFFC2652A)
                                    .withValues(alpha: 0.6)),
                            color:
                                const Color(0xFFC2652A).withValues(alpha: 0.12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome,
                                  size: 14, color: Color(0xFFF0A878)),
                              const SizedBox(width: 6),
                              Text(
                                'AI POWERED',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFFF0A878),
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Dramatic serif headline
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Custom\n',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.0,
                                  letterSpacing: -2,
                                ),
                              ),
                              TextSpan(
                                text: 'Category',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFFF0A878),
                                  height: 1.1,
                                  letterSpacing: -2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Type any topic and let the Sahara AI craft a quiz specifically for you.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white60,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Divider line
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFC2652A).withValues(alpha: 0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Input field
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFC2652A)
                                  .withValues(alpha: 0.4),
                            ),
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          child: TextField(
                            controller: _topicController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            cursorColor: const Color(0xFFF0A878),
                            decoration: const InputDecoration(
                              hintText: 'e.g. Ancient Rome, Quantum Physics...',
                              hintStyle: TextStyle(
                                  color: Colors.white38, fontSize: 16),
                              prefixIcon:
                                  Icon(Icons.search, color: Color(0xFFF0A878)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Get Quiz button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _generateQuiz(_topicController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC2652A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: const Color(0xFFC2652A)
                                  .withValues(alpha: 0.5),
                            ),
                            child: _isLoading
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'GENERATING...',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'GET QUIZ',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 3,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.arrow_forward_rounded,
                                          size: 20),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Info note
                        Center(
                          child: Text(
                            '✦  Questions are generated fresh for each session  ✦',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white30,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
