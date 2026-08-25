import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../../core/utils/phone_utils.dart';
import '../providers/users_provider.dart';
import '../models/user_model.dart';

class UserFormDialog extends StatefulWidget {
  final User? user;

  const UserFormDialog({super.key, this.user});

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'citizen';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _fullNameController.text = widget.user!.fullName;
      _phonenumberController.text = widget.user!.phonenumber;
      _addressController.text = widget.user!.address ?? '';
      _selectedRole = widget.user!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.user != null;

    return CustomDialog(
      title: isEditMode ? 'تعديل مستخدم' : 'إضافة مستخدم جديد',
      width: 600,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Full Name Field
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'الاسم الكامل *',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم الكامل';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Phone Number Field using utility
            PhoneUtils.buildPhoneTextField(
              controller: _phonenumberController,
              label: 'رقم الهاتف',
              hint: '+961xxxxxxxx',
            ),

            const SizedBox(height: 16),

            // Role Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'الدور *',
                prefixIcon: const Icon(Icons.admin_panel_settings),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'citizen',
                  child: Text('مواطن'),
                ),
                DropdownMenuItem(
                  value: 'admin',
                  child: Text('مدير'),
                ),
                DropdownMenuItem(
                  value: 'superadmin',
                  child: Text('مدير عام'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Address Field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'العنوان *',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال العنوان';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password Field (Required for new, optional for edit)
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: isEditMode ? 'كلمة المرور (اختياري)' : 'كلمة المرور *',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: isEditMode
                    ? 'اتركه فارغاً للإبقاء على كلمة المرور الحالية'
                    : 'أدخل كلمة مرور قوية',
              ),
              obscureText: true,
              validator: (value) {
                if (!isEditMode && (value == null || value.isEmpty)) {
                  return 'الرجاء إدخال كلمة المرور';
                }
                if (value != null && value.isNotEmpty && value.length < 8) {
                  return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                }
                return null;
              },
            ),

            if (!isEditMode) ...[
              const SizedBox(height: 8),
              Text(
                'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(isEditMode ? 'حفظ التعديلات' : 'إضافة'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final provider = context.read<UsersProvider>();
    bool success;

    if (widget.user != null) {
      // Update existing user
      success = await provider.updateUser(
        id: widget.user!.id,
        fullName: _fullNameController.text,
        phonenumber: _phonenumberController.text,
        role: _selectedRole,
        address: _addressController.text,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null,
      );
    } else {
      // Create new user
      success = await provider.createUser(
        fullName: _fullNameController.text,
        phonenumber: _phonenumberController.text,
        role: _selectedRole,
        address: _addressController.text,
        password: _passwordController.text,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (success && context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.user != null
                ? 'تم تحديث المستخدم بنجاح'
                : 'تم إضافة المستخدم بنجاح',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else if (context.mounted) {
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
    _fullNameController.dispose();
    _phonenumberController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
