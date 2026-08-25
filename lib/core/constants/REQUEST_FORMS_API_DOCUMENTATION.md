# Request Forms & User Requests API Documentation

## Overview
This API provides endpoints for managing dynamic request forms and user-submitted requests. The system allows administrators to create customizable forms with dynamic fields, and users can submit requests with file attachments. All uploaded files are stored in the storage directory, and their URLs are saved in the database.

---

## Table of Contents
- [Authentication](#authentication)
- [Request Forms Management (Admin Only)](#request-forms-management-admin-only)
- [User Requests (Citizens)](#user-requests-citizens)
- [File Upload System](#file-upload-system)
- [Data Structures](#data-structures)
- [Status Codes](#status-codes)

---

## Authentication
All endpoints require authentication using Laravel Sanctum. Include the bearer token in the Authorization header:
```
Authorization: Bearer {token}
```

**Admin Endpoints**: Require `admin` or `superadmin` role.
**User Endpoints**: Accessible to all authenticated users.

---

## Request Forms Management (Admin Only)

### 1. Get All Request Forms
Retrieve a paginated list of all request forms.

**Endpoint**: `GET /api/request-forms`  
**Access**: Admin/SuperAdmin  
**Authentication**: Required

#### Request
```http
GET /api/request-forms HTTP/1.1
Host: your-domain.com
Authorization: Bearer {admin_token}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request forms retrieved successfully",
  "data": [
    {
      "id": "01JGABCD1234567890ABCDEFGH",
      "title": "Building Permit Application",
      "description": "Submit your building permit request with required documents",
      "fields": [
        {
          "name": "property_address",
          "type": "text",
          "label": "Property Address",
          "required": true,
          "placeholder": "Enter full address"
        },
        {
          "name": "building_type",
          "type": "select",
          "label": "Building Type",
          "required": true,
          "options": ["Residential", "Commercial", "Industrial"]
        },
        {
          "name": "plot_area",
          "type": "number",
          "label": "Plot Area (sq meters)",
          "required": true
        },
        {
          "name": "additional_notes",
          "type": "textarea",
          "label": "Additional Notes",
          "required": false
        }
      ],
      "version": "1.0",
      "status": "active",
      "instructions": "Please ensure all documents are clear and valid",
      "attachments_required": ["Property Deed", "ID Card", "Building Plans"],
      "fee_amount": "500.00",
      "allowed_file_types": ["pdf", "png", "jpg"],
      "created_at": "2025-12-20T10:00:00.000000Z",
      "updated_at": "2025-12-20T10:00:00.000000Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 10,
    "total": 5,
    "last_page": 1
  }
}
```

---

### 2. Create New Request Form
Create a new dynamic request form.

**Endpoint**: `POST /api/request-forms`  
**Access**: Admin/SuperAdmin  
**Authentication**: Required

#### Request Body
```json
{
  "title": "Business License Application",
  "description": "Apply for a new business license",
  "fields": [
    {
      "name": "business_name",
      "type": "text",
      "label": "Business Name",
      "required": true,
      "placeholder": "Enter business name"
    },
    {
      "name": "business_type",
      "type": "select",
      "label": "Business Type",
      "required": true,
      "options": ["Retail", "Restaurant", "Services", "Manufacturing"]
    },
    {
      "name": "number_of_employees",
      "type": "number",
      "label": "Number of Employees",
      "required": true
    },
    {
      "name": "business_description",
      "type": "textarea",
      "label": "Business Description",
      "required": true
    }
  ],
  "version": "1.0",
  "status": "active",
  "instructions": "Please provide accurate information about your business",
  "attachments_required": ["Commercial Register", "Tax Certificate", "ID Card"],
  "fee_amount": 300.00,
  "allowed_file_types": ["pdf", "jpg", "png", "doc", "docx"]
}
```

#### Field Types Available
- `text`: Single line text input
- `textarea`: Multi-line text input
- `number`: Numeric input
- `email`: Email input
- `date`: Date picker
- `select`: Dropdown selection
- `radio`: Radio buttons
- `checkbox`: Checkboxes
- `file`: File upload

#### Response (201 Created)
```json
{
  "success": true,
  "message": "Request form created successfully",
  "data": {
    "id": "01JGABCD1234567890ABCDEFGH",
    "title": "Business License Application",
    "description": "Apply for a new business license",
    "fields": [...],
    "version": "1.0",
    "status": "active",
    "instructions": "Please provide accurate information about your business",
    "attachments_required": ["Commercial Register", "Tax Certificate", "ID Card"],
    "fee_amount": "300.00",
    "allowed_file_types": ["pdf", "jpg", "png", "doc", "docx"],
    "created_at": "2026-01-04T08:30:00.000000Z",
    "updated_at": "2026-01-04T08:30:00.000000Z"
  }
}
```

#### Validation Rules
- `title`: required, string, max:255
- `description`: optional, string
- `fields`: required, array (must contain field definitions)
- `version`: optional, string
- `status`: required, one of: active, inactive
- `instructions`: optional, string
- `attachments_required`: optional, array
- `fee_amount`: required, numeric, minimum 0
- `allowed_file_types`: optional, array

---

### 3. Get Single Request Form
Retrieve details of a specific request form.

**Endpoint**: `GET /api/request-forms/{id}`  
**Access**: Admin/SuperAdmin  
**Authentication**: Required

#### Request
```http
GET /api/request-forms/01JGABCD1234567890ABCDEFGH HTTP/1.1
Host: your-domain.com
Authorization: Bearer {admin_token}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request form retrieved successfully",
  "data": {
    "id": "01JGABCD1234567890ABCDEFGH",
    "title": "Building Permit Application",
    "description": "Submit your building permit request",
    "fields": [...],
    "version": "1.0",
    "status": "active",
    "instructions": "Please ensure all documents are clear",
    "attachments_required": ["Property Deed", "ID Card", "Building Plans"],
    "fee_amount": "500.00",
    "allowed_file_types": ["pdf", "png", "jpg"],
    "created_at": "2025-12-20T10:00:00.000000Z",
    "updated_at": "2025-12-20T10:00:00.000000Z"
  }
}
```

---

### 4. Update Request Form
Update an existing request form.

**Endpoint**: `PUT /api/request-forms/{id}`  
**Access**: Admin/SuperAdmin  
**Authentication**: Required

#### Request Body
```json
{
  "title": "Updated Building Permit Application",
  "description": "Submit your building permit request with updated requirements",
  "fields": [
    {
      "name": "property_address",
      "type": "text",
      "label": "Property Address",
      "required": true
    }
  ],
  "version": "1.1",
  "status": "active",
  "fee_amount": 550.00
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request form updated successfully",
  "data": {
    "id": "01JGABCD1234567890ABCDEFGH",
    "title": "Updated Building Permit Application",
    "description": "Submit your building permit request with updated requirements",
    "version": "1.1",
    "fee_amount": "550.00",
    ...
  }
}
```

---

### 5. Delete Request Form
Delete a request form.

**Endpoint**: `DELETE /api/request-forms/{id}`  
**Access**: Admin/SuperAdmin  
**Authentication**: Required

#### Request
```http
DELETE /api/request-forms/01JGABCD1234567890ABCDEFGH HTTP/1.1
Host: your-domain.com
Authorization: Bearer {admin_token}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request form deleted successfully",
  "data": null
}
```

---

## User Requests (Citizens)

### 1. Get User's Requests
Retrieve all requests submitted by the authenticated user.

**Endpoint**: `GET /api/user-requests`  
**Access**: Authenticated Users  
**Authentication**: Required

#### Request
```http
GET /api/user-requests HTTP/1.1
Host: your-domain.com
Authorization: Bearer {user_token}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "User requests retrieved successfully",
  "data": [
    {
      "id": "01JGXYZ9876543210ZYXWVUTSR",
      "user": {
        "id": "01JGUSER123456789012345678",
        "full_name": "محمد أحمد",
        "phonenumber": "+964770XXXXXXX"
      },
      "request_form": {
        "id": "01JGABCD1234567890ABCDEFGH",
        "title": "Building Permit Application",
        "description": "Submit your building permit request",
        "fee_amount": "500.00"
      },
      "data": {
        "property_address": "Baghdad, Al-Mansour, Street 14",
        "building_type": "Residential",
        "plot_area": 250,
        "additional_notes": "Need urgent processing"
      },
      "attachments": [
        "storage/requests/attachments/01JGXYZ_property_deed.pdf",
        "storage/requests/attachments/01JGXYZ_id_card.jpg",
        "storage/requests/attachments/01JGXYZ_building_plans.pdf"
      ],
      "status": "pending",
      "admin_note": null,
      "created_at": "2026-01-03T14:25:00.000000Z",
      "updated_at": "2026-01-03T14:25:00.000000Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 10,
    "total": 3,
    "last_page": 1
  }
}
```

---

### 2. Submit New Request
Submit a new request with form data and file attachments.

**Endpoint**: `POST /api/user-requests`  
**Access**: Authenticated Users  
**Authentication**: Required  
**Content-Type**: `multipart/form-data`

#### Request Body (multipart/form-data)
```
POST /api/user-requests HTTP/1.1
Host: your-domain.com
Authorization: Bearer {user_token}
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="request_form_id"

01JGABCD1234567890ABCDEFGH
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="data"

{"property_address":"Baghdad, Al-Mansour, Street 14","building_type":"Residential","plot_area":250,"additional_notes":"Need urgent processing"}
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="attachments[]"; filename="property_deed.pdf"
Content-Type: application/pdf

[PDF Binary Data]
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="attachments[]"; filename="id_card.jpg"
Content-Type: image/jpeg

[Image Binary Data]
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="attachments[]"; filename="building_plans.pdf"
Content-Type: application/pdf

[PDF Binary Data]
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

#### JavaScript Example (Fetch API)
```javascript
const formData = new FormData();

// Add request form ID
formData.append('request_form_id', '01JGABCD1234567890ABCDEFGH');

// Add form data as JSON string
const data = {
  property_address: "Baghdad, Al-Mansour, Street 14",
  building_type: "Residential",
  plot_area: 250,
  additional_notes: "Need urgent processing"
};
formData.append('data', JSON.stringify(data));

// Add multiple files
formData.append('attachments[]', propertyDeedFile);
formData.append('attachments[]', idCardFile);
formData.append('attachments[]', buildingPlansFile);

// Send request
fetch('/api/user-requests', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer ' + token,
    // Don't set Content-Type - browser will set it with boundary
  },
  body: formData
})
.then(response => response.json())
.then(data => console.log(data));
```

#### cURL Example
```bash
curl -X POST https://your-domain.com/api/user-requests \
  -H "Authorization: Bearer {user_token}" \
  -F "request_form_id=01JGABCD1234567890ABCDEFGH" \
  -F 'data={"property_address":"Baghdad, Al-Mansour, Street 14","building_type":"Residential","plot_area":250}' \
  -F "attachments[]=@/path/to/property_deed.pdf" \
  -F "attachments[]=@/path/to/id_card.jpg" \
  -F "attachments[]=@/path/to/building_plans.pdf"
```

#### Response (201 Created)
```json
{
  "success": true,
  "message": "Request submitted successfully",
  "data": {
    "id": "01JGXYZ9876543210ZYXWVUTSR",
    "user": {
      "id": "01JGUSER123456789012345678",
      "full_name": "محمد أحمد",
      "phonenumber": "+964770XXXXXXX"
    },
    "request_form": {
      "id": "01JGABCD1234567890ABCDEFGH",
      "title": "Building Permit Application",
      "fee_amount": "500.00"
    },
    "data": {
      "property_address": "Baghdad, Al-Mansour, Street 14",
      "building_type": "Residential",
      "plot_area": 250,
      "additional_notes": "Need urgent processing"
    },
    "attachments": [
      "storage/requests/attachments/01JGXYZ9876_property_deed.pdf",
      "storage/requests/attachments/01JGXYZ9876_id_card.jpg",
      "storage/requests/attachments/01JGXYZ9876_building_plans.pdf"
    ],
    "status": "pending",
    "admin_note": null,
    "created_at": "2026-01-04T10:00:00.000000Z",
    "updated_at": "2026-01-04T10:00:00.000000Z"
  }
}
```

#### Validation Rules
- `request_form_id`: required, must exist in request_forms table
- `data`: required, JSON object containing form field values
- `attachments`: optional, array of files
- `attachments.*`: file, allowed types: jpg, jpeg, png, pdf, doc, docx, max size: 10MB

---

### 3. Get Single Request
Retrieve details of a specific user request.

**Endpoint**: `GET /api/user-requests/{id}`  
**Access**: Authenticated Users (own requests only)  
**Authentication**: Required

#### Request
```http
GET /api/user-requests/01JGXYZ9876543210ZYXWVUTSR HTTP/1.1
Host: your-domain.com
Authorization: Bearer {user_token}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request details retrieved successfully",
  "data": {
    "id": "01JGXYZ9876543210ZYXWVUTSR",
    "user": {
      "id": "01JGUSER123456789012345678",
      "full_name": "محمد أحمد",
      "phonenumber": "+964770XXXXXXX"
    },
    "request_form": {
      "id": "01JGABCD1234567890ABCDEFGH",
      "title": "Building Permit Application",
      "description": "Submit your building permit request",
      "fee_amount": "500.00"
    },
    "data": {
      "property_address": "Baghdad, Al-Mansour, Street 14",
      "building_type": "Residential",
      "plot_area": 250,
      "additional_notes": "Need urgent processing"
    },
    "attachments": [
      "storage/requests/attachments/01JGXYZ9876_property_deed.pdf",
      "storage/requests/attachments/01JGXYZ9876_id_card.jpg",
      "storage/requests/attachments/01JGXYZ9876_building_plans.pdf"
    ],
    "status": "approved",
    "admin_note": "Your building permit has been approved. You can collect it from our office.",
    "created_at": "2026-01-03T14:25:00.000000Z",
    "updated_at": "2026-01-04T09:15:00.000000Z"
  }
}
```

#### Error Response (403 Forbidden)
If user tries to access another user's request:
```json
{
  "success": false,
  "message": "Unauthorized"
}
```

---

### 4. Update Request Status (Admin)
Update the status and add admin notes to a user request.

**Endpoint**: `PUT /api/user-requests/{id}`  
**Access**: Admin/SuperAdmin  
**Authentication**: Required

#### Request Body
```json
{
  "status": "approved",
  "admin_note": "Your building permit has been approved. You can collect it from our office within 7 days."
}
```

#### Status Values
- `pending`: Initial status when request is submitted
- `approved`: Request has been approved
- `rejected`: Request has been rejected
- `info_needed`: More information required from user

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request updated successfully",
  "data": {
    "id": "01JGXYZ9876543210ZYXWVUTSR",
    "status": "approved",
    "admin_note": "Your building permit has been approved. You can collect it from our office within 7 days.",
    ...
  }
}
```

---

### 5. Delete Request
Delete a pending request (only if status is pending).

**Endpoint**: `DELETE /api/user-requests/{id}`  
**Access**: Authenticated Users (own requests only)  
**Authentication**: Required

#### Request
```http
DELETE /api/user-requests/01JGXYZ9876543210ZYXWVUTSR HTTP/1.1
Host: your-domain.com
Authorization: Bearer {user_token}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Request deleted successfully",
  "data": null
}
```

#### Error Response (400 Bad Request)
If trying to delete a request that is being processed:
```json
{
  "success": false,
  "message": "Cannot delete a request that is being processed"
}
```

---

## File Upload System

### Storage Structure
All uploaded files are stored in the Laravel storage directory:
```
storage/
  app/
    public/
      requests/
        attachments/
          {ulid}_{filename}.{extension}
```

### File Upload Process
1. **User uploads files**: Files are sent in the request as `multipart/form-data`
2. **Server validates files**: Checks file type, size, and other constraints
3. **Files are stored**: Files saved to `storage/app/public/requests/attachments/`
4. **URLs are saved**: File paths are stored in database as JSON array in `attachments` column

### File Naming Convention
Files are renamed with ULID prefix for uniqueness:
```
Original: property_deed.pdf
Stored as: 01JGXYZ9876543210_property_deed.pdf
Database URL: storage/requests/attachments/01JGXYZ9876543210_property_deed.pdf
```

### Accessing Uploaded Files
To make uploaded files accessible via URL, ensure storage link is created:
```bash
php artisan storage:link
```

Files can then be accessed via:
```
https://your-domain.com/storage/requests/attachments/01JGXYZ9876543210_property_deed.pdf
```

### File Upload Constraints
- **Maximum file size**: 10MB (10240 KB) per file
- **Allowed file types**: jpg, jpeg, png, pdf, doc, docx
- **Multiple files**: Can upload multiple files in a single request

### File Deletion
When a user request is deleted (only if status is `pending`):
- All associated files are automatically deleted from storage
- Database record is removed

---

## Data Structures

### Request Form Schema
```typescript
{
  id: string (ULID),
  title: string,
  description: string | null,
  fields: Array<{
    name: string,
    type: 'text' | 'textarea' | 'number' | 'email' | 'date' | 'select' | 'radio' | 'checkbox' | 'file',
    label: string,
    required: boolean,
    placeholder?: string,
    options?: string[] // for select, radio, checkbox
  }>,
  version: string,
  status: 'active' | 'inactive',
  instructions: string | null,
  attachments_required: string[] | null,
  fee_amount: decimal,
  allowed_file_types: string[] | null,
  created_at: timestamp,
  updated_at: timestamp
}
```

### User Request Schema
```typescript
{
  id: string (ULID),
  user_id: string (ULID),
  request_form_id: string (ULID),
  data: object, // Dynamic based on form fields
  attachments: string[] | null, // Array of file paths
  status: 'pending' | 'approved' | 'rejected' | 'info_needed',
  admin_note: string | null,
  created_at: timestamp,
  updated_at: timestamp
}
```

---

## Status Codes

### Success Responses
- `200 OK`: Request successful
- `201 Created`: Resource created successfully

### Error Responses
- `400 Bad Request`: Invalid request data or validation error
- `401 Unauthorized`: Missing or invalid authentication token
- `403 Forbidden`: User doesn't have permission to access resource
- `404 Not Found`: Resource not found
- `422 Unprocessable Entity`: Validation failed

### Error Response Format
```json
{
  "success": false,
  "message": "Error message here",
  "errors": {
    "field_name": ["Error description"]
  }
}
```

---

## Examples

### Example 1: Creating a Water Connection Request Form

**Step 1: Admin creates form**
```json
POST /api/request-forms
{
  "title": "طلب توصيل ماء",
  "description": "تقديم طلب لتوصيل المياه إلى العقار",
  "fields": [
    {
      "name": "applicant_name",
      "type": "text",
      "label": "اسم مقدم الطلب",
      "required": true
    },
    {
      "name": "property_address",
      "type": "textarea",
      "label": "عنوان العقار",
      "required": true
    },
    {
      "name": "property_type",
      "type": "select",
      "label": "نوع العقار",
      "required": true,
      "options": ["سكني", "تجاري", "صناعي"]
    },
    {
      "name": "meter_location",
      "type": "text",
      "label": "موقع العداد المقترح",
      "required": true
    }
  ],
  "status": "active",
  "instructions": "يرجى إرفاق سند الملكية وصورة الهوية",
  "attachments_required": ["سند الملكية", "صورة الهوية", "خريطة الموقع"],
  "fee_amount": 150.00,
  "allowed_file_types": ["pdf", "jpg", "png"]
}
```

**Step 2: User submits request**
```bash
curl -X POST https://your-domain.com/api/user-requests \
  -H "Authorization: Bearer {user_token}" \
  -F "request_form_id=01JGWATER12345678901234567" \
  -F 'data={"applicant_name":"علي حسن","property_address":"بغداد، الكرادة، شارع 52","property_type":"سكني","meter_location":"أمام المنزل"}' \
  -F "attachments[]=@ownership_deed.pdf" \
  -F "attachments[]=@id_card.jpg" \
  -F "attachments[]=@location_map.png"
```

### Example 2: Admin Processing Request

**Step 1: Admin reviews and approves**
```json
PUT /api/user-requests/01JGREQ123456789012345678
{
  "status": "approved",
  "admin_note": "تم الموافقة على طلبكم. سيتم تركيب العداد خلال 5 أيام عمل. يرجى التواصل على 07700000000"
}
```

### Example 3: User Checks Request Status
```bash
curl -X GET https://your-domain.com/api/user-requests/01JGREQ123456789012345678 \
  -H "Authorization: Bearer {user_token}"
```

Response shows updated status and admin note:
```json
{
  "success": true,
  "message": "Request details retrieved successfully",
  "data": {
    "id": "01JGREQ123456789012345678",
    "status": "approved",
    "admin_note": "تم الموافقة على طلبكم. سيتم تركيب العداد خلال 5 أيام عمل.",
    ...
  }
}
```

---

## Notes

1. **File Storage**: All files are stored permanently until the request is deleted (only possible when status is `pending`)

2. **Security**: Users can only access their own requests. Attempting to access another user's request will return 403 Forbidden

3. **Dynamic Forms**: The `fields` array in request forms allows creating completely customizable forms without modifying code

4. **Data Validation**: The `data` field in user requests should match the structure defined in the request form's `fields` array

5. **File Types**: Ensure the files uploaded match the `allowed_file_types` specified in the request form

6. **Pagination**: All list endpoints return paginated results (10 items per page by default)

7. **Timestamps**: All timestamps are in ISO 8601 format with UTC timezone

---

## Testing with Postman

### Setting up environment variables
```
base_url: https://your-domain.com/api
admin_token: {your_admin_token}
user_token: {your_user_token}
```

### Test Collection Structure
1. **Authentication**
   - Login as Admin
   - Login as User

2. **Request Forms (Admin)**
   - Create Request Form
   - Get All Request Forms
   - Get Single Request Form
   - Update Request Form
   - Delete Request Form

3. **User Requests (Citizen)**
   - Submit Request (with files)
   - Get My Requests
   - Get Single Request
   - Delete Pending Request

4. **Admin Actions**
   - Update Request Status
   - Add Admin Note

---

## Support

For any issues or questions regarding the API, please contact the development team.

**Last Updated**: January 4, 2026  
**API Version**: 1.0
