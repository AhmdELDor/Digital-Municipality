import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/explore_model.dart';

class ExploreDetailDialog extends StatelessWidget {
  final ExploreModel explore;

  const ExploreDetailDialog({super.key, required this.explore});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFmt = DateFormat('yyyy-MM-dd');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.explore, color: theme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    explore.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 32),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (explore.hasImages) ...[
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: explore.imagesUrl.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  explore.imagesUrl[index],
                                  height: 200,
                                  width: 300,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 200,
                                    width: 300,
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.image, size: 48, color: Colors.grey.shade400),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    _buildDetailRow(theme, 'الوصف', explore.desc),
                    _buildDetailRow(theme, 'النوع', explore.typeArabic),
                    _buildDetailRow(theme, 'الفئة', explore.category ?? '-'),
                    _buildDetailRow(theme, 'المواطن', explore.citizen?.fullName ?? '-'),
                    _buildDetailRow(theme, 'رقم الهاتف', explore.citizen?.phonenumber ?? '-'),
                    if (explore.startDate != null)
                      _buildDetailRow(theme, 'تاريخ البدء', dateFmt.format(explore.startDate!)),
                    if (explore.endDate != null)
                      _buildDetailRow(theme, 'تاريخ الانتهاء', dateFmt.format(explore.endDate!)),
                    _buildDetailRow(theme, 'الحالة', explore.statusArabic),
                    if (explore.createdAt != null)
                      _buildDetailRow(theme, 'تاريخ الإنشاء', dateFmt.format(explore.createdAt!)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
