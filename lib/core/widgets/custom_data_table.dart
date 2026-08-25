import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final Function(int)? onEdit;
  final Function(int)? onDelete;
  final Function(int)? onView;
  final Function(int rowIndex, String columnName)? onCellTap;
  final bool showActions;
  final bool isLoading;
  final String editLabel;
  final IconData editIcon;
  final Color? editColor;
  final Color? viewColor;
  final Color? deleteColor;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.onCellTap,
    this.showActions = true,
    this.isLoading = false,
    this.editLabel = 'تعديل',
    this.editIcon = Icons.edit,
    this.editColor,
    this.viewColor,
    this.deleteColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'لا توجد بيانات',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
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
            ...columns.map((column) => DataColumn(
              label: Text(
                column,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            )),
            if (showActions)
              const DataColumn(
                label: SizedBox.shrink(),
              ),
          ],
          rows: rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            
            return DataRow(
              cells: [
                ...columns.asMap().entries.map((colEntry) {
                  final colIndex = colEntry.key;
                  final column = colEntry.value;
                  final value = row[column.toLowerCase().replaceAll(' ', '_')] ?? '-';
                  
                  // First column gets an avatar
                  
                  return DataCell(
                    onCellTap != null
                        ? InkWell(
                            onTap: () => onCellTap!(index, column),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Text(
                                value.toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color: column == 'المستخدم' && value.toString().isNotEmpty ? Colors.blue : null,
                                  decoration: column == 'المستخدم' && value.toString().isNotEmpty ? TextDecoration.underline : null,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Text(
                              value.toString(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                  );
                }),
                if (showActions)
                  DataCell(
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18),
                      tooltip: 'الإجراءات',
                      itemBuilder: (context) => [
                        if (onView != null)
                          PopupMenuItem<String>(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility, size: 16, color: viewColor ?? Colors.blue),
                                const SizedBox(width: 8),
                                Text('عرض', style: TextStyle(fontSize: 12, color: viewColor ?? Colors.blue)),
                              ],
                            ),
                          ),
                        if (onEdit != null)
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(editIcon, size: 16, color: editColor ?? Colors.orange),
                                const SizedBox(width: 8),
                                Text(editLabel, style: TextStyle(fontSize: 12, color: editColor ?? Colors.orange)),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: deleteColor ?? Colors.red),
                                const SizedBox(width: 8),
                                Text('حذف', style: TextStyle(fontSize: 12, color: deleteColor ?? Colors.red)),
                              ],
                            ),
                          ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            onView?.call(index);
                            break;
                          case 'edit':
                            onEdit?.call(index);
                            break;
                          case 'delete':
                            onDelete?.call(index);
                            break;
                        }
                      },
                    ),
                  ),
              ],
            );
          }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.red,
    ];
    return colors[index % colors.length];
  }
}
