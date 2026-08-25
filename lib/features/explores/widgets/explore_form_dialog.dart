import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/explore_model.dart';
import '../providers/explores_provider.dart';
import '../../users/models/user_model.dart';
import '../../users/providers/users_provider.dart';

class ExploreFormDialog extends StatefulWidget {
  final ExploreModel? explore;

  const ExploreFormDialog({super.key, this.explore});

  @override
  State<ExploreFormDialog> createState() => _ExploreFormDialogState();
}

class _ExploreFormDialogState extends State<ExploreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _citizenSearchController = TextEditingController();

  final List<String> _categories = [
    'سياحة ومعالم',
    'مطاعم ومقاهي',
    'فنادق ومنتجعات',
    'تسوق ومحلات',
    'صحة وطبابة',
    'خدمات عامة',
    'فعاليات ومهرجانات',
    'رياضة وتسلية',
    'ثقافة وفنون',
    'خدمات مالية',
    'أخرى',
  ];

  String? _selectedCategory;
  String _type = 'promotion';
  String _status = 'pending';
  User? _selectedCitizen;
  DateTime? _startDate;
  DateTime? _endDate;
  List<File> _selectedImages = [];
  List<String> _existingImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.explore != null) {
      _titleController.text = widget.explore!.title;
      _descriptionController.text = widget.explore!.desc;
      // If existing category is not in list, add it or handle it. 
      // For now we try to match, if not matched it will be null in dropdown (might be issue)
      // or we can add it to _categories if needed.
      if (widget.explore!.category != null && widget.explore!.category!.isNotEmpty) {
        if (!_categories.contains(widget.explore!.category)) {
          _categories.add(widget.explore!.category!);
        }
        _selectedCategory = widget.explore!.category;
      }
      _type = widget.explore!.type;
      _status = widget.explore!.status;
      _startDate = widget.explore!.startDate;
      _endDate = widget.explore!.endDate;
      _existingImages = widget.explore!.imagesUrl;
      
      if (widget.explore!.citizen != null) {
        final citizenInfo = widget.explore!.citizen!;
        _selectedCitizen = User(
          id: citizenInfo.id,
          fullName: citizenInfo.fullName,
          phonenumber: citizenInfo.phonenumber,
          role: 'citizen',
          createdAt: DateTime.now(), // Placeholder for display purposes
        );
        _citizenSearchController.text = '${_selectedCitizen!.fullName} (${_selectedCitizen!.phonenumber})';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.explore != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(isEdit ? Icons.edit : Icons.add_circle, color: theme.primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? 'تعديل الاستكشاف' : 'إضافة استكشاف جديد',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          labelText: 'العنوان *',
                          labelStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'العنوان مطلوب' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          labelText: 'الوصف',
                          labelStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _type,
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                              decoration: const InputDecoration(
                                labelText: 'النوع *',
                                labelStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'promotion', child: Text('عروضات', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'post', child: Text('منشور', style: TextStyle(fontSize: 12))),
                              ],
                              onChanged: (value) => setState(() => _type = value!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _status,
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                              decoration: const InputDecoration(
                                labelText: 'الحالة *',
                                labelStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'pending', child: Text('قيد الانتظار', style: TextStyle(fontSize: 12))),
                                DropdownMenuItem(value: 'approved', child: Text('موافق عليه', style: TextStyle(fontSize: 12))),
                              ],
                              onChanged: (value) => setState(() => _status = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                        decoration: const InputDecoration(
                          labelText: 'الفئة',
                          labelStyle: TextStyle(fontSize: 12),
                          hintText: 'اختر الفئة',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat, style: const TextStyle(fontSize: 12)),
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value),
                        validator: (value) => value == null ? 'الفئة مطلوبة' : null,
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return RawAutocomplete<User>(
                            textEditingController: _citizenSearchController,
                            focusNode: FocusNode(), // RawAutocomplete requires focusNode if controller is provided
                            optionsBuilder: (TextEditingValue textEditingValue) async {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<User>.empty();
                              }
                              try {
                                final provider = context.read<UsersProvider>();
                                await provider.fetchUsers(search: textEditingValue.text);
                                return provider.users.where((u) => u.role == 'citizen');
                              } catch (e) {
                                return const Iterable<User>.empty();
                              }
                            },
                            displayStringForOption: (User option) => '${option.fullName} (${option.phonenumber})',
                            onSelected: (User selection) {
                              setState(() {
                                _selectedCitizen = selection;
                              });
                            },
                            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  labelText: 'المواطن',
                                  labelStyle: TextStyle(fontSize: 12),
                                  hintText: 'ابحث عن المواطن',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search, size: 20),
                                ),
                                onChanged: (val) {
                                  if (_selectedCitizen != null) {
                                    setState(() => _selectedCitizen = null);
                                  }
                                },
                                validator: (value) {
                                  if (_selectedCitizen == null) {
                                    return 'الرجاء اختيار مواطن';
                                  }
                                  return null;
                                },
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  color: theme.cardColor,
                                  child: Container(
                                    width: constraints.maxWidth,
                                    constraints: const BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final User option = options.elementAt(index);
                                        return ListTile(
                                          title: Text('${option.fullName} (${option.phonenumber})', style: const TextStyle(fontSize: 12)),
                                          onTap: () {
                                            onSelected(option);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectStartDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'تاريخ البدء',
                                  labelStyle: TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  _startDate != null
                                      ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                                      : 'اختر التاريخ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectEndDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'تاريخ الانتهاء',
                                  labelStyle: TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  _endDate != null
                                      ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                                      : 'اختر التاريخ',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Images Section
                      Text('الصور', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 8),
                      if (_existingImages.isNotEmpty || _selectedImages.isNotEmpty)
                        SizedBox(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ..._existingImages.map((url) => Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(url, width: 120, height: 120, fit: BoxFit.cover),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: IconButton(
                                            icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                            style: IconButton.styleFrom(backgroundColor: Colors.red),
                                            onPressed: () => setState(() => _existingImages.remove(url)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              ..._selectedImages.map((file) => Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(file, width: 120, height: 120, fit: BoxFit.cover),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: IconButton(
                                            icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                            style: IconButton.styleFrom(backgroundColor: Colors.red),
                                            onPressed: () => setState(() => _selectedImages.remove(file)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('إضافة صور'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark 
                    ? theme.colorScheme.surface 
                    : Colors.grey[100],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSubmit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(isEdit ? Icons.save : Icons.add, size: 18),
                    label: Text(isEdit ? 'حفظ' : 'إضافة'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final isEdit = widget.explore != null;
    final success = await (isEdit
        ? context.read<ExploresProvider>().updateExplore(
              id: widget.explore!.id,
              title: _titleController.text,
              desc: _descriptionController.text,
              type: _type,
              status: _status,
              category: _selectedCategory,
              startDate: _startDate != null
                  ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                  : null,
              endDate: _endDate != null
                  ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                  : null,
              images: _selectedImages,
            )
        : context.read<ExploresProvider>().createExplore(
              title: _titleController.text,
              desc: _descriptionController.text,
              category: _selectedCategory ?? '',
              type: _type,
              citizenId: _selectedCitizen?.id ?? '',
              startDate: _startDate != null
                  ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                  : '',
              endDate: _endDate != null
                  ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                  : '',
              status: _status,
              images: _selectedImages,
            ));

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'تم التعديل بنجاح' : 'تمت الإضافة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'فشل التعديل' : 'فشلت الإضافة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _citizenSearchController.dispose();
    super.dispose();
  }
}
