import 'package:flutter/material.dart' hide FormField;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/request_form_model.dart';
import '../providers/request_forms_provider.dart';

class RequestFormDialog extends StatefulWidget {
  final RequestFormModel? requestForm;

  const RequestFormDialog({super.key, this.requestForm});

  @override
  State<RequestFormDialog> createState() => _RequestFormDialogState();
}

class _RequestFormDialogState extends State<RequestFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _versionController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _feeAmountController = TextEditingController();
  
  String _selectedStatus = 'active';
  List<FormField> _fields = [];
  List<String> _attachmentsRequired = [];
  List<String> _allowedFileTypes = ['pdf', 'jpg', 'png', 'doc', 'docx'];
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.requestForm != null) {
      _titleController.text = widget.requestForm!.title;
      _descriptionController.text = widget.requestForm!.description ?? '';
      _versionController.text = widget.requestForm!.version;
      _instructionsController.text = widget.requestForm!.instructions ?? '';
      _feeAmountController.text = widget.requestForm!.feeAmount.toString();
      _selectedStatus = widget.requestForm!.status;
      _fields = List.from(widget.requestForm!.fields);
      _attachmentsRequired = widget.requestForm!.attachmentsRequired ?? [];
      _allowedFileTypes = widget.requestForm!.allowedFileTypes ?? ['pdf', 'jpg', 'png', 'doc', 'docx'];
    } else {
      _versionController.text = '1.0';
      _feeAmountController.text = '0.00';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _versionController.dispose();
    _instructionsController.dispose();
    _feeAmountController.dispose();
    super.dispose();
  }

  void _addField() {
    showDialog(
      context: context,
      builder: (context) => _FieldBuilderDialog(
        onAdd: (field) {
          setState(() {
            _fields.add(field);
          });
        },
      ),
    );
  }

  void _editField(int index) {
    showDialog(
      context: context,
      builder: (context) => _FieldBuilderDialog(
        field: _fields[index],
        onAdd: (field) {
          setState(() {
            _fields[index] = field;
          });
        },
      ),
    );
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب إضافة حقل واحد على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<RequestFormsProvider>();
    
    final formData = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'fields': _fields.map((f) => f.toJson()).toList(),
      'version': _versionController.text.trim(),
      'status': _selectedStatus,
      'instructions': _instructionsController.text.trim(),
      'attachments_required': _attachmentsRequired,
      'fee_amount': double.parse(_feeAmountController.text),
      'allowed_file_types': _allowedFileTypes,
    };

    bool success;
    if (widget.requestForm != null) {
      success = await provider.updateRequestForm(widget.requestForm!.id, formData);
    } else {
      success = await provider.createRequestForm(formData);
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.requestForm != null ? 'تم تحديث النموذج بنجاح' : 'تم إنشاء النموذج بنجاح'),
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : theme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.requestForm != null ? Icons.edit : Icons.add,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.requestForm != null ? 'تعديل نموذج المعاملة' : 'إنشاء نموذج معاملة جديد',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'عنوان النموذج *',
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال عنوان النموذج';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'الوصف',
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _versionController,
                              decoration: const InputDecoration(
                                labelText: 'الإصدار *',
                                prefixIcon: Icon(Icons.history),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال رقم الإصدار';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'الحالة *',
                                prefixIcon: Icon(Icons.toggle_on),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'active', child: Text('نشط')),
                                DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedStatus = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _feeAmountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'الرسوم *',
                          prefixIcon: Icon(Icons.attach_money),
                          suffixText: 'ل.ل',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الرسوم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _instructionsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'تعليمات الملء',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'حقول النموذج',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _addField,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('إضافة حقل'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_fields.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('لم يتم إضافة أي حقول بعد'),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _fields.length,
                          itemBuilder: (context, index) {
                            final field = _fields[index];
                            return Card(
                              child: ListTile(
                                leading: Icon(_getFieldIcon(field.type)),
                                title: Text(field.label),
                                subtitle: Text('${_getFieldTypeArabic(field.type)} ${field.required ? '(مطلوب)' : '(اختياري)'}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      onPressed: () => _editField(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18),
                                      color: Colors.red,
                                      onPressed: () => _removeField(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[100],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.requestForm != null ? 'تحديث' : 'إنشاء'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFieldIcon(String type) {
    switch (type) {
      case 'text':
        return Icons.text_fields;
      case 'textarea':
        return Icons.notes;
      case 'number':
        return Icons.numbers;
      case 'email':
        return Icons.email;
      case 'date':
        return Icons.calendar_today;
      case 'select':
        return Icons.arrow_drop_down_circle;
      case 'radio':
        return Icons.radio_button_checked;
      case 'checkbox':
        return Icons.check_box;
      case 'file':
        return Icons.attach_file;
      default:
        return Icons.input;
    }
  }

  String _getFieldTypeArabic(String type) {
    switch (type) {
      case 'text':
        return 'نص';
      case 'textarea':
        return 'نص متعدد الأسطر';
      case 'number':
        return 'رقم';
      case 'email':
        return 'بريد إلكتروني';
      case 'date':
        return 'تاريخ';
      case 'select':
        return 'قائمة منسدلة';
      case 'radio':
        return 'اختيار واحد';
      case 'checkbox':
        return 'اختيار متعدد';
      case 'file':
        return 'ملف';
      default:
        return type;
    }
  }
}

class _FieldBuilderDialog extends StatefulWidget {
  final FormField? field;
  final Function(FormField) onAdd;

  const _FieldBuilderDialog({
    this.field,
    required this.onAdd,
  });

  @override
  State<_FieldBuilderDialog> createState() => _FieldBuilderDialogState();
}

class _FieldBuilderDialogState extends State<_FieldBuilderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _labelController = TextEditingController();
  final _placeholderController = TextEditingController();
  final _optionsController = TextEditingController();
  
  String _selectedType = 'text';
  bool _isRequired = false;

  @override
  void initState() {
    super.initState();
    if (widget.field != null) {
      _nameController.text = widget.field!.name;
      _labelController.text = widget.field!.label;
      _placeholderController.text = widget.field!.placeholder ?? '';
      _selectedType = widget.field!.type;
      _isRequired = widget.field!.required;
      if (widget.field!.options != null) {
        _optionsController.text = widget.field!.options!.join('\n');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _labelController.dispose();
    _placeholderController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    List<String>? options;
    if (_selectedType == 'select' || _selectedType == 'radio' || _selectedType == 'checkbox') {
      options = _optionsController.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
      
      if (options.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يجب إضافة خيار واحد على الأقل'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final field = FormField(
      name: _nameController.text.trim(),
      type: _selectedType,
      label: _labelController.text.trim(),
      required: _isRequired,
      placeholder: _placeholderController.text.trim().isNotEmpty 
          ? _placeholderController.text.trim() 
          : null,
      options: options,
    );

    widget.onAdd(field);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(
            widget.field != null ? Icons.edit : Icons.add,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 12),
          Text(widget.field != null ? 'تعديل حقل' : 'إضافة حقل'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم الحقل *',
                    hintText: 'مثال: الاسم الكامل',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الحقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                    labelText: 'التسمية *',
                    hintText: 'مثال: الاسم الكامل',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال التسمية';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'نوع الحقل *',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'text', child: Text('نص')),
                    DropdownMenuItem(value: 'textarea', child: Text('نص متعدد الأسطر')),
                    DropdownMenuItem(value: 'number', child: Text('رقم')),
                    DropdownMenuItem(value: 'email', child: Text('بريد إلكتروني')),
                    DropdownMenuItem(value: 'date', child: Text('تاريخ')),
                    DropdownMenuItem(value: 'select', child: Text('قائمة منسدلة')),
                    DropdownMenuItem(value: 'radio', child: Text('اختيار واحد')),
                    DropdownMenuItem(value: 'checkbox', child: Text('اختيار متعدد')),
                    DropdownMenuItem(value: 'file', child: Text('ملف')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _placeholderController,
                  decoration: const InputDecoration(
                    labelText: 'نص توضيحي',
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedType == 'select' || _selectedType == 'radio' || _selectedType == 'checkbox') ...[
                  TextFormField(
                    controller: _optionsController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'الخيارات (كل خيار في سطر) *',
                      hintText: 'الخيار 1\nالخيار 2\nالخيار 3',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SwitchListTile(
                  title: const Text('حقل مطلوب'),
                  value: _isRequired,
                  onChanged: (value) => setState(() => _isRequired = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.field != null ? 'تحديث' : 'إضافة'),
        ),
      ],
    );
  }
}
