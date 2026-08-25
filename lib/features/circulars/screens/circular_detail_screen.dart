import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/circular_model.dart';

class CircularDetailScreen extends StatelessWidget {
  final CircularModel? circular;

  const CircularDetailScreen({super.key, this.circular});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = circular;

    if (item == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('لا توجد بيانات للتعميم', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/circulars'),
                child: const Text('العودة للقائمة'),
              ),
            ],
          ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.go('/circulars'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPostCard(theme, item),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(ThemeData theme, CircularModel item) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.campaign, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _metaText(
                            theme,
                            Icons.calendar_today,
                            item.createdAt != null ? _formatDate(item.createdAt!) : 'غير محدد',
                          ),
                          if (item.publishedAt != null)
                            _metaText(
                              theme,
                              Icons.publish,
                              'تاريخ النشر: ${_formatDate(item.publishedAt!)}',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    item.content?.trim().isNotEmpty == true ? item.content! : 'لا يوجد محتوى متاح',
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              width: 220,
                              height: 220,
                              errorBuilder: (_, __, ___) => _imagePlaceholder(theme, square: true, size: 220),
                            )
                          : _imagePlaceholder(theme, square: true, size: 220),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder(ThemeData theme, {bool square = false, double size = 200}) {
    return Container(
      color: theme.colorScheme.primary.withOpacity(0.05),
      height: square ? size : 200,
      width: square ? size : double.infinity,
      alignment: Alignment.center,
      child: Icon(Icons.image, color: theme.colorScheme.primary, size: 32),
    );
  }

  Widget _metaText(ThemeData theme, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

}
