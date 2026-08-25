import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/request_form_model.dart';
import '../providers/user_requests_provider.dart';

class SubmitRequestDialog extends StatefulWidget {
  final RequestFormModel requestForm;

  const SubmitRequestDialog({
    super.key,
    required this.requestForm,
  });

  @override
  State<SubmitRequestDialog> createState() => _SubmitRequestDialogState();
}

class _SubmitRequestDialogState extends State<SubmitRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, List<File>> _attachments = {}; // Changed to Map with field names as keys
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for text inputs
    for (var field in widget.requestForm.fields) {
      if (field.type == 'text' ||
          field.type == 'textarea' ||
          field.type == 'number' ||
          field.type == 'email') {
        _controllers[field.name] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickFiles(String fieldName, bool multiple) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: multiple,
        type: FileType.custom,
        allowedExtensions: widget.requestForm.allowedFileTypes,
      );

      if (result != null) {
        setState(() {
          if (!_attachments.containsKey(fieldName)) {
            _attachments[fieldName] = [];
          }
          if (multiple) {
            _attachments[fieldName]!.addAll(result.paths.map((path) => File(path!)));
          } else {
            // For single file, replace any existing file
            _attachments[fieldName] = [File(result.paths.first!)];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في اختيار الملفات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeAttachment(String fieldName, int index) {
    setState(() {
      _attachments[fieldName]?.removeAt(index);
      if (_attachments[fieldName]?.isEmpty ?? false) {
        _attachments.remove(fieldName);
      }
    });
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Collect form data
    for (var field in widget.requestForm.fields) {
      if (_controllers.containsKey(field.name)) {
        final value = _controllers[field.name]!.text;
        if (field.type == 'number') {
          _formData[field.name] = value.isNotEmpty ? num.parse(value) : null;
        } else {
          _formData[field.name] = value.isNotEmpty ? value : null;
        }
      }
    }

    setState(() => _isLoading = true);

    final provider = context.read<UserRequestsProvider>();
    final result = await provider.submitRequest(
      requestFormId: widget.requestForm.id,
      data: _formData,
      attachments: _attachments.isNotEmpty ? _attachments : null,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result != null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال الطلب بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'فشل في إرسال الطلب'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment, color: theme.primaryColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تقديم طلب جديد',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.requestForm.title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Description
                      if (widget.requestForm.description != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.requestForm.description!,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Fee Information
                      if (widget.requestForm.feeAmount > 0) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.payment, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'الرسوم المطلوبة: ${widget.requestForm.feeAmount.toStringAsFixed(0)} ل.ل',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Dynamic Form Fields (excluding file type fields)
                      ...widget.requestForm.fields.where((field) => field.type != 'file').map((field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildFormField(field),
                        );
                      }).toList(),

                      // File Attachments Section
                      const SizedBox(height: 8),
                      Text(
                        'المرفقات',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Display file fields with attachments_required names
                      if (widget.requestForm.fields.any((field) => field.type == 'file')) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.attachment, color: Colors.amber, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'المستندات المطلوبة:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...() {
                                final fileFields = widget.requestForm.fields.where((f) => f.type == 'file').toList();
                                return fileFields.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final field = entry.value;
                                  // Use attachments_required name if available, otherwise use field label
                                  final displayName = widget.requestForm.attachmentsRequired != null &&
                                          index < widget.requestForm.attachmentsRequired!.length
                                      ? widget.requestForm.attachmentsRequired![index]
                                      : field.label;
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          field.required ? Icons.check_circle : Icons.check_circle_outline,
                                          size: 14,
                                          color: field.required ? Colors.amber : Colors.amber.withOpacity(0.6),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            displayName + (field.required ? ' *' : ' (اختياري)'),
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList();
                              }(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ] else if (widget.requestForm.attachmentsRequired!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.attachment, color: Colors.amber, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'المستندات المطلوبة:',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...widget.requestForm.attachmentsRequired!.map((doc) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline, size: 14, color: Colors.amber),
                                      const SizedBox(width: 8),
                                        Text(doc, style: const TextStyle(fontSize: 10)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Upload buttons for each file field
                      ...() {
                        final fileFields = widget.requestForm.fields.where((f) => f.type == 'file').toList();
                        return fileFields.asMap().entries.map((entry) {
                          final index = entry.key;
                          final field = entry.value;
                          final displayName = widget.requestForm.attachmentsRequired != null &&
                                  index < widget.requestForm.attachmentsRequired!.length
                              ? widget.requestForm.attachmentsRequired![index]
                              : field.label;
                          final fieldFiles = _attachments[field.name] ?? [];
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _isLoading ? null : () => _pickFiles(field.name, field.multiple ?? false),
                                  icon: const Icon(Icons.upload_file, size: 18),
                                  label: Text(
                                    '$displayName${field.required ? ' *' : ''}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                                
                                // Show uploaded files for this field
                                if (fieldFiles.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.grey[850] : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: theme.dividerColor),
                                    ),
                                    child: Column(
                                      children: fieldFiles.asMap().entries.map((fileEntry) {
                                        final fileIndex = fileEntry.key;
                                        final file = fileEntry.value;
                                        final fileName = file.path.split(Platform.pathSeparator).last;
                                        final fileSize = file.lengthSync();
                                        final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.insert_drive_file, size: 20),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      fileName,
                                                      style: const TextStyle(fontSize: 10),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      '$fileSizeMB MB',
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close, size: 18),
                                                color: Colors.red,
                                                onPressed: () => _removeAttachment(field.name, fileIndex),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList();
                      }(),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(top: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('إلغاء', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submitRequest,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send, size: 16),
                    label: Text(_isLoading ? 'جاري الإرسال...' : 'إرسال الطلب', style: const TextStyle(fontSize: 10)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(FormField field) {
    switch (field.type) {
      case 'text':
      case 'email':
        return TextFormField(
          controller: _controllers[field.name],
          decoration: InputDecoration(
            labelText: '${field.label}${field.required ? ' *' : ''}',
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
            labelStyle: const TextStyle(fontSize: 11),
          ),
          style: const TextStyle(fontSize: 11),
          keyboardType: field.type == 'email' ? TextInputType.emailAddress : TextInputType.text,
          validator: field.required
              ? (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null
              : null,
        );

      case 'textarea':
        return TextFormField(
          controller: _controllers[field.name],
          decoration: InputDecoration(
            labelText: '${field.label}${field.required ? ' *' : ''}',
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
            labelStyle: const TextStyle(fontSize: 11),
          ),
          style: const TextStyle(fontSize: 11),
          maxLines: 4,
          validator: field.required
              ? (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null
              : null,
        );

      case 'number':
        return TextFormField(
          controller: _controllers[field.name],
          decoration: InputDecoration(
            labelText: '${field.label}${field.required ? ' *' : ''}',
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
            labelStyle: const TextStyle(fontSize: 11),
          ),
          style: const TextStyle(fontSize: 11),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          validator: field.required
              ? (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null
              : null,
        );

      case 'date':
        return TextFormField(
          decoration: InputDecoration(
            labelText: '${field.label}${field.required ? ' *' : ''}',
            hintText: field.placeholder ?? 'اختر تاريخ',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today, size: 18),
            labelStyle: const TextStyle(fontSize: 11),
          ),
          style: const TextStyle(fontSize: 11),
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              _formData[field.name] = DateFormat('yyyy-MM-dd').format(date);
              setState(() {});
            }
          },
          controller: TextEditingController(
            text: _formData[field.name] != null
                ? DateFormat('dd/MM/yyyy').format(DateTime.parse(_formData[field.name]))
                : '',
          ),
          validator: field.required
              ? (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null
              : null,
        );

      case 'select':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '${field.label}${field.required ? ' *' : ''}',
            border: const OutlineInputBorder(),
            labelStyle: const TextStyle(fontSize: 11),
          ),
          style: const TextStyle(fontSize: 11),
          value: _formData[field.name],
          items: field.options
              ?.map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option, style: const TextStyle(fontSize: 11)),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _formData[field.name] = value;
            });
          },
          validator: field.required
              ? (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null
              : null,
        );

      case 'radio':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...?field.options?.map((option) {
              return RadioListTile<String>(
                title: Text(option, style: const TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
                value: option,
                groupValue: _formData[field.name],
                onChanged: (value) {
                  setState(() {
                    _formData[field.name] = value;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
            if (field.required && _formData[field.name] == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'هذا الحقل مطلوب',
                  style: TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        );

      case 'checkbox':
        _formData[field.name] ??= <String>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${field.label}${field.required ? ' *' : ''}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...?field.options?.map((option) {
              return CheckboxListTile(
                title: Text(option, style: const TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
                value: (_formData[field.name] as List).contains(option),
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      (_formData[field.name] as List).add(option);
                    } else {
                      (_formData[field.name] as List).remove(option);
                    }
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
            if (field.required && (_formData[field.name] as List).isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'هذا الحقل مطلوب',
                  style: TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
