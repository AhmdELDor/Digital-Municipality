import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/circular_model.dart';
import '../providers/circulars_provider.dart';
import '../widgets/circular_form_dialog.dart';

class CircularsScreen extends StatefulWidget {
  const CircularsScreen({super.key});

  @override
  State<CircularsScreen> createState() => _CircularsScreenState();
}

class _CircularsScreenState extends State<CircularsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (!(auth.isAdmin || auth.isSuperAdmin)) {
        _showAccessDenied();
        return;
      }
      context.read<CircularsProvider>().fetchCirculars();
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

    return Consumer<CircularsProvider>(
      builder: (context, provider, _) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
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
                        _buildCircularsGrid(theme, provider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildHeader(ThemeData theme, CircularsProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Text(
            'إدارة التعاميم',
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
                hintText: 'ابحث عن تعميم...',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                        onPressed: () {
                          _searchController.clear();
                          provider.fetchCirculars(page: 1, search: '');
                          setState(() {});
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
                  provider.fetchCirculars(page: 1, search: value);
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
                onPrevious: () => provider.fetchCirculars(
                  page: (provider.meta!['current_page'] ?? 1) - 1,
                  search: _searchController.text,
                ),
                onNext: () => provider.fetchCirculars(
                  page: (provider.meta!['current_page'] ?? 1) + 1,
                  search: _searchController.text,
                ),
              ),
            ),
          ElevatedButton.icon(
            onPressed: () => _openCircularDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 12),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('إنشاء تعميم جديد', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularsGrid(ThemeData theme, CircularsProvider provider) {
    final meta = provider.meta;
    final circulars = provider.circulars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (meta != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'المجموع: ${meta['total'] ?? 0} تعميم',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey.shade300
                    : Colors.grey.shade700,
              ),
            ),
          ),
        if (provider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: CircularProgressIndicator(),
            ),
          )
        else if (circulars.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                children: [
                  Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد تعاميم',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 1200 ? 5 : width > 900 ? 4 : width > 600 ? 3 : 2;
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: circulars.length,
                itemBuilder: (context, index) {
                  final circular = circulars[index];
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: _buildCircularCard(theme, circular, provider),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildCircularCard(ThemeData theme, CircularModel circular, CircularsProvider provider) {
    return InkWell(
      onTap: () => context.go('/circulars/${circular.id}', extra: {'circular': circular}),
      child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with 3-dot menu
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: circular.imageUrl != null && circular.imageUrl!.isNotEmpty
                    ? Image.network(
                        circular.imageUrl!,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 110,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.article, size: 48, color: Colors.grey.shade400),
                        ),
                      )
                    : Container(
                        height: 110,
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.article_outlined,
                          size: 48,
                          color: theme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
              ),
              // 3-dot menu positioned on top right
              Positioned(
                top: 4,
                right: 4,
                child: AbsorbPointer(
                  absorbing: false,
                  child: Material(
                    color: Colors.transparent,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, size: 18, color: Colors.white),
                      ),
                      tooltip: 'الإجراءات',
                      padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'edit') {
                      _openCircularDialog(circular);
                    } else if (value == 'delete') {
                      _confirmDelete(circular, provider);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'edit',
                      height: 36,
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16, color: Colors.orange.shade700),
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
                          Icon(Icons.delete, size: 16, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text('حذف', style: TextStyle(fontSize: 12, color: Colors.red.shade700)),
                        ],
                      ),
                    ),
                  ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circular.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Content text with fixed height and scroll
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        circular.content ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildErrorBanner(CircularsProvider provider) {
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
          Expanded(
            child: Text(
              provider.error!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          IconButton(
            onPressed: () => provider.clearError(),
            icon: const Icon(Icons.close),
            color: Colors.red.shade700,
          ),
        ],
      ),
    );
  }

  void _openCircularDialog([CircularModel? circular]) {
    final currentContext = context;
    showDialog(
      context: context,
      builder: (_) => CircularFormDialog(circular: circular),
    ).then((result) {
      if (result == true && currentContext.mounted) {
        currentContext.read<CircularsProvider>().fetchCirculars(
              page: currentContext.read<CircularsProvider>().currentPage,
              search: _searchController.text,
            );
      }
    });
  }

  Future<void> _confirmDelete(CircularModel circular, CircularsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف التعميم "${circular.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.deleteCircular(circular.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'تم حذف التعميم بنجاح' : 'حدث خطأ أثناء الحذف'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _showAccessDenied() {
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
        content: const Text('هذه الصفحة متاحة فقط لمدير أو مدير عام.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
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
