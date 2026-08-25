import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../../core/widgets/custom_data_table.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../providers/complaints_provider.dart';
import '../widgets/result_update_dialog.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplaintsProvider>().fetchComplaints();
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

    return Consumer<ComplaintsProvider>(
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
                        'إدارة الشكاوى',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 480,
                        height: 34,
                        child: TextField(
                          controller: _searchController,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن شكوى (العنوان، اسم المستخدم، رقم الهاتف)...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.fetchComplaints(search: '');
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
                              provider.fetchComplaints(search: value);
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1)
                        PaginationWidget(
                          currentPage: provider.meta!['current_page'] ?? 1,
                          lastPage: provider.meta!['last_page'] ?? 1,
                          onPrevious: () => provider.fetchComplaints(page: (provider.meta!['current_page'] ?? 1) - 1),
                          onNext: () => provider.fetchComplaints(page: (provider.meta!['current_page'] ?? 1) + 1),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Error message
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


                        // Complaints data table
                        _buildStableDataTable(context, provider),
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

  Widget _buildStableDataTable(BuildContext context, ComplaintsProvider provider) {
    // Always display 13 rows to maintain fixed card height
    final fixedRowCount = 13;
    final actualComplaints = provider.complaints;
    final paddedRows = <Map<String, String>>[];
    
    // Add actual complaint data
    for (int i = 0; i < actualComplaints.length && i < fixedRowCount; i++) {
      final complaint = actualComplaints[i];
      paddedRows.add({
        'العنوان': complaint.title,
        'المستخدم': '${complaint.user.fullName}\n${complaint.user.phoneNumber}',
        'الوصف': complaint.desc,
        'الحالة': _getStatusText(complaint.status),
        'النتيجة': complaint.result ?? 'لا يوجد',
        'التاريخ': _formatDate(complaint.createdAt),
      });
    }
    
    // Fill remaining slots with empty rows to maintain fixed height
    while (paddedRows.length < fixedRowCount) {
      paddedRows.add({
        'العنوان': '',
        'المستخدم': '',
        'الوصف': '',
        'الحالة': '',
        'النتيجة': '',
        'التاريخ': '',
      });
    }

    return Stack(
      children: [
        CustomDataTable(
          columns: const ['العنوان', 'المستخدم', 'الوصف', 'الحالة', 'النتيجة', 'التاريخ'],
          rows: paddedRows,
          isLoading: false, // Never show loading in table to prevent layout shifts
          editLabel: 'إجابة',
          editIcon: Icons.reply,
          editColor: Colors.orange.shade700,
          viewColor: Colors.blue.shade700,
          deleteColor: Colors.red.shade700,
          onCellTap: (rowIndex, columnName) {
            if (columnName == 'المستخدم' && rowIndex < actualComplaints.length) {
              final complaint = actualComplaints[rowIndex];
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('الانتقال إلى ملف ${complaint.user.fullName}'),
                  backgroundColor: Colors.blue,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          onView: (index) => index < actualComplaints.length ? _showComplaintDetailsDialog(context, actualComplaints[index]) : null,
          onEdit: (index) => index < actualComplaints.length ? _showResultDialog(context, actualComplaints[index].id, actualComplaints[index].result) : null,
          onDelete: (index) => index < actualComplaints.length ? _confirmDelete(context, actualComplaints[index].id, actualComplaints[index].title) : null,
        ),
        if (provider.isLoading)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  void _showComplaintDetailsDialog(BuildContext context, complaint) {
    final theme = Theme.of(context);
    CustomDialog.show(
      context: context,
      title: 'تفاصيل الشكوى',
      width: 600,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(theme, 'العنوان', complaint.title),
          _detailRow(theme, 'المستخدم', complaint.user.fullName),
          _detailRow(theme, 'رقم الهاتف', complaint.user.phoneNumber),
          _detailRow(theme, 'الوصف', complaint.desc),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text('الحالة', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(complaint.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(complaint.status).withOpacity(0.5)),
                  ),
                  child: Text(
                    _getStatusText(complaint.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(complaint.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _detailRow(theme, 'النتيجة', complaint.result ?? 'لا يوجد'),
          _detailRow(theme, 'التاريخ', _formatDate(complaint.createdAt)),
          if (complaint.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text('الصور المرفقة:', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: complaint.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _showImages(context, complaint.images),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            complaint.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
        if (complaint.images.isNotEmpty)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showImages(context, complaint.images);
            },
            child: const Text('عرض جميع الصور'),
          ),
      ],
    );
  }

  Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
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
      case 'received':
        return '🔴 مستلم';
      case 'pending':
        return '🟡 قيد المعالجة';
      case 'resolved':
        return '🟢 تم الحل';
      case 'closed':
        return '⚫ مغلق';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return Colors.red.shade700;
      case 'pending':
        return Colors.orange.shade700;
      case 'resolved':
        return Colors.green.shade700;
      case 'closed':
        return Colors.grey.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  void _showResultDialog(BuildContext context, String complaintId, String? currentResult) {
    showDialog(
      context: context,
      builder: (_) => ResultUpdateDialog(
        complaintId: complaintId,
        currentResult: currentResult,
      ),
    );
  }

  void _showImages(BuildContext context, List<String> images) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('صور الشكوى', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 200,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 48),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String complaintId, String title) {
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
        content: Text('هل أنت متأكد من حذف الشكوى "$title"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final provider = context.read<ComplaintsProvider>();
              final success = await provider.deleteComplaint(complaintId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم حذف الشكوى بنجاح' : 'فشل حذف الشكوى'),
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
