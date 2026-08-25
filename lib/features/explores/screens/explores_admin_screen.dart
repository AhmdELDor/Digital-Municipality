import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/explore_model.dart';
import '../providers/explores_provider.dart';
import '../widgets/explore_detail_dialog.dart';
import '../widgets/explore_form_dialog.dart';
import '../widgets/approve_explore_dialog.dart';

class ExploresAdminScreen extends StatefulWidget {
  const ExploresAdminScreen({super.key});

  @override
  State<ExploresAdminScreen> createState() => _ExploresAdminScreenState();
}

class _ExploresAdminScreenState extends State<ExploresAdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _statusFilter;
  String? _typeFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (!(auth.isAdmin || auth.isSuperAdmin)) {
        _showAccessDenied();
        return;
      }
      context.read<ExploresProvider>().fetchAdminExplores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final canManage = auth.isAdmin || auth.isSuperAdmin;

    if (!canManage) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline, size: 52, color: Colors.red),
            SizedBox(height: 12),
            Text('هذه الصفحة متاحة للمدراء فقط'),
          ],
        ),
      );
    }

    return Consumer<ExploresProvider>(
      builder: (context, provider, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1800),
            child: Column(
              children: [
                _buildHeader(theme, provider),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildErrorBanner(provider),
                        _buildExploresTable(theme, provider),
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

  Widget _buildHeader(ThemeData theme, ExploresProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Text('إدارة الاستكشافات', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String>(
              value: _statusFilter,
              items: const [
                DropdownMenuItem(value: null, child: Text('كل الحالات')),
                DropdownMenuItem(value: 'pending', child: Text('قيد الانتظار')),
                DropdownMenuItem(value: 'approved', child: Text('موافق عليه')),
              ],
              onChanged: (value) {
                setState(() => _statusFilter = value);
                provider.fetchAdminExplores(page: 1, status: value, type: _typeFilter);
              },
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide.none),
                filled: true,
                fillColor: theme.cardColor.withValues(alpha: 0.95),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String>(
              value: _typeFilter,
              items: const [
                DropdownMenuItem(value: null, child: Text('كل الأنواع')),
                DropdownMenuItem(value: 'promotion', child: Text('عروضات')),
                DropdownMenuItem(value: 'post', child: Text('منشور')),
              ],
              onChanged: (value) {
                setState(() => _typeFilter = value);
                provider.fetchAdminExplores(page: 1, status: _statusFilter, type: value);
              },
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide.none),
                filled: true,
                fillColor: theme.cardColor.withValues(alpha: 0.95),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ),
          const Spacer(),
          if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: PaginationWidget(
                currentPage: provider.meta!['current_page'] ?? 1,
                lastPage: provider.meta!['last_page'] ?? 1,
                onPrevious: () => provider.fetchAdminExplores(
                  page: (provider.meta!['current_page'] ?? 1) - 1,
                  status: _statusFilter,
                  type: _typeFilter,
                ),
                onNext: () => provider.fetchAdminExplores(
                  page: (provider.meta!['current_page'] ?? 1) + 1,
                  status: _statusFilter,
                  type: _typeFilter,
                ),
              ),
            ),
          ElevatedButton.icon(
            onPressed: () => _showCreateDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 12),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('إضافة استكشاف', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }


  Widget _buildExploresTable(ThemeData theme, ExploresProvider provider) {
    const fixedRows = 13;
    final items = provider.explores;
    final dateFmt = DateFormat('yyyy-MM-dd');

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 40,
                  dataRowMinHeight: 36,
                  dataRowMaxHeight: 40,
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  columns: [
                    DataColumn(
                      label: Text(
                        'الصورة',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'العنوان',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'المواطن',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'النوع',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'الفئة',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'التاريخ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'الحالة',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox.shrink(),
                    ),
                  ],
                  rows: List.generate(fixedRows, (index) {
                    if (index < items.length) {
                      final item = items[index];
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 40,
                              height: 30, // Smaller to fit row height
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: item.hasImages
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        item.imagesUrl.first,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(Icons.error, size: 16, color: Colors.grey.shade400),
                                      ),
                                    )
                                  : Icon(Icons.explore, color: Colors.grey.shade400, size: 20),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                item.title,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.citizen?.fullName ?? 'غير محدد',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                color: item.citizen != null
                                    ? (theme.brightness == Brightness.dark ? Colors.blue.shade300 : theme.primaryColor)
                                    : null,
                                decoration: item.citizen != null ? TextDecoration.underline : null,
                              ),
                            ),
                          ),
                          DataCell(_buildTypeChip(theme, item.type)),
                          DataCell(
                            Text(
                              item.category ?? '-',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.startDate != null ? dateFmt.format(item.startDate!) : '-',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ),
                          DataCell(_buildStatusChip(theme, item.status)),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'المزيد',
                              onSelected: (value) {
                                if (value == 'approve') {
                                  _showApproveDialog(item);
                                } else if (value == 'view') {
                                  _showDetailDialog(item);
                                } else if (value == 'edit') {
                                  _showEditDialog(item);
                                } else if (value == 'delete') {
                                  _confirmDelete(item);
                                }
                              },
                              itemBuilder: (context) => [
                                if (item.isPending)
                                  const PopupMenuItem(
                                    value: 'approve',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('موافقة', style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                const PopupMenuItem(
                                  value: 'view',
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility, size: 16, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('عرض', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 16, color: Colors.orange),
                                          SizedBox(width: 8),
                                          Text('تعديل', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, size: 16, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('حذف', style: TextStyle(fontSize: 12, color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                          ),
                        ],
                      );
                    } else {
                      return const DataRow(
                        cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                        ],
                      );
                    }
                  }),
                ),
              ),
            ),
          ),
        ),
        if (provider.isLoading)
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Padding(
                 padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeChip(ThemeData theme, String type) {
    final isPromotion = type == 'promotion';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPromotion ? Colors.purple.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPromotion ? 'عروضات' : 'منشور',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isPromotion ? Colors.purple.shade700 : Colors.blue.shade700,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, String status) {
    final isPending = status == 'pending';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPending ? 'قيد الانتظار' : 'موافق عليه',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isPending ? Colors.orange.shade700 : Colors.green.shade700,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildErrorBanner(ExploresProvider provider) {
    if (provider.error == null) return const SizedBox.shrink();
    return Container(
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
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => const ExploreFormDialog(),
    ).then((_) => context.read<ExploresProvider>().fetchAdminExplores(status: _statusFilter, type: _typeFilter));
  }

  void _showEditDialog(ExploreModel explore) {
    showDialog(
      context: context,
      builder: (_) => ExploreFormDialog(explore: explore),
    ).then((_) => context.read<ExploresProvider>().fetchAdminExplores(status: _statusFilter, type: _typeFilter));
  }

  void _showDetailDialog(ExploreModel explore) {
    showDialog(
      context: context,
      builder: (_) => ExploreDetailDialog(explore: explore),
    );
  }

  void _showApproveDialog(ExploreModel explore) {
    showDialog(
      context: context,
      builder: (_) => ApproveExploreDialog(explore: explore),
    ).then((_) => context.read<ExploresProvider>().fetchAdminExplores(status: _statusFilter, type: _typeFilter));
  }

  void _confirmDelete(ExploreModel explore) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('تأكيد الحذف')]),
        content: Text('هل تريد حذف "${explore.title}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await context.read<ExploresProvider>().deleteExplore(explore.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم الحذف بنجاح' : 'فشل الحذف'),
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

  void _showAccessDenied() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(children: [Icon(Icons.lock, color: Colors.red, size: 28), SizedBox(width: 12), Text('غير مصرح')]),
        content: const Text('هذه الصفحة متاحة فقط لمدير أو مدير عام.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('العودة'),
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
