import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/shared_widgets.dart';

/// Avatar Selection screen — animated grid of 6 anime-style avatars.
/// Selecting an avatar updates AppState.selectedAvatarIndex globally.
class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  late int _selectedIndex;

  final List<String> _avatarNames = [
    'Cute&Strong',
    'Fearless',
    'SilentWinners',
    'Outspoken',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = context.read<AppState>().selectedAvatarIndex;
  }

  void _confirm() {
    context.read<AppState>().setAvatar(_selectedIndex);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A0E08),
      body: Stack(
        children: [
          // Warm desert ambient glow
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFC2652A).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8C3C3C).withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        'Choose Avatar',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 12),

                // Sub heading
                Text(
                  'Select your desert identity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFF0A878).withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // Avatar grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: kAvatarUrls.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFF0A878)
                                    : Colors.white.withValues(alpha: 0.08),
                                width: isSelected ? 3 : 1,
                              ),
                              color: isSelected
                                  ? const Color(0xFFC2652A)
                                      .withValues(alpha: 0.15)
                                  : Colors.white.withValues(alpha: 0.04),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFC2652A)
                                            .withValues(alpha: 0.4),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    kAvatarUrls[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFF2C1A0E),
                                      child: const Icon(Icons.person,
                                          color: Color(0xFFF0A878), size: 48),
                                    ),
                                  ),
                                  // Gradient overlay at bottom
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.7),
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        _avatarNames[index],
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  // Selected checkmark
                                  if (isSelected)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFC2652A),
                                        ),
                                        child: const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 16),
                                      ).animate().scale(
                                            begin: const Offset(0, 0),
                                            end: const Offset(1, 1),
                                            duration: 200.ms,
                                            curve: Curves.easeOutBack,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: 100 + index * 80),
                                duration: 400.ms,
                              )
                              .slideY(
                                begin: 0.2,
                                end: 0,
                                delay: Duration(milliseconds: 100 + index * 80),
                                duration: 400.ms,
                              ),
                        );
                      },
                    ),
                  ),
                ),

                // Confirm button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC2652A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'CONFIRM SELECTION',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(
                    begin: 0.3, end: 0, delay: 600.ms, duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
