import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

// ─── Avatar Assets ───────────────────────────────────────────────────
// 4 custom avatar images from local assets
const List<String> kAvatarUrls = [
  'assets/images/Cute&Strong.jpeg',
  'assets/images/Fearless.jpeg',
  'assets/images/SilentWinners.jpeg',
  'assets/images/Outspoken.jpeg',
];

// ─── Anime Badge Assets (from Stitch) ──────────────────────────────────────
// Highly-detailed anime-style achievement badges for Results screen
const String kBadgeGold =
    'https://lh3.googleusercontent.com/aida/AP1WRLvl1w-ZKe-wvCojz6e0hc7SbX7bQ7orVGxa_n_rH3lOG7dI1G20kyUp1CnO9S_pbmwZyT3ifsJTFlQJsezsWetXMSfz19w9-pIWAq1_V8PEHyeoFems2ujV_mYrTXMp3d4ZLZxogM3mUy9A0NhrfiZbtLeeaCPwPq0q8uAZzJeFa4wdyntgegWAxcMaf8KNTC9PCP_WgGpk_QjfeA0gR-O5zXOOvmvB9pO0jljvjPZT-VpmXRW5EiQI-ro';
const String kBadgeSilver =
    'https://lh3.googleusercontent.com/aida/AP1WRLuhF41YYEk9ZpBu-K0Cy1xSqoSJpC3Ac8xJfiEH8HSPUb9QcL2JDTJmRB6d3gaw7x0PsawYdqBLpPR3LWheWZEOARGB4t1O0vcR4gMuHHN0JHxX3sBDijywB3r2o85vp2lmhTbsRrPW2y9xFPkbIUkJ2-MvZEhd4OiSsv_4dFuzbuG5rPbsixCNbEfqWAMMn9_919xkz17_2eLIccoD56zzog0Hf3Xxcqyr_Il5neOqGNXDxSpNPRv8ze8';
const String kBadgePlatinum =
    'https://lh3.googleusercontent.com/aida/AP1WRLt6BzNdpp9YIJ99N5ZfE-RuG5BsyBsICM8jAwsSpPXN3HoEQU0BBu71K4x_0tKwnA7vaFYEU7cmozA7zEmaJE6hJdq1oRnPqN4aUWf3wLnpmMrBR3W47NevuClCoRPoABrcDPgWbM_Ee7eRI7Ke-tUenJaGU9P3SBW2hWJHssi1J9yU3ajX-gQFYHX3PkBUZikAv6UkFn2QILMKCg5jvPrMtFort9a6FYjSoGRMIXEvNhxrwNDmnCJSFw';

/// Returns the Stitch anime badge URL for the given percentage score.
String badgeUrlForScore(int percentage) {
  if (percentage == 100) return kBadgePlatinum;
  if (percentage >= 80) return kBadgeGold;
  if (percentage >= 50) return kBadgeSilver;
  return kBadgeGold; // Bronze tier uses Gold badge with descriptive text
}

// ─── Shared Avatar Widget ──────────────────────────────────────────────────

class AppBarAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  const AppBarAvatar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarIndex = context.watch<AppState>().selectedAvatarIndex;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
          color: theme.colorScheme.surfaceContainerHigh,
        ),
        child: ClipOval(
          child: Image.asset(
            kAvatarUrls[avatarIndex.clamp(0, kAvatarUrls.length - 1)],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.person,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared Bottom Nav Bar ─────────────────────────────────────────────────

enum NavTab { home, history, settings, profile }

class AppBottomNav extends StatelessWidget {
  final NavTab activeTab;
  const AppBottomNav({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
            top: BorderSide(
                color:
                    theme.colorScheme.outlineVariant.withValues(alpha: 0.3))),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: activeTab == NavTab.home,
                onTap: () {
                  if (activeTab != NavTab.home) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (r) => false);
                  }
                },
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'History',
                isActive: activeTab == NavTab.history,
                onTap: () {
                  if (activeTab != NavTab.history) {
                    Navigator.pushNamed(context, '/history');
                  }
                },
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isActive: activeTab == NavTab.settings,
                onTap: () {
                  if (activeTab != NavTab.settings) {
                    Navigator.pushNamed(context, '/settings');
                  }
                },
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isActive: activeTab == NavTab.profile,
                onTap: () {
                  if (activeTab != NavTab.profile) {
                    Navigator.pushNamed(context, '/profile');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.65);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                height: 3,
                width: 24,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 9,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
