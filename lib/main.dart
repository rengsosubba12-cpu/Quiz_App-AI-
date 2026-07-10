import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'providers/audio_controller.dart';
import 'screens/avatar_screen.dart';
import 'screens/custom_category_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/featured_video_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => AudioController()),
      ],
      child: const _AudioBridge(),
    ),
  );
}

/// Sits between the [MultiProvider] and [SmartQuizApp].
/// Watches [AppState.isMusicOn] and drives [AudioController] accordingly.
/// Because it sits inside the provider tree it has access to both notifiers.
class _AudioBridge extends StatefulWidget {
  const _AudioBridge();

  @override
  State<_AudioBridge> createState() => _AudioBridgeState();
}

class _AudioBridgeState extends State<_AudioBridge> {
  @override
  void initState() {
    super.initState();
    // Sync audio state on the first frame, after the widget tree is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncAudio());
  }

  void _syncAudio() {
    if (!mounted) return;
    final isMusicOn = context.read<AppState>().isMusicOn;
    final audio = context.read<AudioController>();
    if (isMusicOn) {
      audio.play();
    } else {
      audio.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // React to every change in isMusicOn and sync audio accordingly.
    final isMusicOn = context.select<AppState, bool>((s) => s.isMusicOn);

    // Schedule the sync after the build phase to avoid setState-during-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final audio = context.read<AudioController>();
      if (isMusicOn) {
        audio.play();
      } else {
        audio.stop();
      }
    });

    return const SmartQuizApp();
  }
}

// ─── Main Application ─────────────────────────────────────────────────────────

class SmartQuizApp extends StatelessWidget {
  const SmartQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Manrope as the base body font, EB Garamond for headlines/displays
    final TextTheme baseTheme = GoogleFonts.manropeTextTheme();
    final TextTheme displayTheme = GoogleFonts.ebGaramondTextTheme();

    final TextTheme textTheme = baseTheme.copyWith(
      displayLarge: displayTheme.displayLarge,
      displayMedium: displayTheme.displayMedium,
      displaySmall: displayTheme.displaySmall,
      headlineLarge: displayTheme.headlineLarge,
      headlineMedium: displayTheme.headlineMedium,
      headlineSmall: displayTheme.headlineSmall,
    );

    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'Smart Quiz',
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: textTheme,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFC2652A),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE08850),
          onPrimaryContainer: Color(0xFFFBE8D8),
          secondary: Color(0xFF78706A),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFEAE2DA),
          onSecondaryContainer: Color(0xFF605850),
          tertiary: Color(0xFF8C3C3C),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFD47070),
          onTertiaryContainer: Color(0xFF3A2020),
          error: Color(0xFFC0392B),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFCE4E0),
          onErrorContainer: Color(0xFF7A1A10),
          surface: Color(0xFFFAF5EE),
          onSurface: Color(0xFF3A302A),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFF6F0E8),
          surfaceContainer: Color(0xFFF2ECE4),
          surfaceContainerHigh: Color(0xFFECE6DC),
          surfaceContainerHighest: Color(0xFFE6E0D6),
          outline: Color(0xFF9A9088),
          outlineVariant: Color(0xFFD8D0C8),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: textTheme.apply(
          bodyColor: const Color(0xFFECE6DC),
          displayColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF0A878),
          onPrimary: Color(0xFF401A08),
          primaryContainer: Color(0xFFC2652A),
          onPrimaryContainer: Color(0xFFFBE8D8),
          secondary: Color(0xFFCEC6BE),
          onSecondary: Color(0xFF2A2420),
          secondaryContainer: Color(0xFF504840),
          onSecondaryContainer: Color(0xFFEAE2DA),
          tertiary: Color(0xFFE8A0A0),
          onTertiary: Color(0xFF2E1515),
          tertiaryContainer: Color(0xFF8C3C3C),
          onTertiaryContainer: Color(0xFFFCE0E0),
          error: Color(0xFFE8A0A0),
          onError: Color(0xFF3E1515),
          errorContainer: Color(0xFF8C3C3C),
          onErrorContainer: Color(0xFFFCE0E0),
          surface: Color(0xFF211510),
          onSurface: Color(0xFFECE6DC),
          surfaceContainerLowest: Color(0xFF140D0A),
          surfaceContainerLow: Color(0xFF1B100B),
          surfaceContainer: Color(0xFF2C1A12),
          surfaceContainerHigh: Color(0xFF38231B),
          surfaceContainerHighest: Color(0xFF483025),
          outline: Color(0xFF9A9088),
          outlineVariant: Color(0xFF605850),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/results': (context) => const ResultsScreen(),
        '/custom-category': (context) => const CustomCategoryScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/avatar': (context) => const AvatarScreen(),
        '/featured-video': (context) => const FeaturedVideoPage(),
      },
    );
  }
}
