class RequestFormModel {
  final String id;
  final String title;
  final String? description;
  final List<FormField> fields;
  final String version;
  final String status;
  final String? instructions;
  final List<String>? attachmentsRequired;
  final double feeAmount;
  final List<String>? allowedFileTypes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RequestFormModel({
    required this.id,
    required this.title,
    this.description,
    required this.fields,
    required this.version,
    required this.status,
    this.instructions,
    this.attachmentsRequired,
    required this.feeAmount,
    this.allowedFileTypes,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestFormModel.fromJson(Map<String, dynamic> json) {
    return RequestFormModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      fields: (json['fields'] as List).map((f) => FormField.fromJson(f)).toList(),
      version: json['version'] ?? '1.0',
      status: json['status'] ?? 'active',
      instructions: json['instructions'],
      attachmentsRequired: json['attachments_required'] != null 
          ? List<String>.from(json['attachments_required']) 
          : null,
      feeAmount: double.parse(json['fee_amount'].toString()),
      allowedFileTypes: json['allowed_file_types'] != null 
          ? List<String>.from(json['allowed_file_types']) 
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fields': fields.map((f) => f.toJson()).toList(),
      'version': version,
      'status': status,
      'instructions': instructions,
      'attachments_required': attachmentsRequired,
      'fee_amount': feeAmount,
      'allowed_file_types': allowedFileTypes,
    };
  }

  String get statusArabic {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'inactive':
        return 'غير نشط';
      default:
        return status;
    }
  }
}

class FormField {
  final String name;
  final String type;
  final String label;
  final bool required;
  final String? placeholder;
  final List<String>? options;
  final bool? multiple; // Added for file fields

  FormField({
    required this.name,
    required this.type,
    required this.label,
    required this.required,
    this.placeholder,
    this.options,
    this.multiple,
  });

  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      name: json['name'],
      type: json['type'],
      label: json['label'],
      required: json['required'] ?? false,
      placeholder: json['placeholder'],
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      multiple: json['multiple'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'label': label,
      'required': required,
      if (placeholder != null) 'placeholder': placeholder,
      if (options != null) 'options': options,
      if (multiple != null) 'multiple': multiple,
    };
  }
}

class UserRequestModel {
  final String id;
  final UserInfo user;
  final RequestFormInfo requestForm;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? attachments; // Changed from List to Map
  final String status;
  final String? adminNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserRequestModel({
    required this.id,
    required this.user,
    required this.requestForm,
    required this.data,
    this.attachments,
    required this.status,
    this.adminNote,
    this.createdAt,
    this.updatedAt,
  });

  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    // Handle both List and Map formats for attachments
    Map<String, dynamic>? attachments;
    if (json['attachments'] != null) {
      if (json['attachments'] is Map) {
        attachments = Map<String, dynamic>.from(json['attachments']);
      } else if (json['attachments'] is List) {
        // Convert old List format to Map format with generic field names
        final List<dynamic> list = json['attachments'];
        attachments = {};
        for (int i = 0; i < list.length; i++) {
          attachments['attachment_${i + 1}'] = list[i];
        }
      }
    }
    
    return UserRequestModel(
      id: json['id'],
      user: UserInfo.fromJson(json['user']),
      requestForm: RequestFormInfo.fromJson(json['request_form']),
      data: Map<String, dynamic>.from(json['data']),
      attachments: attachments,
      status: json['status'],
      adminNote: json['admin_note'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  String get statusArabic {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'موافق عليه';
      case 'rejected':
        return 'مرفوض';
      case 'info_needed':
        return 'يحتاج معلومات';
      default:
        return status;
    }
  }
}

class UserInfo {
  final String id;
  final String fullName;
  final String phonenumber;

  UserInfo({
    required this.id,
    required this.fullName,
    required this.phonenumber,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
    );
  }
}

class RequestFormInfo {
  final String id;
  final String title;
  final String? description;
  final double feeAmount;
  final List<String>? attachmentsRequired;

  RequestFormInfo({
    required this.id,
    required this.title,
    this.description,
    required this.feeAmount,
    this.attachmentsRequired,
  });

  factory RequestFormInfo.fromJson(Map<String, dynamic> json) {
    return RequestFormInfo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      feeAmount: double.parse(json['fee_amount'].toString()),
      attachmentsRequired: json['attachments_required'] != null 
          ? List<String>.from(json['attachments_required']) 
          : null,
    );
  }
}
