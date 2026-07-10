import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/shared_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _startQuiz(String category) {
    Navigator.pushNamed(context, '/quiz', arguments: {'category': category});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final history = appState.quizHistory;

    int highScore = 0;
    if (history.isNotEmpty) {
      highScore = history.map((r) => r.percentage).reduce((value, element) => value > element ? value : element);
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Abstract Background
          Positioned.fill(
            child: Container(color: theme.colorScheme.surface),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.primaryContainer.withValues(alpha: 0.6), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.tertiaryContainer.withValues(alpha: 0.6), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [theme.colorScheme.primary.withValues(alpha: 0.3), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ColorFilter.mode(theme.colorScheme.surface.withValues(alpha: 0.3), BlendMode.srcOver),
              child: Container(
                color: theme.colorScheme.surface.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Main Content
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top + 64)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello mate!!',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Ready to test your knowledge?',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Challenge yourself with curated questions designed to elevate your expertise.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // High Score Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'CURRENT HIGH SCORE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 2,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$highScore%',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.trending_up, size: 16, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Top 5% of learners',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              // Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Select a Category',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _CategoryCard(
                      title: 'Flutter Basics',
                      description: 'Master the core concepts of UI development, widgets, and state management fundamentals.',
                      questions: '20 Questions',
                      time: '15 Min',
                      icon: Icons.layers,
                      iconColor: theme.colorScheme.primary,
                      onTap: () => _startQuiz('Flutter Basics'),
                    ),
                    const SizedBox(height: 24),
                    _CategoryCard(
                      title: 'Dart Logic',
                      description: 'Deep dive into asynchronous programming, classes, mixins, and advanced language features.',
                      questions: '25 Questions',
                      time: '20 Min',
                      icon: Icons.code,
                      iconColor: theme.colorScheme.tertiary,
                      onTap: () => _startQuiz('Dart Logic'),
                    ),
                    const SizedBox(height: 24),
                    // Custom Category Card
                    _CategoryCard(
                      title: 'Custom Category',
                      description: 'Type any topic & get a quiz generated by AI',
                      questions: 'AI Generated',
                      time: 'Customizable',
                      icon: Icons.auto_awesome,
                      iconColor: theme.colorScheme.primary,
                      onTap: () => Navigator.pushNamed(context, '/custom-category'),
                    ),
                  ]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
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
                    icon: const Icon(Icons.menu),
                    color: theme.colorScheme.onSurfaceVariant,
                    onPressed: () => Navigator.pushNamed(context, '/featured-video'),
                  ),
                  Text(
                    'Smart Quiz',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  AppBarAvatar(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Nav Bar (Mobile)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(activeTab: NavTab.home),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String questions;
  final String time;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.description,
    required this.questions,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF5EE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(description, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.format_list_bulleted, size: 16, color: theme.colorScheme.secondary),
                const SizedBox(width: 4),
                Text(questions, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: theme.colorScheme.secondary),
                const SizedBox(width: 4),
                Text(time, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
