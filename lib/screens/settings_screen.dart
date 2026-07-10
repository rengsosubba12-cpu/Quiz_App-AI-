import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/shared_widgets.dart';

/// Settings screen — Sahara editorial design.
/// Implements functional Appearance (Light/Dark) and Music toggles.
/// Contact section includes rengsosubba12@gmail.com.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Ambient background blob
          Positioned(
            top: -40,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top App Bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildAppBar(context, theme),
          ),

          // Main scrollable content
          Positioned.fill(
            top: 64 + MediaQuery.of(context).padding.top,
            bottom: 80,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page title
                  Text(
                    'Settings',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Refine your intellectual atmosphere.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Preferences Card ─────────────────────────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tune_rounded, color: theme.colorScheme.primary, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Preferences',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Music toggle
                        _ToggleRow(
                          icon: Icons.music_note_rounded,
                          title: 'Music',
                          subtitle: 'Ambient scores during quizzes',
                          value: appState.isMusicOn,
                          onChanged: (_) => context.read<AppState>().toggleMusic(),
                        ),

                        Divider(
                          height: 32,
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),

                        // Appearance switcher
                        Row(
                          children: [
                            Icon(Icons.palette_rounded, color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Appearance',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose your visual horizon',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _ThemeButton(
                                label: 'Light',
                                icon: Icons.light_mode_rounded,
                                isActive: appState.themeMode == ThemeMode.light,
                                onTap: () => context.read<AppState>().setThemeMode(ThemeMode.light),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ThemeButton(
                                label: 'Dark',
                                icon: Icons.dark_mode_rounded,
                                isActive: appState.themeMode == ThemeMode.dark,
                                onTap: () => context.read<AppState>().setThemeMode(ThemeMode.dark),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Decorative Banner ────────────────────────────────
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.tertiaryContainer,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Design Statement',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Dust is all within',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Contact Makers ───────────────────────────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.contacts_rounded, color: theme.colorScheme.primary, size: 22),
                            const SizedBox(width: 10),
                            Text(
                              'Contact Makers',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Email — General Inquiries
                        const _ContactTile(
                          icon: Icons.alternate_email_rounded,
                          label: 'General Inquiries',
                          value: 'studio@smartquiz.art',
                        ),
                        const SizedBox(height: 12),

                        // Developer email per spec
                        const _ContactTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Developer',
                          value: 'rengsosubba12@gmail.com',
                        ),

                        const SizedBox(height: 24),

                        // Social icons row
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _IconAction(icon: Icons.share_rounded),
                            SizedBox(width: 16),
                            _IconAction(icon: Icons.policy_rounded),
                            SizedBox(width: 16),
                            _IconAction(icon: Icons.help_center_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Version
                  Center(
                    child: Text(
                      'VERSION 1.0.0 — BAKED IN THE DESERT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                        letterSpacing: 2,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Nav
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: AppBottomNav(activeTab: NavTab.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            color: theme.colorScheme.onSurfaceVariant,
            onPressed: () {},
          ),
          Text(
            'Smart Quiz',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const AppBarAvatar(),
        ],
      ),
    );
  }
}

// ─── Section Card ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── Toggle Row ────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: theme.colorScheme.primary,
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return theme.colorScheme.primaryContainer;
            }
            return theme.colorScheme.surfaceContainerHighest;
          }),
        ),
      ],
    );
  }
}

// ─── Theme Button ──────────────────────────────────────────────────────────

class _ThemeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive
              ? theme.colorScheme.surface
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Contact Tile ──────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  letterSpacing: 1.5,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Icon Action ───────────────────────────────────────────────────────────

class _IconAction extends StatelessWidget {
  final IconData icon;
  const _IconAction({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainerHigh,
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
