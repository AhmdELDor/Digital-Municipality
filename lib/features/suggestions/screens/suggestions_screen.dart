import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/suggestion_model.dart';
import '../providers/suggestions_provider.dart';
import '../widgets/suggestion_form_dialog.dart';
import '../widgets/suggestion_detail_dialog.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SuggestionsProvider>().fetchSuggestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final isAdmin = authProvider.user?.role == 'admin' || authProvider.user?.role == 'superadmin';

    return Consumer<SuggestionsProvider>(
      builder: (context, provider, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1800),
            child: Column(
              children: [
                // Pinned header
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
                        'الاقتراحات',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      if (isAdmin)
                        SizedBox(
                          width: 420,
                          height: 34,
                          child: TextField(
                            controller: _searchController,
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'ابحث عن اقتراح (اسم المواطن)...',
                              hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                              prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                      onPressed: () {
                                        _searchController.clear();
                                        provider.searchSuggestions('');
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
                                provider.searchSuggestions(value);
                              });
                            },
                          ),
                        ),
                      const Spacer(),
                      if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1)
                        Padding(
                          padding: EdgeInsets.only(left: isAdmin ? 0 : 16),
                          child: PaginationWidget(
                            currentPage: provider.meta!['current_page'] ?? 1,
                            lastPage: provider.meta!['last_page'] ?? (provider.meta!['total_pages'] ?? 1),
                            onPrevious: () => provider.fetchSuggestions(page: (provider.meta!['current_page'] ?? 1) - 1),
                            onNext: () => provider.fetchSuggestions(page: (provider.meta!['current_page'] ?? 1) + 1),
                          ),
                        ),
                      if (!isAdmin)
                        ElevatedButton.icon(
                          onPressed: () => _showSuggestionDialog(context, null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('إضافة اقتراح', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                ),

                // Scrollable body below
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.error != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade700),
                                const SizedBox(width: 12),
                                Expanded(child: Text(provider.error!, style: TextStyle(color: Colors.red.shade700))),
                                IconButton(
                                  onPressed: () => provider.clearError(),
                                  icon: const Icon(Icons.close),
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ),
                          ),
                        _buildSuggestionsTable(context, provider.suggestions, provider.isLoading, isAdmin),
                        if (provider.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsTable(BuildContext context, List<SuggestionModel> suggestions, bool isLoading, bool isAdmin) {
    final theme = Theme.of(context);
    if (!isLoading && suggestions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(Icons.comment_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('لا توجد اقتراحات حالياً', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              isAdmin ? 'لا توجد اقتراحات من المواطنين' : 'أضف أول اقتراح لك',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (isAdmin) ...[
                  SizedBox(
                    width: 150,
                    child: Text(
                      'المواطن',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'رقم الهاتف',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    'الاقتراح',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'التاريخ',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (!isAdmin)
                  SizedBox(
                    width: 70,
                    child: Text(
                      'إجراءات',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          // Table Body
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return InkWell(
                onTap: () => _showSuggestionDetailDialog(context, suggestion),
                hoverColor: theme.primaryColor.withOpacity(0.05),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      if (isAdmin) ...[
                        SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: theme.primaryColor.withOpacity(0.1),
                                child: Text(
                                  suggestion.citizen.fullName.isNotEmpty ? suggestion.citizen.fullName[0].toUpperCase() : '?',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.primaryColor),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  suggestion.citizen.fullName,
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            suggestion.citizen.phonenumber,
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          suggestion.desc,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          _formatDate(suggestion.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (!isAdmin)
                        SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                onPressed: () => _showSuggestionDialog(context, suggestion),
                                tooltip: 'تعديل',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 16, color: Colors.red.shade400),
                                onPressed: () => _showDeleteConfirmDialog(context, suggestion),
                                tooltip: 'حذف',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showSuggestionDetailDialog(BuildContext context, SuggestionModel suggestion) {
    showDialog(context: context, builder: (_) => SuggestionDetailDialog(suggestion: suggestion));
  }

  void _showSuggestionDialog(BuildContext context, SuggestionModel? suggestion) {
    showDialog(context: context, builder: (_) => SuggestionFormDialog(suggestion: suggestion));
  }

  void _showDeleteConfirmDialog(BuildContext context, SuggestionModel suggestion) {
    final provider = context.read<SuggestionsProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('تأكيد الحذف')],
        ),
        content: const Text('هل أنت متأكد من حذف هذا الاقتراح؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.deleteSuggestion(suggestion.id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'تم حذف الاقتراح' : 'فشل حذف الاقتراح'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
