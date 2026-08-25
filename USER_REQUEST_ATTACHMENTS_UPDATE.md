# User Request Attachments - Updated Documentation

## Overview
The User Request system has been updated to handle attachments with field names. Each uploaded file is now associated with its corresponding form field, making it easier to identify which document belongs to which field.

---

## Changes Summary

### Previous Behavior
- All attachments were uploaded as a simple array
- No way to identify which file belongs to which field

### New Behavior
- Each attachment is stored with its field name as the key
- Single files are stored as strings
- Multiple files for a field are stored as arrays
- Easy identification of which document belongs to which field

---

## API Endpoint: Submit User Request

### Endpoint
```
POST /api/user-requests
```

### Headers
```
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
```

### Request Body Structure

The request uses `multipart/form-data` to handle both JSON data and file uploads.

#### Required Fields
- `request_form_id` (string): The ULID of the request form
- `data` (JSON string): Form field values as JSON string

#### Dynamic File Fields
File fields are determined by the request form's field definitions. For each field with `type: "file"` in the request form, you can upload files using the field's `name` as the key.

### Example Request

#### Scenario: Building Permit Request Form
Suppose the request form has these file fields:
- `national_id_copy` (single file, required)
- `property_deed` (single file, required)
- `building_plans` (multiple files, optional)
- `photos` (multiple files, optional)

#### cURL Example
```bash
curl -X POST http://localhost:8000/api/user-requests \
  -H "Authorization: Bearer {your_token}" \
  -F "request_form_id=01JH2K3M4N5P6Q7R8S9T0V1W2X" \
  -F 'data={"applicant_name":"محمد أحمد","phone":"0501234567","property_location":"الرياض، حي الملز"}' \
  -F "national_id_copy=@/path/to/national_id.pdf" \
  -F "property_deed=@/path/to/property_deed.pdf" \
  -F "building_plans[]=@/path/to/floor_plan.pdf" \
  -F "building_plans[]=@/path/to/elevation_plan.pdf" \
  -F "photos[]=@/path/to/photo1.jpg" \
  -F "photos[]=@/path/to/photo2.jpg"
```

#### JavaScript (Axios) Example
```javascript
const formData = new FormData();

// Add basic fields
formData.append('request_form_id', '01JH2K3M4N5P6Q7R8S9T0V1W2X');

// Add form data as JSON string
const data = {
  applicant_name: 'محمد أحمد',
  phone: '0501234567',
  property_location: 'الرياض، حي الملز'
};
formData.append('data', JSON.stringify(data));

// Add single files
formData.append('national_id_copy', nationalIdFile); // File object
formData.append('property_deed', propertyDeedFile); // File object

// Add multiple files for a field
buildingPlans.forEach(file => {
  formData.append('building_plans[]', file); // File objects
});

photos.forEach(file => {
  formData.append('photos[]', file); // File objects
});

// Send request
const response = await axios.post('/api/user-requests', formData, {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'multipart/form-data'
  }
});
```

#### Flutter/Dart Example
```dart
import 'package:dio/dio.dart';

Future<void> submitUserRequest() async {
  final dio = Dio();
  
  FormData formData = FormData.fromMap({
    'request_form_id': '01JH2K3M4N5P6Q7R8S9T0V1W2X',
    'data': jsonEncode({
      'applicant_name': 'محمد أحمد',
      'phone': '0501234567',
      'property_location': 'الرياض، حي الملز',
    }),
    
    // Single files
    'national_id_copy': await MultipartFile.fromFile(
      '/path/to/national_id.pdf',
      filename: 'national_id.pdf',
    ),
    'property_deed': await MultipartFile.fromFile(
      '/path/to/property_deed.pdf',
      filename: 'property_deed.pdf',
    ),
    
    // Multiple files - use field name with array notation
    'building_plans[]': [
      await MultipartFile.fromFile('/path/to/floor_plan.pdf'),
      await MultipartFile.fromFile('/path/to/elevation_plan.pdf'),
    ],
    'photos[]': [
      await MultipartFile.fromFile('/path/to/photo1.jpg'),
      await MultipartFile.fromFile('/path/to/photo2.jpg'),
    ],
  });
  
  final response = await dio.post(
    'http://localhost:8000/api/user-requests',
    data: formData,
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
}
```

---

## Response Format

### Success Response (201 Created)
```json
{
  "success": true,
  "message": "Request submitted successfully",
  "data": {
    "id": "01JH2K3M4N5P6Q7R8S9T0V1W2X",
    "request_form_id": "01JH2K3M4N5P6Q7R8S9T0V1W2X",
    "request_form": {
      "id": "01JH2K3M4N5P6Q7R8S9T0V1W2X",
      "title": "طلب رخصة البناء",
      "description": "نموذج لطلب رخصة بناء جديدة",
      "status": "active"
    },
    "user_id": "01JH2K3M4N5P6Q7R8S9T0V1W2X",
    "user": {
      "id": "01JH2K3M4N5P6Q7R8S9T0V1W2X",
      "full_name": "محمد أحمد",
      "email": "mohamed@example.com",
      "phone": "0501234567"
    },
    "data": {
      "applicant_name": "محمد أحمد",
      "phone": "0501234567",
      "property_location": "الرياض، حي الملز"
    },
    "attachments": {
      "national_id_copy": "http://localhost:8000/storage/requests/attachments/1704360000_national_id.pdf",
      "property_deed": "http://localhost:8000/storage/requests/attachments/1704360001_property_deed.pdf",
      "building_plans": [
        "http://localhost:8000/storage/requests/attachments/1704360002_floor_plan.pdf",
        "http://localhost:8000/storage/requests/attachments/1704360003_elevation_plan.pdf"
      ],
      "photos": [
        "http://localhost:8000/storage/requests/attachments/1704360004_photo1.jpg",
        "http://localhost:8000/storage/requests/attachments/1704360005_photo2.jpg"
      ]
    },
    "status": "pending",
    "admin_note": null,
    "created_at": "2026-01-04T12:00:00.000000Z",
    "updated_at": "2026-01-04T12:00:00.000000Z"
  }
}
```

### Validation Error Response (422 Unprocessable Entity)
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "request_form_id": [
      "The request form id field is required."
    ],
    "national_id_copy": [
      "The national id copy field is required.",
      "The national id copy must be a file of type: jpg, jpeg, png, pdf, doc, docx."
    ],
    "building_plans.0": [
      "The building plans.0 must be a file of type: jpg, jpeg, png, pdf, doc, docx."
    ]
  }
}
```

---

## Attachments Structure Explanation

### Single File Field
When a field accepts only one file:
```json
{
  "attachments": {
    "national_id_copy": "http://localhost:8000/storage/requests/attachments/file.pdf"
  }
}
```

### Multiple Files Field
When a field accepts multiple files:
```json
{
  "attachments": {
    "photos": [
      "http://localhost:8000/storage/requests/attachments/photo1.jpg",
      "http://localhost:8000/storage/requests/attachments/photo2.jpg",
      "http://localhost:8000/storage/requests/attachments/photo3.jpg"
    ]
  }
}
```

### Mixed Example
```json
{
  "attachments": {
    "national_id_copy": "http://localhost:8000/storage/requests/attachments/national_id.pdf",
    "property_deed": "http://localhost:8000/storage/requests/attachments/deed.pdf",
    "building_plans": [
      "http://localhost:8000/storage/requests/attachments/plan1.pdf",
      "http://localhost:8000/storage/requests/attachments/plan2.pdf"
    ],
    "photos": [
      "http://localhost:8000/storage/requests/attachments/photo1.jpg",
      "http://localhost:8000/storage/requests/attachments/photo2.jpg"
    ]
  }
}
```

---

## Validation Rules

### Dynamic File Validation
The validation rules are automatically generated based on the request form's field definitions:

1. **Required Files**: If the field has `"required": true`, the file must be uploaded
2. **Optional Files**: If the field has `"required": false`, the file is optional
3. **Multiple Files**: If the field has `"multiple": true`, the field accepts an array of files
4. **Allowed Types**: jpg, jpeg, png, pdf, doc, docx
5. **Max Size**: 10MB per file (10240 KB)

### Example Request Form Field Definition
```json
{
  "fields": [
    {
      "name": "national_id_copy",
      "type": "file",
      "label": "نسخة من الهوية الوطنية",
      "required": true,
      "multiple": false
    },
    {
      "name": "photos",
      "type": "file",
      "label": "صور الموقع",
      "required": false,
      "multiple": true
    }
  ]
}
```

This will generate validation rules:
```php
[
  'national_id_copy' => 'required|file|mimes:jpg,jpeg,png,pdf,doc,docx|max:10240',
  'photos' => 'nullable|array',
  'photos.*' => 'file|mimes:jpg,jpeg,png,pdf,doc,docx|max:10240'
]
```

---

## Frontend Implementation Tips

### 1. Get Request Form Details First
Before submitting, fetch the request form to know which file fields are required:
```javascript
const form = await axios.get(`/api/request-forms/${formId}`);
const fileFields = form.data.data.fields.filter(f => f.type === 'file');
```

### 2. Build FormData Dynamically
```javascript
const formData = new FormData();
formData.append('request_form_id', formId);
formData.append('data', JSON.stringify(textFieldsData));

// Add files based on field definitions
fileFields.forEach(field => {
  if (field.multiple) {
    // Multiple files - append with []
    files[field.name]?.forEach(file => {
      formData.append(`${field.name}[]`, file);
    });
  } else {
    // Single file
    if (files[field.name]) {
      formData.append(field.name, files[field.name]);
    }
  }
});
```

### 3. Display Attachments
When displaying submitted requests, group attachments by field:
```javascript
const attachments = response.data.data.attachments;

Object.keys(attachments).forEach(fieldName => {
  const fieldLabel = getFieldLabel(fieldName); // Get from form definition
  const files = Array.isArray(attachments[fieldName]) 
    ? attachments[fieldName] 
    : [attachments[fieldName]];
  
  console.log(`${fieldLabel}:`);
  files.forEach(url => console.log(`  - ${url}`));
});
```

### 4. Download Attachments
```javascript
function downloadAttachment(url, filename) {
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  link.click();
}
```

---

## Database Schema

The attachments column in the `user_requests` table stores JSON:
```sql
attachments JSON NULL -- Stores field_name => url(s) mapping
```

Example stored value:
```json
{
  "national_id_copy": "storage/requests/attachments/abc123.pdf",
  "property_deed": "storage/requests/attachments/xyz456.pdf",
  "photos": [
    "storage/requests/attachments/img1.jpg",
    "storage/requests/attachments/img2.jpg"
  ]
}
```

---

## Error Handling

### Common Errors

1. **File Too Large**
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "national_id_copy": [
      "The national id copy must not be greater than 10240 kilobytes."
    ]
  }
}
```

2. **Invalid File Type**
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "property_deed": [
      "The property deed must be a file of type: jpg, jpeg, png, pdf, doc, docx."
    ]
  }
}
```

3. **Missing Required File**
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "national_id_copy": [
      "The national id copy field is required."
    ]
  }
}
```

---

## Testing Examples

### Test with cURL
```bash
# Single file
curl -X POST http://localhost:8000/api/user-requests \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "request_form_id=01JH2K3M4N5P6Q7R8S9T0V1W2X" \
  -F 'data={"name":"Test User"}' \
  -F "national_id_copy=@test_file.pdf"

# Multiple files
curl -X POST http://localhost:8000/api/user-requests \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "request_form_id=01JH2K3M4N5P6Q7R8S9T0V1W2X" \
  -F 'data={"name":"Test User"}' \
  -F "photos[]=@photo1.jpg" \
  -F "photos[]=@photo2.jpg"
```

### Test with Postman
1. Set method to POST: `/api/user-requests`
2. Add Authorization header: `Bearer YOUR_TOKEN`
3. Select Body → form-data
4. Add key `request_form_id` with value
5. Add key `data` with JSON string value
6. Add file fields:
   - For single file: Key = `national_id_copy`, Type = File, Value = select file
   - For multiple files: Key = `photos[]`, Type = File, Value = select files (add multiple rows)

---

## Notes

- All file URLs are full URLs including domain (e.g., `http://localhost:8000/storage/...`)
- Files are stored in `storage/app/public/requests/attachments/`
- File names are automatically prefixed with timestamp to avoid conflicts
- Supported MIME types: jpg, jpeg, png, pdf, doc, docx
- Maximum file size: 10MB per file
- The `data` field must be a valid JSON string when sent as multipart form data
- Field names must exactly match the field definitions in the request form
