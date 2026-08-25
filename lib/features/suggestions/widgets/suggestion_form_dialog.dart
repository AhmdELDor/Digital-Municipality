import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/suggestion_model.dart';
import '../providers/suggestions_provider.dart';

class SuggestionFormDialog extends StatefulWidget {
  final SuggestionModel? suggestion;

  const SuggestionFormDialog({super.key, this.suggestion});

  @override
  State<SuggestionFormDialog> createState() => _SuggestionFormDialogState();
}

class _SuggestionFormDialogState extends State<SuggestionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.suggestion != null) {
      _descController.text = widget.suggestion!.desc;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<SuggestionsProvider>();
    final desc = _descController.text.trim();

    bool success;
    if (widget.suggestion != null) {
      success = await provider.updateSuggestion(widget.suggestion!.id, desc);
    } else {
      success = await provider.createSuggestion(desc);
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.suggestion != null ? 'تم تحديث الاقتراح بنجاح' : 'تم إضافة الاقتراح بنجاح'),
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

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(
            widget.suggestion != null ? Icons.edit : Icons.add_comment,
            color: theme.primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(widget.suggestion != null ? 'تعديل اقتراح' : 'إضافة اقتراح جديد'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'الاقتراح',
                  hintText: 'اكتب اقتراحك هنا...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال الاقتراح';
                  }
                  if (value.trim().length < 10) {
                    return 'الاقتراح يجب أن يكون 10 أحرف على الأقل';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(widget.suggestion != null ? 'تحديث' : 'إضافة'),
        ),
      ],
    );
  }
}
