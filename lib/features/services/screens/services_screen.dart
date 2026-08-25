import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/call_utils.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/services_provider.dart';
import '../models/service_model.dart';
import '../widgets/service_card.dart';
import '../widgets/service_form_dialog.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesProvider>().fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final canManageServices = authProvider.user?.role == 'admin' || authProvider.user?.role == 'superadmin';

    return Consumer<ServicesProvider>(
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
                        'الخدمات',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 420,
                        height: 34,
                        child: TextField(
                          controller: _searchController,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن خدمة (الاسم)...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.searchServices('');
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
                              provider.searchServices(value);
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
                            lastPage: provider.meta!['last_page'] ?? (provider.meta!['total_pages'] ?? 1),
                            onPrevious: () => provider.fetchServices(page: (provider.meta!['current_page'] ?? 1) - 1),
                            onNext: () => provider.fetchServices(page: (provider.meta!['current_page'] ?? 1) + 1),
                          ),
                        ),
                      if (canManageServices)
                        ElevatedButton.icon(
                          onPressed: () => _showServiceDialog(context, null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('إضافة خدمة', style: TextStyle(fontSize: 12)),
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
                        _buildServicesGrid(context, provider.services, provider.isLoading, canManageServices),
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

  Widget _buildServicesGrid(BuildContext context, List<ServiceModel> services, bool isLoading, bool canManage) {
    final theme = Theme.of(context);
    if (!isLoading && services.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('لا توجد خدمات حالياً', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('أضف أول خدمة لبدء إدارة الخدمات', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 4;
        if (width > 1700) crossAxisCount = 6;
        else if (width > 1400) crossAxisCount = 5;

        return GridView.builder(
          itemCount: services.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: ServiceCard(
                  service: service,
                  onTap: () => _showCallOptions(context, service),
                  onEdit: canManage ? () => _showServiceDialog(context, service) : null,
                  onDelete: canManage ? () => _showDeleteConfirmDialog(context, service) : null,
                  canManage: canManage,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showServiceDialog(BuildContext context, ServiceModel? service) {
    showDialog(context: context, builder: (_) => ServiceFormDialog(service: service));
  }

  void _showDeleteConfirmDialog(BuildContext context, ServiceModel service) {
    final provider = context.read<ServicesProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('تأكيد الحذف')],
        ),
        content: Text('هل أنت متأكد من حذف خدمة "${service.name}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.deleteService(service.id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'تم حذف الخدمة' : 'فشل حذف الخدمة'),
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

  void _showCallOptions(BuildContext context, ServiceModel service) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetContext) {
        final sheetTheme = Theme.of(sheetContext);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('هل تريد الاتصال بخدمة ${service.name}?', style: sheetTheme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('رقم الهاتف: ${service.phoneNumber}', style: sheetTheme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (Navigator.of(sheetContext).canPop()) {
                          Navigator.of(sheetContext).pop();
                        }
                        await _executeCall(() => CallUtils.launchWhatsApp(service.phoneNumber), 'واتساب');
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('واتساب'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (Navigator.of(sheetContext).canPop()) {
                          Navigator.of(sheetContext).pop();
                        }
                        await _executeCall(() => CallUtils.launchSMS(service.phoneNumber), 'رسالة نصية');
                      },
                      icon: const Icon(Icons.sms),
                      label: const Text('رسالة نصية'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  if (Navigator.of(sheetContext).canPop()) {
                    Navigator.of(sheetContext).pop();
                  }
                  await _executeCall(() => CallUtils.launchPhone(service.phoneNumber), 'اتصال مباشر');
                },
                icon: const Icon(Icons.call),
                label: const Text('اتصال مباشر'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _executeCall(Future<bool> Function() action, String channel) async {
    try {
      final success = await action();
      _showCallResult(success, channel);
    } catch (_) {
      _showCallResult(false, channel);
    }
  }

  void _showCallResult(bool success, String channel) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'تم فتح $channel' : 'تعذر فتح $channel'),
        backgroundColor: success ? Colors.green : Colors.red,
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
