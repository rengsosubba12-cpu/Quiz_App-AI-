import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/shared_widgets.dart';

/// User Profile screen — "Sun-Baked Simplicity"
///
/// Sahara design system implementation.
/// Features profile picture tap → Avatar Selection,
/// Favourite Categories from history, and animated UI.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lightningController;

  @override
  void initState() {
    super.initState();
    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _lightningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final history = appState.quizHistory;
    final categories = appState.playedCategories.toList();
    final avatarIndex = appState.selectedAvatarIndex;

    // Calculate stats
    final totalQuizzes = history.length;
    final totalCorrect = history.fold<int>(0, (s, r) => s + r.correct);
    final totalQuestions = history.fold<int>(0, (s, r) => s + r.total);
    final accuracy = totalQuestions == 0
        ? 0
        : ((totalCorrect / totalQuestions) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFfaf5ee), // Sahara background
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top App Bar
              SliverAppBar(
                backgroundColor: const Color(0xFFfaf5ee),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                title: const Text(
                  'Smart Quiz',
                  style: TextStyle(
                    fontFamily: 'EB Garamond',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFc2652a),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'My Profile',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                const Color(0xFF3a302a).withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/avatar'),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFe6e0d6),
                              border: Border.all(
                                color: const Color(0xFFd8d0c8)
                                    .withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                kAvatarUrls[avatarIndex.clamp(
                                    0, kAvatarUrls.length - 1)],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: Color(0xFFf0a878),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 32),

                    // Profile Header Section
                    _ProfileHeader(
                      avatarIndex: avatarIndex,
                      totalQuizzes: totalQuizzes,
                      accuracy: accuracy,
                    ),

                    const SizedBox(height: 48),

                    // Bento Grid
                    _BentoGrid(
                      accuracy: accuracy,
                    ),

                    const SizedBox(height: 48),

                    // Favourite Categories
                    _FavouriteCategoriesSection(
                      categories: categories,
                    ),

                    const SizedBox(height: 48),

                    // Aesthetic Decoration (warrior image)
                    _AestheticDecoration(
                      lightningController: _lightningController,
                    ),

                    const SizedBox(height: 120), // Space for bottom nav
                  ]),
                ),
              ),
            ],
          ),

          // Bottom Navigation Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNav(
              activeTab: NavTab.profile,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final int avatarIndex;
  final int totalQuizzes;
  final int accuracy;

  const _ProfileHeader({
    required this.avatarIndex,
    required this.totalQuizzes,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/avatar'),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(58, 48, 42, 0.04),
                      blurRadius: 16,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: Image.asset(
                    kAvatarUrls[avatarIndex.clamp(0, kAvatarUrls.length - 1)],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFe6e0d6),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFf0a878),
                        size: 60,
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .rotate(
                    begin: 0.05,
                    end: 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(delay: 100.ms),
            ),
            const SizedBox(width: 32),

            // Text Info & Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sahara Scholar',
                    style: TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3a302a),
                      height: 1.1,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic),

                  const SizedBox(height: 8),

                  const Text(
                    'Enthusiastic quizzer & history buff. Mastering the art of trivial knowledge since 2021.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: Color(0xFF605850),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic),

                  const SizedBox(height: 24),

                  // Stats Cards
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MiniStatCard(
                        value: '$totalQuizzes',
                        label: 'Quizzes',
                        color: const Color(0xFFc2652a),
                      ),
                      const SizedBox(width: 16),
                      _MiniStatCard(
                        value: '$accuracy%',
                        label: 'Accuracy',
                        color: const Color(0xFF8c3c3c),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MiniStatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFd8d0c8).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 10,
              letterSpacing: 2,
              color: Color(0xFF605850),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoGrid extends StatelessWidget {
  final int accuracy;

  const _BentoGrid({
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accuracy Progress Card
            Expanded(
              child: _AccuracyCard(accuracy: accuracy),
            ),
            const SizedBox(width: 24),
            // Badges Card
            Expanded(
              child: _BadgesCard(),
            ),
          ],
        ),
      ],
    );
  }
}

class _AccuracyCard extends StatelessWidget {
  final int accuracy;

  const _AccuracyCard({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFf6f0e8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFd8d0c8).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Accuracy',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3a302a),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your average score across all completed quizzes.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Color(0xFF605850),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$accuracy',
                    style: const TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3a302a),
                    ),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(
                      fontFamily: 'EB Garamond',
                      fontSize: 24,
                      color: Color(0xFF3a302a),
                    ),
                  ),
                ],
              ),
              Text(
                'Top 5% of Quizzers',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                  letterSpacing: 2,
                  color: const Color(0xFF605850).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: accuracy / 100),
            duration: const Duration(seconds: 1, milliseconds: 500),
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: const Color(0xFFe6e0d6),
                ),
                child: FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFFc2652a),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(
        begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }
}

class _BadgesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final history = appState.quizHistory;

    final hasSilver = history.any((r) => r.badge == 'assets/images/silver.png');
    final hasGold = history.any((r) => r.badge == 'assets/images/gold.png');
    final hasPlatinum = history.any((r) => r.badge == 'assets/images/platinum.png');

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFd8d0c8).withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(58, 48, 42, 0.04),
            blurRadius: 16,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unlocked Badges',
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3a302a),
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _BadgeItem(
                  imagePath: 'assets/images/silver.png',
                  label: 'Silver',
                  delay: 0,
                  isUnlocked: hasSilver,
                ),
                const SizedBox(width: 24),
                _BadgeItem(
                  imagePath: 'assets/images/gold.png',
                  label: 'Gold',
                  delay: 200,
                  isUnlocked: hasGold,
                ),
                const SizedBox(width: 24),
                _BadgeItem(
                  imagePath: 'assets/images/platinum.png',
                  label: 'Platinum',
                  delay: 400,
                  isUnlocked: hasPlatinum,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(
        begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }
}

class _BadgeItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final int delay;
  final bool isUnlocked;

  const _BadgeItem({
    required this.imagePath,
    required this.label,
    required this.delay,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final durations = [4000, 3000, 2500];
    final index = delay ~/ 200;
    final duration =
        Duration(milliseconds: durations[index.clamp(0, durations.length - 1)]);

    final Widget imageWidget = Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.emoji_events,
        color: Color(0xFFf0a878),
        size: 48,
      ),
    );

    final styledImage = isUnlocked
        ? imageWidget
        : ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0,      0,      0,      1, 0,
            ]),
            child: Opacity(
              opacity: 0.35,
              child: imageWidget,
            ),
          );

    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isUnlocked
                  ? (label == 'Gold'
                      ? const Color(0xFFc2652a)
                      : label == 'Platinum'
                          ? const Color(0xFF8c3c3c)
                          : const Color(0xFF5a4a42))
                  : const Color(0xFFd8d0c8).withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(58, 48, 42, 0.04),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipOval(
            child: styledImage,
          ),
        )
            .animate(
              onPlay: (c) => c.repeat(reverse: true),
              delay: (delay + 700).ms,
            )
            .moveY(
              begin: 0,
              end: -8,
              duration: duration,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            letterSpacing: 2,
            color: isUnlocked
                ? const Color(0xFF605850)
                : const Color(0xFF605850).withValues(alpha: 0.4),
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _FavouriteCategoriesSection extends StatelessWidget {
  final List<String> categories;

  const _FavouriteCategoriesSection({
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favourite Categories',
          style: TextStyle(
            fontFamily: 'EB Garamond',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3a302a),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            if (categories.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color(0xFFd8d0c8).withValues(alpha: 0.3),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.category,
                      color: Color(0xFF605850),
                      size: 36,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Play quizzes to unlock your favourite categories',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        color: Color(0xFF605850),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...categories.map((cat) => _CategoryTag(label: cat)),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 700.ms).slideY(
        begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
  }
}

class _CategoryTag extends StatelessWidget {
  final String label;

  const _CategoryTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFFd8d0c8).withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(58, 48, 42, 0.04),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.category,
            color: Color(0xFFc2652a),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3a302a),
            ),
          ),
        ],
      ),
    );
  }
}

class _AestheticDecoration extends StatelessWidget {
  final AnimationController lightningController;

  const _AestheticDecoration({
    required this.lightningController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: lightningController,
      builder: (context, child) {
        final value = lightningController.value;
        final isFlash = value > 0.95 || (value > 0.60 && value < 0.62);
        final brightness = isFlash ? 1.4 : 1.0;

        return ColorFiltered(
          colorFilter: ColorFilter.matrix([
            brightness,
            0,
            0,
            0,
            0,
            0,
            brightness,
            0,
            0,
            0,
            0,
            0,
            brightness,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: Container(
            width: double.infinity,
            height: 256,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/screen.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFFfaf5ee),
                        const Color(0xFFfaf5ee).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
        );
      },
    );
  }
}
