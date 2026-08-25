import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/request_form_model.dart';
import '../providers/user_requests_provider.dart';

class UserRequestDetailDialog extends StatefulWidget {
  final UserRequestModel request;

  const UserRequestDetailDialog({super.key, required this.request});

  @override
  State<UserRequestDetailDialog> createState() => _UserRequestDetailDialogState();
}

class _UserRequestDetailDialogState extends State<UserRequestDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _adminNoteController = TextEditingController();
  String _selectedStatus = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.request.status;
    _adminNoteController.text = widget.request.adminNote ?? '';
  }

  @override
  void dispose() {
    _adminNoteController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<UserRequestsProvider>();
    final success = await provider.updateRequestStatus(
      id: widget.request.id,
      status: _selectedStatus,
      adminNote: _adminNoteController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث حالة الطلب بنجاح'),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 1100,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : theme.primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Simple Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: theme.primaryColor, width: 2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: theme.primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تفاصيل المعاملة',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Content - Single Column Layout
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Content
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.white,
                            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Request Form Title & Description
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildInlineField('نوع المعاملة', widget.request.requestForm.title, isDark),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInlineField('الرسوم', '${widget.request.requestForm.feeAmount.toStringAsFixed(0)} ل.ل', isDark, valueColor: Colors.green[700]),
                                  ),
                                ],
                              ),
                              if (widget.request.requestForm.description != null) ...[
                                const SizedBox(height: 12),
                                _buildInlineField('الوصف', widget.request.requestForm.description!, isDark),
                              ],
                              
                              const Divider(height: 24),
                              
                              // Citizen Info
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInlineField('الاسم الكامل', widget.request.user.fullName, isDark),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInlineField('رقم الهاتف', widget.request.user.phonenumber, isDark),
                                  ),
                                ],
                              ),
                              
                              const Divider(height: 24),
                              
                              // Submitted Data
                              Text(
                                'البيانات المقدمة',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.blue[300] : theme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...() {
                                final entries = widget.request.data.entries.toList();
                                List<Widget> rows = [];
                                for (int i = 0; i < entries.length; i += 2) {
                                  if (i + 1 < entries.length) {
                                    rows.add(
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildInlineField(entries[i].key, entries[i].value.toString(), isDark),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildInlineField(entries[i + 1].key, entries[i + 1].value.toString(), isDark),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    rows.add(_buildInlineField(entries[i].key, entries[i].value.toString(), isDark));
                                  }
                                  if (i + 2 < entries.length) {
                                    rows.add(const SizedBox(height: 12));
                                  }
                                }
                                return rows;
                              }(),
                              
                              // Attachments
                              if (widget.request.attachments != null && widget.request.attachments!.isNotEmpty) ...[
                                const Divider(height: 24),
                                Text(
                                  'المرفقات',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.blue[300] : theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...() {
                                  List<Widget> attachmentWidgets = [];
                                  final fileFields = widget.request.requestForm.attachmentsRequired;
                                  
                                  widget.request.attachments!.forEach((fieldName, value) {
                                    // Get field label from attachmentsRequired or use field name
                                    String fieldLabel = fieldName;
                                    if (fileFields != null) {
                                      // Try to find matching label from form fields
                                      final formField = widget.request.requestForm.attachmentsRequired;
                                      // Use field name as fallback
                                      fieldLabel = fieldName;
                                    }
                                    
                                    // Handle both single file (String) and multiple files (List)
                                    List<String> fileUrls = [];
                                    if (value is String) {
                                      fileUrls = [value];
                                    } else if (value is List) {
                                      fileUrls = value.map((e) => e.toString()).toList();
                                    }
                                    
                                    // Add section for this field's attachments
                                    for (var fileUrl in fileUrls) {
                                      final fileName = fileUrl.split('/').last;
                                      
                                      attachmentWidgets.add(
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                                            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.attach_file, size: 16, color: theme.primaryColor),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          fieldLabel,
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight: FontWeight.bold,
                                                            color: theme.primaryColor,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          fileName,
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            color: isDark ? Colors.grey[300] : Colors.black87,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  // Preview/View button
                                                  IconButton(
                                                    icon: const Icon(Icons.visibility, size: 16),
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                      await _viewAttachment(fileUrl);
                                                    },
                                                    tooltip: 'عرض',
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    icon: const Icon(Icons.download, size: 16),
                                                    color: Colors.blue,
                                                    onPressed: () async {
                                                      await _downloadAttachment(fileUrl, fileName);
                                                    },
                                                    tooltip: 'تحميل',
                                                    padding: EdgeInsets.zero,
                                                    constraints: const BoxConstraints(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                  
                                  return attachmentWidgets;
                                }(),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Right Column - Admin Section & Info
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Admin Response Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[850] : Colors.amber[50],
                                border: Border.all(
                                  color: isDark ? Colors.amber[700]! : Colors.amber[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.admin_panel_settings, color: Colors.amber[700], size: 18),
                                        const SizedBox(width: 6),
                                        const Expanded(
                                          child: Text(
                                            'قسم الإدارة',
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    DropdownButtonFormField<String>(
                                      value: _selectedStatus,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark ? Colors.grey[200] : Colors.black,
                                      ),
                                      dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                                      decoration: InputDecoration(
                                        labelText: 'الحالة',
                                        labelStyle: const TextStyle(fontSize: 11),
                                        prefixIcon: const Icon(Icons.toggle_on, size: 18),
                                        filled: true,
                                        fillColor: isDark ? Colors.grey[900] : Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: 'pending',
                                          child: Text(
                                            'قيد الانتظار',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.grey[200] : Colors.black,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'approved',
                                          child: Text(
                                            'موافق عليه',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.grey[200] : Colors.black,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'rejected',
                                          child: Text(
                                            'مرفوض',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.grey[200] : Colors.black,
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'info_needed',
                                          child: Text(
                                            'يحتاج معلومات',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.grey[200] : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: _isLoading ? null : (value) {
                                        if (value != null) {
                                          setState(() => _selectedStatus = value);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _adminNoteController,
                                      maxLines: 5,
                                      style: const TextStyle(fontSize: 11),
                                      decoration: InputDecoration(
                                        labelText: 'ملاحظات الإدارة',
                                        labelStyle: const TextStyle(fontSize: 11),
                                        prefixIcon: const Icon(Icons.note, size: 18),
                                        hintText: 'أضف ملاحظاتك هنا...',
                                        hintStyle: const TextStyle(fontSize: 10),
                                        filled: true,
                                        fillColor: isDark ? Colors.grey[900] : Colors.white,
                                        contentPadding: const EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: _isLoading ? null : _updateStatus,
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        icon: _isLoading
                                            ? const SizedBox(
                                                width: 14,
                                                height: 14,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                            : const Icon(Icons.check_circle, size: 16),
                                        label: Text(
                                          _isLoading ? 'جاري الحفظ...' : 'تحديث الحالة',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Document Info
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[850] : Colors.grey[50],
                                border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 16, color: theme.primaryColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        'معلومات إضافية',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 16),
                                  _buildInfoRow('الحالة', widget.request.statusArabic, isDark),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('تاريخ التقديم', 
                                    widget.request.createdAt != null
                                        ? DateFormat('dd/MM/yyyy').format(widget.request.createdAt!)
                                        : '-',
                                    isDark
                                  ),
                                  if (widget.request.updatedAt != null) ...[
                                    const SizedBox(height: 8),
                                    _buildInfoRow('آخر تحديث',
                                      DateFormat('dd/MM/yyyy').format(widget.request.updatedAt!),
                                      isDark
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildInlineField(String label, String value, bool isDark, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.blue[200] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: valueColor ?? (isDark ? Colors.grey[200] : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[200] : Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'info_needed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _viewAttachment(String attachmentUrl) async {
    try {
      final uri = Uri.parse(attachmentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا يمكن فتح المرفق'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadAttachment(String attachmentUrl, String fileName) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جاري تحميل المرفق...'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Download the file
      final response = await http.get(Uri.parse(attachmentUrl));
      
      if (response.statusCode == 200) {
        // Get Downloads directory
        Directory? downloadsDir;
        if (Platform.isWindows) {
          downloadsDir = Directory('${Platform.environment['USERPROFILE']}\\Downloads');
        } else if (Platform.isLinux || Platform.isMacOS) {
          downloadsDir = Directory('${Platform.environment['HOME']}/Downloads');
        } else {
          downloadsDir = await getDownloadsDirectory();
        }

        if (downloadsDir != null) {
          // Create unique filename if file exists
          String filePath = '${downloadsDir.path}\\$fileName';
          int counter = 1;
          while (File(filePath).existsSync()) {
            final nameParts = fileName.split('.');
            final extension = nameParts.length > 1 ? nameParts.last : '';
            final nameWithoutExt = nameParts.length > 1 
                ? nameParts.sublist(0, nameParts.length - 1).join('.')
                : fileName;
            filePath = '${downloadsDir.path}\\$nameWithoutExt($counter).$extension';
            counter++;
          }

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم حفظ الملف في: ${downloadsDir.path}'),
                backgroundColor: Colors.green,
                action: SnackBarAction(
                  label: 'فتح',
                  textColor: Colors.white,
                  onPressed: () async {
                    final uri = Uri.file(filePath);
                    await launchUrl(uri);
                  },
                ),
              ),
            );
          }
        }
      } else {
        throw Exception('Failed to download: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل التحميل: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _printAttachment(String attachmentUrl) async {
    try {
      // For printing, we'll download and open the file
      // The user can then print from their system's viewer
      final uri = Uri.parse(attachmentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('استخدم Ctrl+P لطباعة الملف'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا يمكن فتح المرفق'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}