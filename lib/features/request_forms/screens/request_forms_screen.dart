import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../models/request_form_model.dart';
import '../providers/request_forms_provider.dart';
import '../widgets/request_form_dialog.dart';
import '../widgets/submit_request_dialog.dart';

class RequestFormsScreen extends StatefulWidget {
  const RequestFormsScreen({super.key});

  @override
  State<RequestFormsScreen> createState() => _RequestFormsScreenState();
}

class _RequestFormsScreenState extends State<RequestFormsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestFormsProvider>().fetchRequestForms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<RequestFormsProvider>().searchRequestForms(query);
    });
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => const RequestFormDialog(),
    );
  }

  void _showEditDialog(RequestFormModel form) {
    showDialog(
      context: context,
      builder: (context) => RequestFormDialog(requestForm: form),
    );
  }

  void _showSubmitDialog(RequestFormModel form) {
    showDialog(
      context: context,
      builder: (context) => SubmitRequestDialog(requestForm: form),
    );
  }

  Future<void> _deleteForm(String id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف النموذج "$title"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final provider = context.read<RequestFormsProvider>();
      final success = await provider.deleteRequestForm(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'تم حذف النموذج بنجاح' : provider.error ?? 'حدث خطأ'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<RequestFormsProvider>(
      builder: (context, provider, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1800),
            child: Column(
              children: [
                // Header
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
                        'نماذج المعاملات',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 420,
                        height: 34,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن نموذج...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.searchRequestForms('');
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: PaginationWidget(
                            currentPage: provider.meta!['current_page'] ?? 1,
                            lastPage: provider.meta!['last_page'] ?? 1,
                            onPrevious: () => provider.fetchRequestForms(page: (provider.meta!['current_page'] ?? 1) - 1),
                            onNext: () => provider.fetchRequestForms(page: (provider.meta!['current_page'] ?? 1) + 1),
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: _showCreateDialog,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('إنشاء نموذج جديد', style: TextStyle(fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.requestForms.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا توجد نماذج',
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                                ),
                                child: Column(
                                  children: [
                                    Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(3),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(1),
                                        4: FlexColumnWidth(1.5),
                                        5: FlexColumnWidth(1.5),
                                        6: FlexColumnWidth(2),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey[850] : Colors.grey[100],
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                          ),
                                          children: [
                                            _buildHeaderCell('العنوان', theme),
                                            _buildHeaderCell('الوصف', theme),
                                            _buildHeaderCell('الإصدار', theme),
                                            _buildHeaderCell('الحالة', theme),
                                            _buildHeaderCell('الرسوم', theme),
                                            _buildHeaderCell('عدد الحقول', theme),
                                            _buildHeaderCell('الإجراءات', theme),
                                          ],
                                        ),
                                        ...provider.requestForms.map((form) => _buildDataRow(form, theme, isDark)),
                                      ],
                                    ),
                                  ],
                                ),
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

  Widget _buildHeaderCell(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow _buildDataRow(RequestFormModel form, ThemeData theme, bool isDark) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            form.title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[200] : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            form.description ?? '-',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[200] : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            form.version,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[200] : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: form.status == 'active' 
                  ? Colors.green.withOpacity(0.1) 
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              form.statusArabic,
              style: TextStyle(
                fontSize: 9,
                color: form.status == 'active' ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '${form.feeAmount.toStringAsFixed(0)} ل.ل',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[200] : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '${form.fields.length}',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[200] : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (form.status == 'active')
                IconButton(
                  icon: const Icon(Icons.send, size: 16),
                  color: Colors.green,
                  onPressed: () => _showSubmitDialog(form),
                  tooltip: 'تقديم طلب',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (form.status == 'active') const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                color: Colors.blue,
                onPressed: () => _showEditDialog(form),
                tooltip: 'تعديل',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, size: 16),
                color: Colors.red,
                onPressed: () => _deleteForm(form.id, form.title),
                tooltip: 'حذف',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
