import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../models/request_form_model.dart';
import '../providers/user_requests_provider.dart';
import '../widgets/user_request_detail_dialog.dart';

class UserRequestsScreen extends StatefulWidget {
  const UserRequestsScreen({super.key});

  @override
  State<UserRequestsScreen> createState() => _UserRequestsScreenState();
}

class _UserRequestsScreenState extends State<UserRequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserRequestsProvider>().fetchUserRequests();
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
      context.read<UserRequestsProvider>().searchUserRequests(query);
    });
  }

  void _onStatusFilterChanged(String? status) {
    setState(() => _selectedStatus = status);
    context.read<UserRequestsProvider>().filterByStatus(status);
  }

  void _showRequestDetail(UserRequestModel request) {
    showDialog(
      context: context,
      builder: (context) => UserRequestDetailDialog(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<UserRequestsProvider>(
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
                        'معاملات المواطنين',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 300,
                        height: 34,
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن طلب...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.searchUserRequests('');
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
                      const SizedBox(width: 16),
                      Container(
                        width: 160,
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            hint: Text(
                              'تصفية حسب الحالة',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey.shade500),
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('جميع الحالات', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'pending', child: Text('قيد الانتظار', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'approved', child: Text('موافق عليه', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'rejected', child: Text('مرفوض', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: 'info_needed', child: Text('يحتاج معلومات', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: _onStatusFilterChanged,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1)
                        PaginationWidget(
                          currentPage: provider.meta!['current_page'] ?? 1,
                          lastPage: provider.meta!['last_page'] ?? 1,
                          onPrevious: () => provider.fetchUserRequests(page: (provider.meta!['current_page'] ?? 1) - 1),
                          onNext: () => provider.fetchUserRequests(page: (provider.meta!['current_page'] ?? 1) + 1),
                        ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.userRequests.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا توجد طلبات',
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
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(1.5),
                                        3: FlexColumnWidth(3),
                                        4: FlexColumnWidth(1.5),
                                        5: FlexColumnWidth(1.5),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey[850] : Colors.grey[100],
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                          ),
                                          children: [
                                            _buildHeaderCell('المواطن', theme),
                                            _buildHeaderCell('نوع الطلب', theme),
                                            _buildHeaderCell('الرسوم', theme),
                                            _buildHeaderCell('ملاحظات الإدارة', theme),
                                            _buildHeaderCell('الحالة', theme),
                                            _buildHeaderCell('تاريخ الإنشاء', theme),
                                          ],
                                        ),
                                        ...provider.userRequests.map((request) => _buildDataRow(request, theme, isDark)),
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

  TableRow _buildDataRow(UserRequestModel request, ThemeData theme, bool isDark) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      children: [
        InkWell(
          onTap: () => _showRequestDetail(request),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              request.user.fullName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => _showRequestDetail(request),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              request.requestForm.title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        InkWell(
          onTap: () => _showRequestDetail(request),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${request.requestForm.feeAmount.toStringAsFixed(0)} ل.ل',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        InkWell(
          onTap: () => _showRequestDetail(request),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              request.adminNote ?? '-',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        InkWell(
          onTap: () => _showRequestDetail(request),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(request.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request.statusArabic,
                style: TextStyle(
                  fontSize: 9,
                  color: _getStatusColor(request.status),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => _showRequestDetail(request),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              request.createdAt != null
                  ? DateFormat('dd/MM/yyyy').format(request.createdAt!)
                  : '-',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'info_needed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
