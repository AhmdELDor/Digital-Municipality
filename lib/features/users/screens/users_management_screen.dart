                                import 'dart:async';
                                import 'package:flutter/material.dart';
                                import 'package:provider/provider.dart';
                                import '../../../core/widgets/custom_data_table.dart';
                                import '../../../core/widgets/custom_dialog.dart';
                                import '../../../core/widgets/pagination_widget.dart';
                                import '../../auth/providers/auth_provider.dart';
                                import '../providers/users_provider.dart';
                                import '../widgets/user_form_dialog.dart';
                                import '../models/user_model.dart';

                                class UsersManagementScreen extends StatefulWidget {
                                  const UsersManagementScreen({super.key});

                                  @override
                                  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
                                }

                                class _UsersManagementScreenState extends State<UsersManagementScreen> {
                                  final TextEditingController _searchController = TextEditingController();
                                  Timer? _debounce;

                                  @override
                                  void initState() {
                                    super.initState();
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      final authProvider = context.read<AuthProvider>();
                                      if (authProvider.user?.role != 'superadmin') {
                                        _showAccessDeniedDialog();
                                        return;
                                      }
                                      context.read<UsersProvider>().fetchUsers();
                                    });
                                  }

                                  void _showAccessDeniedDialog() {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        title: const Row(
                                          children: [
                                            Icon(Icons.lock, color: Colors.red, size: 28),
                                            SizedBox(width: 12),
                                            Text('غير مصرح'),
                                          ],
                                        ),
                                        content: const Text('هذه الصفحة متاحة فقط لمدير عام (Superadmin).'),
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
                                  Widget build(BuildContext context) {
                                    final theme = Theme.of(context);
                                    final authProvider = context.watch<AuthProvider>();

                                    if (authProvider.user?.role != 'superadmin') {
                                      return const SizedBox.shrink();
                                    }

                                    return Consumer<UsersProvider>(
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
                                                        'إدارة المستخدمين',
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
                                                            hintText: 'ابحث عن مستخدم (الاسم، رقم الهاتف)...',
                                                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                                                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                                                            suffixIcon: _searchController.text.isNotEmpty
                                                                ? IconButton(
                                                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                                                    onPressed: () {
                                                                      _searchController.clear();
                                                                      provider.searchUsers('');
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
                                                              provider.searchUsers(value);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const Spacer(),
                      if (provider.meta != null && provider.meta!['last_page'] != null && provider.meta!['last_page'] > 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: PaginationWidget(
                            currentPage: provider.meta!['current_page'] ?? 1,
                            lastPage: provider.meta!['last_page'] ?? 1,
                            onPrevious: () => provider.fetchUsers(page: (provider.meta!['current_page'] ?? 1) - 1),
                            onNext: () => provider.fetchUsers(page: (provider.meta!['current_page'] ?? 1) + 1),
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: () => _showUserDialog(context, null),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('إضافة مستخدم', style: TextStyle(fontSize: 12)),
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

                      // Users data table with stable loading
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

Widget _buildStableDataTable(BuildContext context, UsersProvider provider) {
  // Always display 13 rows to maintain fixed card height
  final fixedRowCount = 13;
  final actualUsers = provider.users;
  final paddedRows = <Map<String, String>>[];
  
  // Add actual user data
  for (int i = 0; i < actualUsers.length && i < fixedRowCount; i++) {
    final user = actualUsers[i];
    paddedRows.add({
      'الاسم_الكامل': user.fullName,
      'رقم_الهاتف': user.phonenumber,
      'الدور': user.roleArabic,
      'العنوان': user.address ?? '-',
    });
  }
  
  // Fill remaining slots with empty rows to maintain fixed height
  while (paddedRows.length < fixedRowCount) {
    paddedRows.add({
      'الاسم_الكامل': '',
      'رقم_الهاتف': '',
      'الدور': '',
      'العنوان': '',
    });
  }

  return Stack(
    children: [
      CustomDataTable(
        columns: const ['الاسم الكامل', 'رقم الهاتف', 'الدور', 'العنوان'],
        rows: paddedRows,
        isLoading: false, // Never show loading in table to prevent layout shifts
        onView: (index) => index < actualUsers.length ? _showUserDetailsDialog(context, actualUsers[index]) : null,
        onEdit: (index) => index < actualUsers.length ? _showUserDialog(context, actualUsers[index]) : null,
        onDelete: (index) => index < actualUsers.length ? _showDeleteConfirmDialog(context, actualUsers[index]) : null,
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

void _showUserDialog(BuildContext context, User? user) {
  showDialog(context: context, builder: (context) => UserFormDialog(user: user));
}

void _showUserDetailsDialog(BuildContext context, User user) {
  final theme = Theme.of(context);
  CustomDialog.show(
    context: context,
    title: 'تفاصيل المستخدم',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailRow(theme, 'الاسم الكامل', user.fullName),
        _detailRow(theme, 'رقم الهاتف', user.phonenumber),
        _detailRow(theme, 'الدور', user.roleArabic),
        _detailRow(theme, 'العنوان', user.address ?? '-'),
      ],
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
    ],
  );
}

Widget _detailRow(ThemeData theme, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    ),
  );
}

void _showDeleteConfirmDialog(BuildContext context, User user) {
  final provider = context.read<UsersProvider>();
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Row(
        children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('تأكيد الحذف')],
      ),
      content: Text('هل أنت متأكد من حذف المستخدم "${user.fullName}"؟\nلا يمكن التراجع عن هذا الإجراء.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            final success = await provider.deleteUser(user.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'تم حذف المستخدم بنجاح' : 'فشل حذف المستخدم'),
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

@override
void dispose() {
  _searchController.dispose();
  _debounce?.cancel();
  super.dispose();
}
}
