import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/polls_provider.dart';
import '../widgets/poll_form_dialog.dart';

class PollDetailScreen extends StatelessWidget {
  final dynamic poll;

  const PollDetailScreen({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor(poll.status, isDark);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Stack(
          children: [
            // Content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with status, title, and description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withOpacity(0.5), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              poll.status == 'in_progress'
                                  ? Icons.check_circle
                                  : poll.status == 'ended'
                                      ? Icons.lock
                                      : Icons.schedule,
                              size: 12,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getStatusText(poll.status),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title and description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              poll.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),
                            if (poll.description != null && poll.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.grey.shade600,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      poll.description!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 11,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Main content with results on left and stats on right
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Results section (left side)
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bar_chart_rounded,
                                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'نتائج الاستطلاع',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Vote bars
                                  if (poll.totalVotes == 0)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.poll_outlined,
                                              size: 40,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'لا توجد أصوات حتى الآن',
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    ...poll.sortedOptions.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final option = entry.value;
                                      final percentage = poll.getPercentage(option.key);
                                      final color = _getBarColor(index, isDark);
                                      final isWinner = index == 0 && percentage > 0;

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                if (isWinner) ...[
                                                  Icon(
                                                    Icons.emoji_events,
                                                    color: Colors.amber.shade700,
                                                    size: 13,
                                                  ),
                                                  const SizedBox(width: 5),
                                                ],
                                                Expanded(
                                                  child: Text(
                                                    option.key,
                                                    style: TextStyle(
                                                      fontWeight: isWinner
                                                          ? FontWeight.bold
                                                          : FontWeight.w600,
                                                      fontSize: 11,
                                                      color: Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                    vertical: 3,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: color.withOpacity(0.12),
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: color.withOpacity(0.35),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${option.value} صوت',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.bold,
                                                      color: color,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                FractionallySizedBox(
                                                  widthFactor: percentage / 100,
                                                  child: Container(
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          color,
                                                          color.withOpacity(0.8),
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: color.withOpacity(0.2),
                                                          blurRadius: 3,
                                                          offset: const Offset(0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      '${percentage.toStringAsFixed(1)}%',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                ],
                              ),
                            ),
                          ),
                          // Divider
                          VerticalDivider(width: 1, color: theme.dividerColor, thickness: 1),
                          // Stats and dates (right side)
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildCompactStatCard(
                                    theme,
                                    Icons.people,
                                    'إجمالي الأصوات',
                                    '${poll.totalVotes}',
                                    isDark ? const Color(0xFF8BAE8F) : const Color(0xFF6B8E6F),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildCompactStatCard(
                                    theme,
                                    Icons.ballot,
                                    'عدد الخيارات',
                                    '${poll.options.length}',
                                    isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDatesCard(theme),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildCompactStatCard(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDatesCard(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          if (poll.startAt != null)
            _buildCompactDateRow(
              Icons.calendar_today,
              'تاريخ البدء',
              _formatDate(poll.startAt),
              isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99),
            ),
          if (poll.startAt != null && poll.endAt != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: theme.dividerColor),
            ),
          if (poll.endAt != null)
            _buildCompactDateRow(
              Icons.event,
              'تاريخ الانتهاء',
              _formatDate(poll.endAt),
              isDark ? const Color(0xFFDAA520) : const Color(0xFFB8860B),
            ),
          if (poll.startAt == null && poll.endAt == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'لا توجد تواريخ',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactDateRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getBarColor(int index, bool isDark) {
    final colors = isDark
        ? [
            const Color(0xFF7B9CBB),  // Lighter muted blue
            const Color(0xFF8BAE8F),  // Lighter muted green
            const Color(0xFFBB9E7B),  // Lighter muted brown
            const Color(0xFFAB9ABB),  // Lighter muted purple
            const Color(0xFF9ABBBB),  // Lighter muted teal
            const Color(0xFFBB9A9A),  // Lighter muted rose
            const Color(0xFF8B9ABB),  // Lighter muted indigo
            const Color(0xFF9AAB9A),  // Lighter muted sage
          ]
        : [
            const Color(0xFF5B7C99),  // Muted blue
            const Color(0xFF6B8E6F),  // Muted green
            const Color(0xFF9B7E5B),  // Muted brown
            const Color(0xFF8B7A9B),  // Muted purple
            const Color(0xFF7A9B9B),  // Muted teal
            const Color(0xFF9B7A7A),  // Muted rose
            const Color(0xFF6B7A9B),  // Muted indigo
            const Color(0xFF7A8B7A),  // Muted sage
          ];
    return colors[index % colors.length];
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'نشط';
      case 'ended':
        return 'منتهي';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status, bool isDark) {
    switch (status.toLowerCase()) {
      case 'pending':
        return isDark ? const Color(0xFFDAA520) : const Color(0xFFB8860B);
      case 'in_progress':
        return isDark ? const Color(0xFF8BAE8F) : const Color(0xFF6B8E6F);
      case 'ended':
        return isDark ? Colors.grey.shade400 : Colors.grey.shade600;
      default:
        return isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99);
    }
  }

  void _showPollDialog(BuildContext context, poll) {
    showDialog(
      context: context,
      builder: (_) => PollFormDialog(poll: poll),
    );
  }

  void _confirmDelete(BuildContext context, String pollId, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('تأكيد الحذف'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف الاستطلاع "$title"؟\nسيتم حذف جميع الأصوات المرتبطة به.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final provider = context.read<PollsProvider>();
              final success = await provider.deletePoll(pollId);
              if (context.mounted) {
                Navigator.of(context).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'تم حذف الاستطلاع بنجاح' : 'فشل حذف الاستطلاع'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
