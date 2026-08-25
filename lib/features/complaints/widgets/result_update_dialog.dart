import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../providers/complaints_provider.dart';

class ResultUpdateDialog extends StatefulWidget {
  final String complaintId;
  final String? currentResult;

  const ResultUpdateDialog({
    super.key,
    required this.complaintId,
    this.currentResult,
  });

  @override
  State<ResultUpdateDialog> createState() => _ResultUpdateDialogState();
}

class _ResultUpdateDialogState extends State<ResultUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _resultController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _resultController.text = widget.currentResult ?? '';
  }

  @override
  void dispose() {
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomDialog(
      title: 'تحديث نتيجة الشكوى',
      width: 500,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _resultController,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'النتيجة',
                labelStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                hintText: 'أدخل نتيجة معالجة الشكوى...',
                hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 12, color: Colors.grey.shade500),
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: Icon(Icons.description),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال النتيجة';
                }
                return null;
              },
            ),
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
            textStyle: const TextStyle(fontSize: 12),
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
              : const Text('حفظ', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final provider = context.read<ComplaintsProvider>();

    final success = await provider.updateComplaintResult(
      id: widget.complaintId,
      result: _resultController.text.trim(),
    );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث النتيجة بنجاح'),
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
}
