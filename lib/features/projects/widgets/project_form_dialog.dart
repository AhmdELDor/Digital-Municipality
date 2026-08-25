import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../models/project_model.dart';
import '../providers/projects_provider.dart';

class ProjectFormDialog extends StatefulWidget {
  final ProjectModel? project;

  const ProjectFormDialog({super.key, this.project});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  bool _isSubmitting = false;
  List<File> _images = [];
  String? _selectedStatus;
  final Map<String, String> _statusOptions = const {
    'pending': 'قيد الانتظار',
    'inprogress': 'قيد التنفيذ',
    'finished': 'مكتمل',
    'onhold': 'متوقف',
  };
  final List<String> _categoryOptions = const [
    'البنية التحتية',
    'النظافة',
    'السلامة العامة',
    'الصحة',
    'التعليم',
    'الرياضة والثقافة',
    'التحول الرقمي',
    'النقل والمواصلات',
    'الطاقة والبيئة',
    'السياحة',
    'أخرى',
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    if (p != null) {
      _titleController.text = p.title;
      _descriptionController.text = p.description;
      if (p.category != null && _categoryOptions.contains(p.category)) {
        _selectedCategory = p.category;
      } else {
        _selectedCategory = p.category != null ? 'أخرى' : null;
        _categoryController.text = p.category ?? '';
      }
      _locationController.text = p.location ?? '';
      _startDateController.text = p.startDate ?? '';
      _endDateController.text = p.endDate ?? '';
      _selectedStatus = p.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.project != null;

    return CustomDialog(
      title: isEdit ? 'تعديل مشروع' : 'إضافة مشروع',
      width: 720,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextField(_titleController, 'عنوان المشروع *', Icons.title, validator: _required)),
                ],
              ),
              const SizedBox(height: 12),
              _buildMultilineField(_descriptionController, 'الوصف *', Icons.description, validator: _required),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'الفئة',
                        labelStyle: _labelTextStyle(context),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items: _categoryOptions
                          .map((c) => DropdownMenuItem<String>(
                                value: c,
                                child: Text(c, style: _fieldTextStyle(context)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          if (value != 'أخرى') {
                            _categoryController.clear();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(_locationController, 'الموقع', Icons.place)),
                ],
              ),
              if (_selectedCategory == 'أخرى') ...[
                const SizedBox(height: 12),
                _buildTextField(_categoryController, 'فئة مخصصة', Icons.edit),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'الحالة *',
                  labelStyle: _labelTextStyle(context),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.flag),
                ),
                items: _statusOptions.entries
                    .map((entry) => DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value, style: _fieldTextStyle(context)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) => value == null ? 'الرجاء اختيار الحالة' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildDateField(_startDateController, 'تاريخ البدء', Icons.event)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDateField(_endDateController, 'تاريخ الانتهاء', Icons.event_available)),
                ],
              ),
              const SizedBox(height: 12),
              _buildImagesPicker(theme),
            ],
          ),
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
            textStyle: const TextStyle(fontSize: 12),
          ),
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text(isEdit ? 'حفظ' : 'إضافة', style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      style: _fieldTextStyle(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _labelTextStyle(context),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: validator,
    );
  }

  Widget _buildMultilineField(TextEditingController controller, String label, IconData icon, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      style: _fieldTextStyle(context),
      maxLines: 4,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _labelTextStyle(context),
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Icon(icon),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: validator,
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: _fieldTextStyle(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _labelTextStyle(context),
        prefixIcon: Icon(icon),
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () => _pickDate(controller),
    );
  }

  Widget _buildImagesPicker(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('صور المشروع (اختياري)', style: _fieldTextStyle(context)?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _pickImages,
              icon: const Icon(Icons.upload),
              label: const Text('رفع الصور'),
            ),
            const SizedBox(width: 10),
            if (_images.isNotEmpty)
              Text('${_images.length} صور مختارة', style: _labelTextStyle(context)),
          ],
        ),
        const SizedBox(height: 8),
        if (_images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _images
                .map((file) => Chip(
                      label: Text(
                        file.path.split(Platform.pathSeparator).last,
                        style: _labelTextStyle(context),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: _isSubmitting
                          ? null
                          : () {
                              setState(() {
                                _images.remove(file);
                              });
                            },
                    ))
                .toList(),
          ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _images = result.files
            .where((f) => f.path != null)
            .map((f) => File(f.path!))
            .toList();
      });
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    if (selected != null) {
      controller.text = _formatDate(selected);
    }
  }

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Basic end date check
    if (_startDateController.text.isNotEmpty && _endDateController.text.isNotEmpty) {
      final start = DateTime.tryParse(_startDateController.text);
      final end = DateTime.tryParse(_endDateController.text);
      if (start != null && end != null && end.isBefore(start)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء')),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);
    final provider = context.read<ProjectsProvider>();
    final isEdit = widget.project != null;

    final success = isEdit
        ? await provider.updateProject(
            id: widget.project!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _resolveCategory(),
            location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            startDate: _startDateController.text.trim().isEmpty ? null : _startDateController.text.trim(),
            endDate: _endDateController.text.trim().isEmpty ? null : _endDateController.text.trim(),
            status: _selectedStatus,
            images: _images.isEmpty ? null : _images,
          )
        : await provider.createProject(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _resolveCategory(),
            location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            startDate: _startDateController.text.trim().isEmpty ? null : _startDateController.text.trim(),
            endDate: _endDateController.text.trim().isEmpty ? null : _endDateController.text.trim(),
            status: _selectedStatus,
            images: _images.isEmpty ? null : _images,
          );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'تم تحديث المشروع' : 'تم إضافة المشروع'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'حدث خطأ'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String? _resolveCategory() {
    final custom = _categoryController.text.trim();
    if (_selectedCategory == null) {
      return custom.isEmpty ? null : custom;
    }
    if (_selectedCategory == 'أخرى') {
      return custom.isEmpty ? null : custom;
    }
    return _selectedCategory;
  }

  TextStyle? _fieldTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13);
  }

  TextStyle? _labelTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12);
  }
}
