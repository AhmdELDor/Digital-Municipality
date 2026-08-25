import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool canManage;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.canManage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (service.priority)
                    Icon(Icons.star, size: 16, color: theme.colorScheme.primary),
                  const Spacer(),
                  if (canManage)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 18),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('تعديل')]),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(children: [Icon(Icons.delete_outline, size: 16, color: Colors.red), SizedBox(width: 8), Text('حذف')]),
                          ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit?.call();
                        } else if (value == 'delete') {
                          onDelete?.call();
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 4),
              _buildLogo(context),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  service.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Center(
                child: Text(
                  service.phoneNumber,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontSize: 11.5),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    side: BorderSide(color: theme.colorScheme.primary, width: 1.2),
                    minimumSize: const Size(40, 30),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Icon(Icons.call_outlined, size: 18, color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.business, size: 40, color: theme.colorScheme.primary),
    );

    if (service.logo != null && service.logo!.isNotEmpty) {
      return Center(
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: service.logo!,
            height: 64,
            width: 64,
            fit: BoxFit.cover,
            placeholder: (_, __) => placeholder,
            errorWidget: (_, __, ___) => placeholder,
          ),
        ),
      );
    }

    // Support local file preview when editing newly created item if needed
    if (service.logo != null && File(service.logo!).existsSync()) {
      return Center(
        child: ClipOval(
          child: Image.file(
            File(service.logo!),
            height: 64,
            width: 64,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Center(child: placeholder);
  }
}
