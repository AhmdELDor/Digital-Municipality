import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/pagination_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/project_model.dart';
import '../providers/projects_provider.dart';
import '../widgets/project_card.dart';
import '../widgets/project_form_dialog.dart';

class ProjectsScreen extends StatefulWidget {
  final bool openCreateOnLoad;

  const ProjectsScreen({super.key, this.openCreateOnLoad = false});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProjectsProvider>();
      provider.fetchProjects();
      if (widget.openCreateOnLoad) {
        _showProjectDialog(context, null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final canManage = auth.user?.role == 'admin' || auth.user?.role == 'superadmin';

    return Consumer<ProjectsProvider>(
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
                        'المشاريع',
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
                            hintText: 'ابحث عن مشروع (العنوان)...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.searchProjects('');
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
                              provider.searchProjects(value);
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
                            onPrevious: () => provider.fetchProjects(page: (provider.meta!['current_page'] ?? 1) - 1),
                            onNext: () => provider.fetchProjects(page: (provider.meta!['current_page'] ?? 1) + 1),
                          ),
                        ),
                      if (canManage)
                        ElevatedButton.icon(
                          onPressed: () => _showProjectDialog(context, null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('إضافة مشروع', style: TextStyle(fontSize: 12)),
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
                        _buildGrid(context, provider.projects, provider.isLoading, canManage),
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

  Widget _buildGrid(BuildContext context, List<ProjectModel> projects, bool isLoading, bool canManage) {
    final theme = Theme.of(context);
    if (!isLoading && projects.isEmpty) {
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
            Text('لا توجد مشاريع حالياً', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('أضف أول مشروع لبدء الإدارة', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
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
          itemCount: projects.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final project = projects[index];
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: ProjectCard(
                  project: project,
                  onEdit: canManage ? () => _showProjectDialog(context, project) : null,
                  onDelete: canManage ? () => _showDeleteDialog(context, project) : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showProjectDialog(BuildContext context, ProjectModel? project) {
    showDialog(context: context, builder: (_) => ProjectFormDialog(project: project));
  }

  void _showDeleteDialog(BuildContext context, ProjectModel project) {
    final provider = context.read<ProjectsProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [Icon(Icons.warning, color: Colors.orange, size: 28), SizedBox(width: 12), Text('تأكيد الحذف')],
        ),
        content: Text('هل أنت متأكد من حذف مشروع "${project.title}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final success = await provider.deleteProject(project.id);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'تم حذف المشروع' : 'فشل حذف المشروع'),
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
