import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    this.onEdit,
    this.onDelete,
  });

  String _getStatusInArabic(String? status) {
    const statusMap = {
      'pending': 'قيد الانتظار',
      'inprogress': 'قيد التنفيذ',
      'finished': 'مكتمل',
      'onhold': 'متوقف',
    };
    return statusMap[status] ?? status ?? '';
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'inprogress':
        return Colors.blue;
      case 'finished':
        return Colors.green;
      case 'onhold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push('/projects/${project.id}', extra: {'project': project}),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              _buildCover(theme),
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
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, size: 18, color: Colors.white),
                      ),
                      tooltip: 'الإجراءات',
                      padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    if (onEdit != null)
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
                    if (onDelete != null)
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
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          project.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (project.status != null && project.status!.isNotEmpty) ...[ 
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(project.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(project.status).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getStatusInArabic(project.status),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              color: _getStatusColor(project.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description - one line
                  Text(
                    project.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Location
                  if (project.location != null && project.location!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.place, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            project.location!,
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  // Created Date
                  if (project.createdAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _formatDate(project.startDate),
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )
      ],
      ),
    ),
    );
  }

  Widget _buildCover(ThemeData theme) {
    final cover = project.coverImage;
    if (cover == null || cover.isEmpty) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.06),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.work_outline, color: theme.colorScheme.primary),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        cover,
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 110,
          color: theme.colorScheme.primary.withOpacity(0.06),
          alignment: Alignment.center,
          child: Icon(Icons.broken_image, color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return date;
    }
  }
}
