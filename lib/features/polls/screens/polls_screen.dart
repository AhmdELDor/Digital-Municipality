import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../providers/polls_provider.dart';
import '../widgets/poll_form_dialog.dart';
import 'poll_detail_screen.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PollsProvider>().fetchPolls();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<PollsProvider>(
      builder: (context, provider, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1800),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(
                      bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'إدارة الاستطلاعات',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 400,
                        height: 34,
                        child: TextField(
                          controller: _searchController,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن استطلاع...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.fetchPolls(search: '');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: theme.cardColor.withValues(alpha: 0.95),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 4),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            _debounce?.cancel();
                            _debounce = Timer(const Duration(milliseconds: 500), () {
                              provider.fetchPolls(search: value);
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      // Pagination Widget
                      if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1) ...[
                        PaginationWidget(
                          currentPage: provider.meta!['current_page'] ?? 1,
                          lastPage: provider.meta!['last_page'] ?? 1,
                          onPrevious: () {
                            final currentPage = provider.meta!['current_page'] ?? 1;
                            if (currentPage > 1) {
                              provider.fetchPolls(page: currentPage - 1, search: _searchController.text);
                            }
                          },
                          onNext: () {
                            final currentPage = provider.meta!['current_page'] ?? 1;
                            final lastPage = provider.meta!['last_page'] ?? 1;
                            if (currentPage < lastPage) {
                              provider.fetchPolls(page: currentPage + 1, search: _searchController.text);
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                      ElevatedButton.icon(
                        onPressed: () => _showPollDialog(context, null),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('استطلاع جديد', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      // Error message
                      if (provider.error != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(provider.error!, style: TextStyle(color: Colors.red.shade700)),
                              ),
                              IconButton(
                                onPressed: () => provider.clearError(),
                                icon: const Icon(Icons.close),
                                color: Colors.red.shade700,
                              ),
                            ],
                          ),
                        ),

                      // Polls cards grid
                      Expanded(
                        child: provider.isLoading && provider.polls.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : provider.polls.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.poll_outlined, size: 64, color: Colors.grey.shade400),
                                        const SizedBox(height: 16),
                                        Text(
                                          'لا توجد استطلاعات',
                                          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    padding: const EdgeInsets.all(24),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = constraints.maxWidth > 1400
                                            ? 4
                                            : constraints.maxWidth > 1000
                                                ? 3
                                                : constraints.maxWidth > 600
                                                    ? 2
                                                    : 1;

                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount,
                                            childAspectRatio: 1.1,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                          ),
                                          itemCount: provider.polls.length,
                                          itemBuilder: (context, index) {
                                            final poll = provider.polls[index];
                                            return _buildPollCard(context, poll);
                                          },
                                        );
                                      },
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
      },
    );
  }

  Widget _buildPollCard(BuildContext context, poll) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor(poll.status, isDark: isDark);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => PollDetailScreen(poll: poll),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header with status badge, title, and actions menu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.08),
                  statusColor.withOpacity(0.03),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    poll.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 18, color: Colors.grey.shade600),
                  tooltip: 'الإجراءات',
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      height: 36,
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 15, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text('تعديل', style: TextStyle(fontSize: 12, color: Colors.orange.shade700)),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      height: 36,
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 15, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text('حذف', style: TextStyle(fontSize: 12, color: Colors.red.shade700)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showPollDialog(context, poll);
                        break;
                      case 'delete':
                        _confirmDelete(context, poll.id, poll.title);
                        break;
                    }
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (poll.description != null && poll.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      poll.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 10),

                  // Stats row
                  Row(
                    children: [
                      _buildCompactStat(
                        Icons.people_outline,
                        '${poll.totalVotes} صوت',
                        isDark ? const Color(0xFF8BAE8F) : const Color(0xFF6B8E6F),
                      ),
                      const SizedBox(width: 12),
                      _buildCompactStat(
                        Icons.ballot_outlined,
                        '${poll.options.length} خيارات',
                        isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99),
                      ),
                    ],
                  ),

                  // Dates with inline status
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor.withOpacity(0.3), width: 0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              poll.status == 'in_progress' ? Icons.check_circle : 
                              poll.status == 'ended' ? Icons.lock : Icons.schedule,
                              size: 9,
                              color: statusColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              _getStatusText(poll.status).replaceAll('⏳ ', '').replaceAll('✅ ', '').replaceAll('🔒 ', ''),
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (poll.startAt != null)
                        _buildCompactDateChip(
                          Icons.calendar_today_outlined,
                          _formatDate(poll.startAt),
                          isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99),
                          'بدأ',
                        ),
                      if (poll.endAt != null)
                        _buildCompactDateChip(
                          Icons.event_outlined,
                          _formatDate(poll.endAt),
                          isDark ? const Color(0xFFDAA520) : const Color(0xFFB8860B),
                          'ينتهي',
                        ),
                    ],
                  ),

                  // Results section
                  const SizedBox(height: 8),
                  Divider(height: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bar_chart_rounded, size: 14, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                          const SizedBox(width: 5),
                          Text(
                            'النتائج',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99)).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${poll.options.length} خيارات',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isDark ? const Color(0xFF8BAE8F) : const Color(0xFF6B8E6F)).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${poll.totalVotes} صوت',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF8BAE8F) : const Color(0xFF6B8E6F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Vote bars - Modern design
                  if (poll.totalVotes == 0)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: 32, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text(
                              'لا توجد أصوات بعد',
                              style: TextStyle(
                                color: Colors.grey.shade400,
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
                      final color = _getBarColor(index, context);
                      final isWinner = index == 0 && percentage > 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade800.withOpacity(0.3) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isWinner ? color.withOpacity(0.3) : Colors.transparent,
                              width: isWinner ? 1.5 : 0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (isWinner) ...[
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 10),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Expanded(
                                    child: Text(
                                      option.key,
                                      style: TextStyle(
                                        fontWeight: isWinner ? FontWeight.bold : FontWeight.w600,
                                        fontSize: 10,
                                        color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${percentage.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${option.value}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: percentage / 100,
                                    child: Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            color,
                                            color.withOpacity(0.7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: isWinner ? [
                                          BoxShadow(
                                            color: color.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ] : null,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                       ]
                        )
                        )
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildCompactStat(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactDateChip(IconData icon, String label, Color color, [String? prefix]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          if (prefix != null) ...[
            Text(
              '$prefix: ',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.7),
              ),
            ),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBarColor(int index, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

  Widget _buildStatItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDateChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '⏳ قيد الانتظار';
      case 'in_progress':
        return '✅ نشط';
      case 'ended':
        return '🔒 منتهي';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status, {bool? isDark}) {
    final dark = isDark ?? (Theme.of(context).brightness == Brightness.dark);
    switch (status.toLowerCase()) {
      case 'pending':
        return dark ? const Color(0xFFDAA520) : const Color(0xFFB8860B);  // Lighter goldenrod for dark
      case 'in_progress':
        return dark ? const Color(0xFF8BAE8F) : const Color(0xFF6B8E6F);  // Lighter green for dark
      case 'ended':
        return dark ? Colors.grey.shade400 : Colors.grey.shade600;
      default:
        return dark ? const Color(0xFF7B9CBB) : const Color(0xFF5B7C99);  // Lighter blue for dark
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم حذف الاستطلاع بنجاح' : 'فشل حذف الاستطلاع'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
