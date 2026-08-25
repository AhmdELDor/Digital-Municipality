import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notifications_provider.dart';
import '../../users/providers/users_provider.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  String _sendTo = 'citizens';
  List<String> _selectedUserIds = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<NotificationsProvider>();
    Map<String, dynamic>? result;

    try {
      switch (_sendTo) {
        case 'citizens':
          result = await provider.sendToAllCitizens(
            title: _titleController.text,
            body: _bodyController.text,
          );
          break;
        case 'admins':
          result = await provider.sendToAllAdmins(
            title: _titleController.text,
            body: _bodyController.text,
          );
          break;
        case 'employees':
          result = await provider.sendToAllEmployees(
            title: _titleController.text,
            body: _bodyController.text,
          );
          break;
        case 'everyone':
          result = await provider.broadcast(
            title: _titleController.text,
            body: _bodyController.text,
          );
          break;
        case 'specific':
          if (_selectedUserIds.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('الرجاء اختيار مستخدمين'),
                backgroundColor: Colors.orange,
              ),
            );
            setState(() => _isLoading = false);
            return;
          }
          result = await provider.sendToBulk(
            userIds: _selectedUserIds,
            title: _titleController.text,
            body: _bodyController.text,
          );
          break;
      }

      setState(() => _isLoading = false);

      if (result != null && mounted) {
        final data = result['data'] as Map<String, dynamic>?;
        final success = data?['success'] ?? 0;
        final failure = data?['failure'] ?? 0;

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إرسال الإشعار\nنجح: $success | فشل: $failure',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل إرسال الإشعار'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('إرسال إشعار', style: TextStyle(fontSize: 16)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Send to
            Text(
              'إرسال إلى',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _sendTo,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[200] : Colors.black,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'citizens',
                  child: Text('جميع المواطنين', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: 'admins',
                  child: Text('جميع الإداريين', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: 'employees',
                  child: Text('جميع الموظفين', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: 'everyone',
                  child: Text('الجميع', style: TextStyle(fontSize: 12)),
                ),
                DropdownMenuItem(
                  value: 'specific',
                  child: Text('مستخدمين محددين', style: TextStyle(fontSize: 12)),
                ),
              ],
              onChanged: (value) {
                setState(() => _sendTo = value!);
              },
            ),

            // Show user selection if specific is selected
            if (_sendTo == 'specific') ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final selected = await Navigator.push<List<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const _UserSelectionScreen(),
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedUserIds = selected.map((u) => (u as dynamic).id as String).toList();
                    });
                  }
                },
                icon: const Icon(Icons.person_add, size: 16),
                label: Text(
                  _selectedUserIds.isEmpty
                      ? 'اختيار المستخدمين'
                      : 'تم اختيار ${_selectedUserIds.length} مستخدم',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Title
            Text(
              'العنوان',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'عنوان الإشعار',
                hintStyle: TextStyle(fontSize: 11),
                contentPadding: EdgeInsets.all(12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال العنوان';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Body
            Text(
              'المحتوى',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bodyController,
              style: const TextStyle(fontSize: 12),
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'نص الإشعار',
                hintStyle: TextStyle(fontSize: 11),
                contentPadding: EdgeInsets.all(12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال المحتوى';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Send button
            ElevatedButton(
              onPressed: _isLoading ? null : _sendNotification,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('إرسال الإشعار', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

// User selection screen
class _UserSelectionScreen extends StatefulWidget {
  const _UserSelectionScreen();

  @override
  State<_UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<_UserSelectionScreen> {
  final List<dynamic> _selectedUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProvider>().fetchUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار المستخدمين', style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedUsers);
            },
            child: Text(
              'تم (${_selectedUsers.length})',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'بحث...',
                hintStyle: const TextStyle(fontSize: 11),
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (value) {
                context.read<UsersProvider>().searchUsers(value);
              },
            ),
          ),

          // Users list
          Expanded(
            child: Consumer<UsersProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.users.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا يوجد مستخدمين',
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    final isSelected = _selectedUsers.any((u) => (u as dynamic).id == user.id);

                    return CheckboxListTile(
                      title: Text(
                        user.fullName,
                        style: const TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        user.phonenumber,
                        style: const TextStyle(fontSize: 10),
                      ),
                      value: isSelected,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedUsers.add(user);
                          } else {
                            _selectedUsers.removeWhere((u) => (u as dynamic).id == user.id);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
