import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../models/service_model.dart';
import '../providers/services_provider.dart';

class ServiceFormDialog extends StatefulWidget {
  final ServiceModel? service;

  const ServiceFormDialog({super.key, this.service});

  @override
  State<ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _priority = false;
  String? _logoPath;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nameController.text = widget.service!.name;
      _phoneController.text = widget.service!.phoneNumber;
      _priority = widget.service!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.service != null;
    final theme = Theme.of(context);

    return CustomDialog(
      title: isEditMode ? 'تعديل خدمة' : 'إضافة خدمة',
      width: 600,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم الخدمة *',
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم الخدمة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            PhoneUtils.buildPhoneTextField(
              controller: _phoneController,
              label: 'رقم الهاتف',
              hint: '+961xxxxxxxx',
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _priority,
              title: const Text('عرض هذه الخدمة ضمن الأولوية'),
              subtitle: const Text('الخدمات ذات الأولوية تظهر أولاً في القائمة'),
              onChanged: (value) => setState(() => _priority = value),
            ),
            const SizedBox(height: 12),
            _buildLogoPicker(theme),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
              : Text(isEditMode ? 'حفظ' : 'إضافة'),
        ),
      ],
    );
  }

  Widget _buildLogoPicker(ThemeData theme) {
    final hasExistingLogo = widget.service?.logo != null && widget.service!.logo!.isNotEmpty;
    final hasLocalSelection = _logoPath != null && File(_logoPath!).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('شعار الخدمة (اختياري)', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _pickLogo,
              icon: const Icon(Icons.upload),
              label: const Text('رفع الشعار'),
            ),
            const SizedBox(width: 12),
            if (_logoPath != null)
              Text(
                _logoPath!.split(Platform.pathSeparator).last,
                style: theme.textTheme.bodySmall,
              )
            else if (hasExistingLogo)
              Text('سيتم الاحتفاظ بالشعار الحالي', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 12),
        if (hasLocalSelection)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(_logoPath!),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          )
        else if (hasExistingLogo)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.service!.logo!,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.broken_image, color: theme.colorScheme.primary),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _logoPath = result.files.single.path;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final provider = context.read<ServicesProvider>();
    final isEditMode = widget.service != null;

    bool success;
    if (isEditMode) {
      success = await provider.updateService(
        id: widget.service!.id,
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        priority: _priority,
        logoPath: _logoPath,
      );
    } else {
      success = await provider.createService(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        priority: _priority,
        logoPath: _logoPath,
      );
    }

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode ? 'تم تحديث الخدمة بنجاح' : 'تم إضافة الخدمة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'حدث خطأ غير متوقع'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
