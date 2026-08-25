import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/project_model.dart';

class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _currentImageIndex = 0;

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
    final images = widget.project.images ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'رجوع',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Images Carousel
            if (images.isNotEmpty)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: images.map((imageUrl) {
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: Icon(Icons.work_outline, size: 48, color: Colors.grey.shade400),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.work_outline, size: 48, color: theme.colorScheme.primary),
              ),
            const SizedBox(height: 16),
            // Title and Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.project.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.project.status != null && widget.project.status!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.project.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getStatusColor(widget.project.status).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusInArabic(widget.project.status),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(widget.project.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              widget.project.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            // Details
            if (widget.project.category != null && widget.project.category!.isNotEmpty)
              _buildDetailRow(Icons.category, 'الفئة', widget.project.category!, theme),
            if (widget.project.location != null && widget.project.location!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildDetailRow(Icons.place, 'الموقع', widget.project.location!, theme),
            ],
            if (widget.project.startDate != null && widget.project.startDate!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildDetailRow(Icons.event, 'تاريخ البدء', widget.project.startDate!, theme),
            ],
            if (widget.project.endDate != null && widget.project.endDate!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildDetailRow(Icons.event_available, 'تاريخ الانتهاء', widget.project.endDate!, theme),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
