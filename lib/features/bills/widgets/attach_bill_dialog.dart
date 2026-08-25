import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../users/providers/users_provider.dart';
import '../models/bill_model.dart';
import '../providers/bills_provider.dart';

class AttachBillDialog extends StatefulWidget {
  final List<BillModel> templates;

  const AttachBillDialog({super.key, required this.templates});

  @override
  State<AttachBillDialog> createState() => _AttachBillDialogState();
}

class _AttachBillDialogState extends State<AttachBillDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  final _userSearchController = TextEditingController();
  final ScrollController _usersScrollController = ScrollController();

  BillModel? _selectedTemplate;
  DateTime? _dueDate;
  String _targetMode = 'users';
  String? _targetRole;
  bool _isSubmitting = false;
  final Set<String> _selectedUserIds = {};
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    final usersProvider = context.read<UsersProvider>();
    if (usersProvider.users.isEmpty) {
      usersProvider.fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersProvider = context.watch<UsersProvider>();

    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return CustomDialog(
      title: 'إرفاق فاتورة',
      width: 1080,
      content: SizedBox(
        height: maxHeight,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(right: 24, bottom: 8),
                          child: _buildBillForm(context),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 1,
                        child: VerticalDivider(color: theme.dividerColor.withOpacity(0.4), thickness: 1),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, bottom: 8),
                          child: _buildRecipientsPane(theme, usersProvider),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text('إرفاق الفاتورة', style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildBillForm(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('بيانات الفاتورة', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTemplateDropdown()),
            const SizedBox(width: 12),
            Expanded(child: _buildDueDatePicker(context)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildTitleField()),
            const SizedBox(width: 12),
            Expanded(child: _buildAmountField()),
          ],
        ),
        const SizedBox(height: 12),
        _buildDescriptionField(),
        const SizedBox(height: 12),
        _buildNoteField(),
      ],
    );
  }

  Widget _buildRecipientsPane(ThemeData theme, UsersProvider usersProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('المستلمون', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: [
            ChoiceChip(
              label: const Text('تحديد مستخدمين', style: TextStyle(fontSize: 12)),
              selected: _targetMode == 'users',
              onSelected: (_) => setState(() => _targetMode = 'users'),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            ChoiceChip(
              label: const Text('حسب الدور (الكل/مواطن/مدير)', style: TextStyle(fontSize: 12)),
              selected: _targetMode == 'role',
              onSelected: (_) => setState(() => _targetMode = 'role'),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_targetMode == 'users') _buildUserSelector(theme, usersProvider),
        if (_targetMode == 'role') _buildRoleSelector(theme),
      ],
    );
  }

  // Summary bar and quick date chips removed per updated UX.

  Widget _buildTemplateDropdown() {
    return DropdownButtonFormField<BillModel?>(
      style: _fieldTextStyle(context),
      decoration: InputDecoration(
        labelText: 'نسخ من فاتورة (اختياري)',
        labelStyle: _labelTextStyle(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.copy_outlined),
      ),
      isExpanded: true,
      value: _selectedTemplate,
      items: [
        const DropdownMenuItem<BillModel?>(value: null, child: Text('بدون فاتورة')),
        ...widget.templates.map((bill) => DropdownMenuItem<BillModel?>(
              value: bill,
              child: Text(bill.title, overflow: TextOverflow.ellipsis),
            )),
      ],
      onChanged: (bill) {
        setState(() {
          _selectedTemplate = bill;
          if (bill != null) {
            _titleController.text = bill.title;
            _amountController.text = bill.amount.toString();
            _descriptionController.text = bill.description ?? '';
          }
        });
      },
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: _fieldTextStyle(context),
      decoration: InputDecoration(
        labelText: 'عنوان الفاتورة *',
        labelStyle: _labelTextStyle(context),
        prefixIcon: const Icon(Icons.receipt_long_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => value == null || value.trim().isEmpty ? 'أدخل عنواناً واضحاً' : null,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
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
        if (value == null || value.trim().isEmpty) return 'أدخل المبلغ';
        final parsed = double.tryParse(value);
        if (parsed == null || parsed < 0) return 'المبلغ غير صالح';
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 2,
      style: _fieldTextStyle(context),
      decoration: InputDecoration(
        labelText: 'الوصف (اختياري)',
        labelStyle: _labelTextStyle(context),
        alignLabelWithHint: true,
        prefixIcon: const Icon(Icons.notes_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      maxLines: 2,
      style: _fieldTextStyle(context),
      decoration: InputDecoration(
        labelText: 'ملاحظة داخلية (اختياري)',
        labelStyle: _labelTextStyle(context),
        alignLabelWithHint: true,
        prefixIcon: const Icon(Icons.sticky_note_2_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDueDatePicker(BuildContext context) {
    final theme = Theme.of(context);
    final display = _dueDate != null ? DateFormat('yyyy-MM-dd').format(_dueDate!) : 'تحديد تاريخ الاستحقاق *';
    return InkWell(
      onTap: _pickDueDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'تاريخ الاستحقاق',
          labelStyle: _labelTextStyle(context),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.event_outlined),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(display, style: _fieldTextStyle(context) ?? theme.textTheme.bodyMedium),
        ),
      ),
    );
  }

  Widget _buildUserSelector(ThemeData theme, UsersProvider usersProvider) {
    final meta = usersProvider.meta;
    final currentApiPage = meta?['current_page'] ?? 1;
    final totalPages = meta?['last_page'] ?? 1;
    final total = meta?['total'] ?? 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _userSearchController,
                style: _fieldTextStyle(context),
                decoration: InputDecoration(
                  labelText: 'بحث باسم أو رقم الهاتف',
                  labelStyle: _labelTextStyle(context),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _userSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _userSearchController.clear();
                            _currentPage = 1;
                            usersProvider.fetchUsers(page: 1, search: '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  _currentPage = 1;
                  usersProvider.fetchUsers(page: 1, search: value);
                },
              ),
            ),
            const SizedBox(width: 10),
            Text('المحدد: ${_selectedUserIds.length}', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 320,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: usersProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : usersProvider.users.isEmpty
                  ? Center(
                      child: Text(
                        'لا يوجد مستخدمين',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    )
                  : Scrollbar(
                      controller: _usersScrollController,
                      child: ListView.separated(
                        controller: _usersScrollController,
                        itemCount: usersProvider.users.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
                        itemBuilder: (context, index) {
                          final user = usersProvider.users[index];
                          final isSelected = _selectedUserIds.contains(user.id);
                          return CheckboxListTile(
                            value: isSelected,
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            title: Text(user.fullName, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
                            subtitle: Text(
                              user.phonenumber,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontSize: 10),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedUserIds.add(user.id);
                                } else {
                                  _selectedUserIds.remove(user.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('المحدد: ${_selectedUserIds.length} من أصل $total', style: theme.textTheme.bodySmall),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'السابق',
                  visualDensity: VisualDensity.compact,
                  onPressed: currentApiPage <= 1
                      ? null
                      : () {
                          final newPage = currentApiPage - 1;
                          _currentPage = newPage;
                          usersProvider.fetchUsers(
                            page: newPage,
                            search: _userSearchController.text,
                          );
                        },
                ),
                Text('$currentApiPage/$totalPages', style: theme.textTheme.bodySmall),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'التالي',
                  visualDensity: VisualDensity.compact,
                  onPressed: currentApiPage >= totalPages
                      ? null
                      : () {
                          final newPage = currentApiPage + 1;
                          _currentPage = newPage;
                          usersProvider.fetchUsers(
                            page: newPage,
                            search: _userSearchController.text,
                          );
                        },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          style: _fieldTextStyle(context),
          decoration: InputDecoration(
            labelText: 'الدور المستهدف *',
            labelStyle: _labelTextStyle(context),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.group_outlined),
          ),
          value: _targetRole,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('الكل')),
            DropdownMenuItem(value: 'citizen', child: Text('المواطنون')), 
            DropdownMenuItem(value: 'admin', child: Text('المدراء')), 
          ],
          onChanged: (value) => setState(() => _targetRole = value),
          validator: (value) => value == null || value.isEmpty ? 'اختر دوراً مستهدفاً' : null,
        ),
        const SizedBox(height: 6),
        Text('يمكنك إرسال الفاتورة لجميع المستخدمين أو حسب الدور المحدد.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
      ],
    );
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (selected != null) {
      setState(() => _dueDate = selected);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدد تاريخ الاستحقاق')));
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final provider = context.read<BillsProvider>();

    if (_targetMode == 'users' && _selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر مستخدماً واحداً على الأقل')));
      return;
    }

    if (_targetMode == 'role' && (_targetRole == null || _targetRole!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر الدور المستهدف')));
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await provider.attachBill(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      amount: amount,
      dueDate: _dueDate!,
      userIds: _targetMode == 'users' ? _selectedUserIds.toList() : null,
      targetRole: _targetMode == 'role' ? _targetRole : null,
    );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرفاق الفاتورة بنجاح'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'تعذر إرفاق الفاتورة'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _userSearchController.dispose();
    _usersScrollController.dispose();
    super.dispose();
  }

  TextStyle? _fieldTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11);
  }

  TextStyle? _labelTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10);
  }
}
