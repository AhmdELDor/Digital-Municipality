import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_data_table.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/attach_bill_model.dart';
import '../models/bill_model.dart';
import '../providers/bills_provider.dart';
import '../widgets/attach_bill_dialog.dart';
import '../widgets/bill_form_dialog.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (!(auth.isAdmin || auth.isSuperAdmin)) {
        _showAccessDenied();
        return;
      }
      final billsProvider = context.read<BillsProvider>();
      billsProvider.fetchAttachedBills();
      billsProvider.fetchBills();
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

    return Consumer<BillsProvider>(
      builder: (context, provider, _) {
        return DefaultTabController(
          length: 2,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1800),
              child: Column(
                children: [
                  _buildHeader(theme, provider),
                  Container(
                    width: double.infinity,
                    color: theme.scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TabBar(
                      labelColor: theme.primaryColor,
                      unselectedLabelColor: theme.brightness == Brightness.dark 
                          ? Colors.grey.shade400 
                          : theme.textTheme.bodyMedium?.color,
                      indicatorColor: theme.primaryColor,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                      unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                      tabs: const [
                        Tab(text: 'الاستحقاقات المالية المرسلة'),
                        Tab(text: ' الاستحقاقات المالية'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildAttachedTab(theme, provider),
                        _buildTemplatesTab(theme, provider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachedTab(ThemeData theme, BillsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorBanner(provider),
          _buildAttachedSection(theme, provider),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab(ThemeData theme, BillsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorBanner(provider),
          _buildTemplatesSection(theme, provider),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, BillsProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Text('إدارة الاستحقاقات المالية', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 34,
              child: TextField(
                controller: _searchController,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'ابحث عن فاتورة مرفقة (العنوان، المستخدم)...',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                          onPressed: () {
                            _searchController.clear();
                            _statusFilter = 'all';
                            provider.fetchAttachedBills(page: 1, search: '', paid: null);
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor.withValues(alpha: 0.95),
                  border: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  isDense: true,
                ),
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    provider.fetchAttachedBills(page: 1, search: value, paid: _paidFilterFromSelection());
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String>(
              value: _statusFilter,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('كل الحالات')),
                DropdownMenuItem(value: 'paid', child: Text('مدفوعة')),
                DropdownMenuItem(value: 'unpaid', child: Text('غير مدفوعة')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _statusFilter = value);
                provider.fetchAttachedBills(page: 1, search: _searchController.text, paid: _paidFilterFromSelection());
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
          if (provider.attachedMeta != null && provider.attachedMeta!['last_page'] != null && provider.attachedMeta!['last_page'] > 1)
            PaginationWidget(
              currentPage: provider.attachedMeta!['current_page'] ?? 1,
              lastPage: provider.attachedMeta!['last_page'] ?? (provider.attachedMeta!['total_pages'] ?? 1),
              onPrevious: () => provider.fetchAttachedBills(page: (provider.attachedMeta!['current_page'] ?? 1) - 1, search: _searchController.text, paid: _paidFilterFromSelection()),
              onNext: () => provider.fetchAttachedBills(page: (provider.attachedMeta!['current_page'] ?? 1) + 1, search: _searchController.text, paid: _paidFilterFromSelection()),
            ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () => showDialog(context: context, builder: (_) => const BillFormDialog()),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(fontSize: 12),
            ),
            icon: const Icon(Icons.receipt_outlined, size: 16),
            label: const Text('إنشاء '),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () => _openAttachDialog(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 12),
            ),
            icon: const Icon(Icons.send_outlined, size: 16),
            label: const Text('إرفاق فاتورة', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedSection(ThemeData theme, BillsProvider provider) {
    final meta = provider.attachedMeta;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildAttachedTable(theme, provider),
      ],
    );
  }

  Widget _buildAttachedTable(ThemeData theme, BillsProvider provider) {
    const fixedRows = 10;
    final items = provider.attachedBills;
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
                        'الفاتورة',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'المستخدم',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'المبلغ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'الاستحقاق',
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
                            InkWell(
                              onTap: item.citizenId != null ? () => _navigateToUserProfile(item.citizenId!) : null,
                              child: Text(
                                item.citizenName ?? 'غير محدد',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: item.citizenId != null
                                      ? (theme.brightness == Brightness.dark ? Colors.blue.shade300 : theme.primaryColor)
                                      : null,
                                  decoration: item.citizenId != null ? TextDecoration.underline : null,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(item.amount),
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.dueDate != null ? dateFmt.format(item.dueDate!) : '-',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ),
                          DataCell(_buildStatusChip(theme, item.isPaid)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!item.isPaid)
                                  IconButton(
                                    icon: const Icon(Icons.payment, color: Colors.green, size: 18),
                                    tooltip: 'تحديد كمدفوعة',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _handlePayAction(item.id, provider),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.money_off, color: Colors.orange, size: 18),
                                    tooltip: 'استرداد',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _handleUnpayAction(item.id, provider),
                                  ),
                                const SizedBox(width: 8),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, size: 18),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'المزيد',
                                  onSelected: (value) {
                                    if (value == 'view') {
                                      _showAttachedDetails(item);
                                    } else if (value == 'delete') {
                                      _confirmDeleteAttached(item.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
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
                        ],
                      );
                    }
                  }),
                ),
              ),
            ),
          ),
        ),
        if (provider.isAttachedLoading)
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

  Widget _buildStatusChip(ThemeData theme, bool isPaid) {
    return Text(
      isPaid ? 'مدفوعة' : 'غير مدفوعة',
      style: theme.textTheme.bodySmall?.copyWith(
        color: isPaid 
            ? (theme.brightness == Brightness.dark ? Colors.green.shade400 : Colors.green.shade700)
            : (theme.brightness == Brightness.dark ? Colors.red.shade400 : Colors.red.shade700),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  void _navigateToUserProfile(String userId) {
    // TODO: Implement user profile navigation in the future
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('صفحة الملف الشخصي قيد التطوير'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handlePayAction(String billId, BillsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('تأكيد الدفع'),
          ],
        ),
        content: const Text('هل تريد تحديد هذه الفاتورة كمدفوعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.markPaid(billId);
      _showResultSnack(success, success ? 'تم تحديد الفاتورة كمدفوعة' : 'تعذر تحديث الحالة');
    }
  }

  Future<void> _handleUnpayAction(String billId, BillsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.undo, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('استرداد الدفع'),
          ],
        ),
        content: const Text('هل تريد استرداد هذه الفاتورة وتحديدها كغير مدفوعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('استرداد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.markUnpaid(billId);
      _showResultSnack(success, success ? 'تم استرداد الدفع' : 'تعذر تحديث الحالة');
    }
  }

  Widget _buildTemplatesSection(ThemeData theme, BillsProvider provider) {
    final meta = provider.billsMeta;
    const fixedRows = 8;
    final bills = provider.bills;
    final rows = <Map<String, dynamic>>[];

    for (int i = 0; i < bills.length && i < fixedRows; i++) {
      final bill = bills[i];
      rows.add({
        'العنوان': bill.title,
        'نوع_الدفع': bill.paymentType,
        'المبلغ': _formatAmount(bill.amount),
      });
    }
    while (rows.length < fixedRows) {
      rows.add({'العنوان': '', 'نوع_الدفع': '', 'المبلغ': ''});
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Stack(
          children: [
            CustomDataTable(
              columns: const ['العنوان', 'نوع الدفع', 'المبلغ'],
              rows: rows,
              isLoading: false,
              onView: (index) => index < bills.length ? _showBillDetails(bills[index]) : null,
              onEdit: (index) => index < bills.length ? _openBillDialog(bills[index]) : null,
              onDelete: (index) => index < bills.length ? _confirmDeleteBill(bills[index].id) : null,
            ),
            if (provider.isBillsLoading)
              Container(
                decoration: BoxDecoration(color: theme.cardColor.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Padding(padding: EdgeInsets.all(18), child: CircularProgressIndicator())),
              ),
          ],
        ),
      ],
    );
  }

  void _openAttachDialog(BillsProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AttachBillDialog(templates: provider.bills),
    ).then((_) {
      // Refresh lists to reflect latest data
      provider.fetchAttachedBills(search: _searchController.text, paid: _paidFilterFromSelection());
    });
  }

  void _openBillDialog([BillModel? bill]) {
    showDialog(context: context, builder: (_) => BillFormDialog(bill: bill)).then((_) {
      context.read<BillsProvider>().fetchBills(page: 1);
    });
  }

  void _showAttachedDetails(AttachBillModel bill) {
    final theme = Theme.of(context);
    final dateFmt = DateFormat('yyyy-MM-dd');
    CustomDialog.show(
      context: context,
      title: 'تفاصيل الفاتورة',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(theme, 'العنوان', bill.title),
          _detailRow(theme, 'المستخدم', bill.citizenName ?? '-'),
          _detailRow(theme, 'الهاتف', bill.citizenPhone ?? '-'),
          _detailRow(theme, 'المبلغ', _formatAmount(bill.amount)),
          _detailRow(theme, 'تاريخ الاستحقاق', bill.dueDate != null ? dateFmt.format(bill.dueDate!) : '-'),
          _detailRow(theme, 'الحالة', bill.isPaid ? 'مدفوعة' : 'غير مدفوعة'),
          if (bill.note != null && bill.note!.isNotEmpty) _detailRow(theme, 'ملاحظة', bill.note!),
          if (bill.description != null && bill.description!.isNotEmpty) _detailRow(theme, 'الوصف', bill.description!),
        ],
      ),
      actions: [
        if (!bill.isPaid)
          TextButton.icon(
            onPressed: () async {
              final success = await context.read<BillsProvider>().markPaid(bill.id);
              Navigator.of(context).pop();
              _showResultSnack(success, success ? 'تم تعيين الفاتورة كمدفوعة' : 'تعذر تحديث الحالة');
            },
            icon: const Icon(Icons.check_circle, color: Colors.green),
            label: const Text('تحديد كمدفوعة'),
          ),
        if (bill.isPaid)
          TextButton.icon(
            onPressed: () async {
              final success = await context.read<BillsProvider>().markUnpaid(bill.id);
              Navigator.of(context).pop();
              _showResultSnack(success, success ? 'تم تعيين الفاتورة كغير مدفوعة' : 'تعذر تحديث الحالة');
            },
            icon: const Icon(Icons.undo, color: Colors.orange),
            label: const Text('تعيين كغير مدفوعة'),
          ),
      ],
    );
  }

  void _showBillDetails(BillModel bill) {
    final theme = Theme.of(context);
    CustomDialog.show(
      context: context,
      title: 'تفاصيل الفاتورة',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(theme, 'العنوان', bill.title),
          _detailRow(theme, 'نوع الدفع', bill.paymentType),
          _detailRow(theme, 'المبلغ', _formatAmount(bill.amount)),
          if (bill.description != null && bill.description!.isNotEmpty) _detailRow(theme, 'الوصف', bill.description!),
        ],
      ),
      actions: [],
    );
  }

  void _confirmDeleteBill(String id) {
    final provider = context.read<BillsProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('تأكيد الحذف')]),
        content: const Text('سيتم حذف الفاتورة ولا يمكن التراجع عن ذلك.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.deleteBill(id);
              _showResultSnack(success, success ? 'تم حذف الفاتورة' : 'تعذر الحذف');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAttached(String id) {
    final provider = context.read<BillsProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('حذف الفاتورة المرسلة')]),
        content: const Text('هل تريد حذف الفاتورة المرسلة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.deleteAttached(id);
              _showResultSnack(success, success ? 'تم الحذف' : 'تعذر الحذف');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600))),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  void _showResultSnack(bool success, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  Widget _buildErrorBanner(BillsProvider provider) {
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

  bool? _paidFilterFromSelection() {
    if (_statusFilter == 'paid') return true;
    if (_statusFilter == 'unpaid') return false;
    return null;
  }

  String _formatAmount(double amount) {
    // Display amounts in Lebanese pounds
    return '${amount.toStringAsFixed(0)} ل.ل';
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
