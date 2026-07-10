import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/quiz_record.dart';
import '../widgets/shared_widgets.dart';

/// Quiz History screen — starts empty, automatically populated after each
/// completed match via [AppState.quizHistory].
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = context.watch<AppState>().quizHistory;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
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

          // Main Content
          Positioned.fill(
            top: 64 + MediaQuery.of(context).padding.top,
            bottom: 80,
            child: history.isEmpty
                ? _buildEmptyState(context, theme)
                : _buildHistoryList(context, theme, history),
          ),

          // Bottom Nav
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: AppBottomNav(activeTab: NavTab.history),
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

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHigh,
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No matches yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete a quiz and your results will appear here, tracked with elegance.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Start a Quiz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    ThemeData theme,
    List<QuizRecord> history,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Matches',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your journey through knowledge, tracked with elegance.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _HistoryCard(record: history[i]),
              ),
              childCount: history.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QuizRecord record;
  const _HistoryCard({required this.record});

  String get _timeAgo {
    final diff = DateTime.now().difference(record.completedAt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  Color _scoreColor(BuildContext context) {
    final pct = record.percentage;
    final theme = Theme.of(context);
    if (pct >= 80) return theme.colorScheme.primary;
    if (pct >= 50) return theme.colorScheme.secondary;
    return theme.colorScheme.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = _scoreColor(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.category.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  record.category,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _timeAgo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${record.correct}/${record.total}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scoreColor,
                ),
              ),
              const SizedBox(height: 6),
              // Mini score dots
              Row(
                children: List.generate(3, (i) {
                  final filled = i < (record.percentage / 34).floor();
                  return Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? scoreColor
                          : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
