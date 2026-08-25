import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../models/circular_model.dart';
import '../providers/circulars_provider.dart';

class CircularFormDialog extends StatefulWidget {
  final CircularModel? circular;

  const CircularFormDialog({super.key, this.circular});

  @override
  State<CircularFormDialog> createState() => _CircularFormDialogState();
}

class _CircularFormDialogState extends State<CircularFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPublished = false;
  bool _isSubmitting = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.circular != null) {
      _titleController.text = widget.circular!.title;
      _contentController.text = widget.circular!.content ?? '';
      _isPublished = widget.circular!.isPublished;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.circular != null;

    return CustomDialog(
      title: isEditing ? 'تعديل التعميم' : 'إنشاء تعميم جديد',
      width: 600,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                style: _fieldTextStyle(context),
                decoration: InputDecoration(
                  labelText: 'عنوان التعميم *',
                  labelStyle: _labelTextStyle(context),
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'أدخل عنوان التعميم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                style: _fieldTextStyle(context),
                decoration: InputDecoration(
                  labelText: 'المحتوى *',
                  labelStyle: _labelTextStyle(context),
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'أدخل محتوى التعميم' : null,
              ),
              const SizedBox(height: 16),
              _buildImagePicker(context, theme),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('نشر التعميم'),
                subtitle: Text(
                  _isPublished ? 'التعميم منشور للعامة' : 'التعميم غير منشور',
                  style: _labelTextStyle(context),
                ),
                value: _isPublished,
                onChanged: (value) => setState(() => _isPublished = value),
                activeColor: theme.primaryColor,
              ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(isEditing ? 'حفظ التعديلات' : 'إنشاء التعميم'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final provider = context.read<CircularsProvider>();
    final bool success;

    if (widget.circular != null) {
      success = await provider.updateCircular(
        id: widget.circular!.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        image: _imageFile,
        isPublished: _isPublished,
      );
    } else {
      success = await provider.createCircular(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        image: _imageFile,
        isPublished: _isPublished,
      );
    }

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.circular != null ? 'تم تحديث التعميم' : 'تم إنشاء التعميم'),
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Widget _buildImagePicker(BuildContext context, ThemeData theme) {
    final hasExisting = widget.circular?.imageUrl != null && widget.circular!.imageUrl!.isNotEmpty;
    final hasLocalSelection = _imageFile != null && _imageFile!.existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('صورة التعميم (اختياري)', style: _fieldTextStyle(context)?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _pickImage,
              icon: const Icon(Icons.upload),
              label: const Text('رفع الصورة'),
            ),
            const SizedBox(width: 12),
            if (_imageFile != null)
              Flexible(
                child: Text(
                  _imageFile!.path.split(Platform.pathSeparator).last,
                  style: _labelTextStyle(context),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else if (hasExisting)
              Flexible(
                child: Text(
                  'سيتم الاحتفاظ بالصورة الحالية',
                  style: _labelTextStyle(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (hasLocalSelection)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _imageFile!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else if (hasExisting)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.circular!.imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder(theme),
            ),
          )
        else
          _imagePlaceholder(theme),
      ],
    );
  }

  Widget _imagePlaceholder(ThemeData theme) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image, color: theme.colorScheme.primary),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        setState(() {
          _imageFile = File(path);
        });
      }
    }
  }

  TextStyle? _fieldTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13);
  }

  TextStyle? _labelTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12);
  }
}
