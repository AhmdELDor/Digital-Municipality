import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../models/bill_model.dart';
import '../providers/bills_provider.dart';

class BillFormDialog extends StatefulWidget {
  final BillModel? bill;

  const BillFormDialog({super.key, this.bill});

  @override
  State<BillFormDialog> createState() => _BillFormDialogState();
}

class _BillFormDialogState extends State<BillFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.bill != null) {
      _titleController.text = widget.bill!.title;
      _descriptionController.text = widget.bill!.description ?? '';
      _amountController.text = widget.bill!.amount.toString();
    }
    // Payment type is locked to cash
    // Keep controller implicit by using fixed label in UI
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.bill != null;
    final theme = Theme.of(context);

    return CustomDialog(
      title: isEdit ? 'تعديل الفاتورة' : 'إنشاء فاتورة',
      width: 520,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              style: _fieldTextStyle(context),
              decoration: InputDecoration(
                labelText: 'عنوان الفاتورة *',
                labelStyle: _labelTextStyle(context),
                prefixIcon: const Icon(Icons.receipt_long_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) => value == null || value.trim().isEmpty ? 'الرجاء إدخال العنوان' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              initialValue: 'نقداً',
              style: _fieldTextStyle(context),
              decoration: InputDecoration(
                labelText: 'نوع الدفع (ثابت)',
                labelStyle: _labelTextStyle(context),
                prefixIcon: const Icon(Icons.payments),
                helperText: 'حاليًا جميع الاستحقاقات المالية نقداً',
                helperStyle: _labelTextStyle(context)?.copyWith(color: Colors.grey.shade600),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: _fieldTextStyle(context),
              decoration: InputDecoration(
                labelText: 'المبلغ (ل.ل) *',
                labelStyle: _labelTextStyle(context),
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: 'ل.ل',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'الرجاء إدخال المبلغ';
                final parsed = double.tryParse(value);
                if (parsed == null || parsed < 0) return 'الرجاء إدخال مبلغ صالح';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              style: _fieldTextStyle(context),
              decoration: InputDecoration(
                labelText: 'الوصف (اختياري)',
                labelStyle: _labelTextStyle(context),
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.notes_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text(isEdit ? 'حفظ' : 'إنشاء'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final provider = context.read<BillsProvider>();
    final isEdit = widget.bill != null;
    const paymentType = 'cash';

    setState(() => _isSubmitting = true);

    final success = isEdit
        ? await provider.updateBill(
            id: widget.bill!.id,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            amount: amount,
            paymentType: paymentType,
          )
        : await provider.createBill(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            amount: amount,
            paymentType: paymentType,
          );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'تم تحديث الفاتورة' : 'تم إنشاء الفاتورة'),
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
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  TextStyle? _fieldTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13);
  }

  TextStyle? _labelTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12);
  }
}
