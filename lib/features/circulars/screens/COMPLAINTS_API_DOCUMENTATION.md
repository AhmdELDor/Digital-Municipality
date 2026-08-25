# Complaints API Documentation

## Overview
The Complaints API allows users to submit, view, update, and manage complaints. Each complaint can include a title, description, images, and status tracking.

---

## Endpoints

### 1. List All Complaints
**Endpoint:** `GET /api/complaints`

**Description:** Retrieve a paginated list of all complaints with search functionality.

**Query Parameters:**
- `search` (optional): Search text to filter complaints by title, user name, or phone number
- `page` (optional): Page number for pagination (default: 1)

**Request Example:**
```http
GET /api/complaints?search=water&page=1
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Complaints retrieved successfully",
    "data": [
        {
            "id": "01HM123...",
            "title": "Water supply issue",
            "desc": "No water supply in our area for 3 days",
            "user": {
                "full_name": "Ahmed Ali",
                "phonenumber": "0123456789"
            },
            "images_url": ["storage/complaints/images/image1.jpg"],
            "status": "received",
            "result": null,
            "created_at": "2026-01-01T10:30:00.000000Z",
            "updated_at": "2026-01-01T10:30:00.000000Z"
        }
    ],
    "pagination": {
        "current_page": 1,
        "last_page": 5,
        "per_page": 10,
        "total": 47
    }
}
```

---

### 2. Create a New Complaint
**Endpoint:** `POST /api/complaints`

**Description:** Submit a new complaint.

**Headers:**
- `Content-Type: multipart/form-data`
- `Authorization: Bearer {token}`

**Request Body:**
```json
{
    "title": "Street lighting not working",
    "desc": "The street lights on Main Road have been out for a week",
    "images": [File, File],  // Optional: Array of image files
    "result": null  // Optional
}
```

**Validation Rules:**
- `title`: Required, string, max 255 characters
- `desc`: Required, string
- `images`: Optional, array of image files
- `images.*`: File, mimes: jpg, jpeg, png, svg, max size: 5MB (5120KB)
- `result`: Optional, string

**Response (201 Created):**
```json
{
    "status": "success",
    "message": "Complaint created successfully",
    "data": {
        "id": "01HM456...",
        "title": "Street lighting not working",
        "desc": "The street lights on Main Road have been out for a week",
        "user": {
            "full_name": "Ahmed Ali",
            "phonenumber": "0123456789"
        },
        "images_url": [
            "storage/complaints/images/image1.jpg",
            "storage/complaints/images/image2.jpg"
        ],
        "status": "received",
        "result": null,
        "created_at": "2026-01-01T12:00:00.000000Z",
        "updated_at": "2026-01-01T12:00:00.000000Z"
    }
}
```

---

### 3. View Single Complaint
**Endpoint:** `GET /api/complaints/{id}`

**Description:** Retrieve details of a specific complaint.

**Request Example:**
```http
GET /api/complaints/01HM456...
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Complaint retrieved successfully",
    "data": {
        "id": "01HM456...",
        "title": "Street lighting not working",
        "desc": "The street lights on Main Road have been out for a week",
        "user": {
            "full_name": "Ahmed Ali",
            "phonenumber": "0123456789"
        },
        "images_url": [
            "storage/complaints/images/image1.jpg"
        ],
        "status": "received",
        "result": null,
        "created_at": "2026-01-01T12:00:00.000000Z",
        "updated_at": "2026-01-01T12:00:00.000000Z"
    }
}
```

---

### 4. Update a Complaint
**Endpoint:** `PUT/PATCH /api/complaints/{id}`

**Description:** Update an existing complaint.

**Headers:**
- `Content-Type: multipart/form-data`
- `Authorization: Bearer {token}`

**Request Body:**
```json
{
    "title": "Updated title",  // Optional
    "desc": "Updated description",  // Optional
    "images": [File, File],  // Optional
    "result": "Resolved by maintenance team"  // Optional
}
```

**Validation Rules:**
- `title`: Optional, string, max 255 characters
- `desc`: Optional, string
- `images`: Optional, array of image files (replaces old images)
- `images.*`: File, mimes: jpg, jpeg, png, svg, max size: 5MB
- `result`: Optional, string

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Complaint updated successfully",
    "data": {
        "id": "01HM456...",
        "title": "Updated title",
        "desc": "Updated description",
        "user": {
            "full_name": "Ahmed Ali",
            "phonenumber": "0123456789"
        },
        "images_url": [
            "storage/complaints/images/new_image.jpg"
        ],
        "status": "received",
        "result": "Resolved by maintenance team",
        "created_at": "2026-01-01T12:00:00.000000Z",
        "updated_at": "2026-01-01T13:30:00.000000Z"
    }
}
```

---

### 5. Delete a Complaint
**Endpoint:** `DELETE /api/complaints/{id}`

**Description:** Delete a complaint and its associated images.

**Request Example:**
```http
DELETE /api/complaints/01HM456...
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
    "status": "success",
    "message": "Complaint deleted successfully",
    "data": null
}
```

---

## Data Structure

### Complaint Object
```json
{
    "id": "ULID string",
    "title": "string (max 255)",
    "desc": "text",
    "user": {
        "full_name": "string",
        "phonenumber": "string"
    },
    "images_url": ["array of image paths"],
    "status": "received",
    "result": "text or null",
    "created_at": "timestamp",
    "updated_at": "timestamp"
}
```

### Status Values
- `received`: Default status when complaint is submitted

---

## Search Functionality

The search feature allows you to find complaints by:
- **Title**: Partial match on complaint title
- **User Name**: Partial match on user's full name
- **Phone Number**: Partial match on user's phone number

**Example:**
```http
GET /api/complaints?search=ahmed
```
This will return all complaints where:
- Title contains "ahmed", OR
- User's full name contains "ahmed", OR
- User's phone number contains "ahmed"

---

## Error Responses

### 401 Unauthorized
```json
{
    "message": "Unauthenticated."
}
```

### 404 Not Found
```json
{
    "status": "error",
    "message": "Complaint not found"
}
```

### 422 Validation Error
```json
{
    "message": "The given data was invalid.",
    "errors": {
        "title": ["The title field is required."],
        "images.0": ["The file must be an image."]
    }
}
```

---

## Notes

1. **Authentication**: All endpoints require authentication using Bearer token
2. **User Association**: Complaints are automatically associated with the authenticated user
3. **File Management**: When updating images, old images are automatically deleted
4. **File Size Limit**: Maximum image size is 5MB per file
5. **Allowed Image Types**: jpg, jpeg, png, svg
6. **Pagination**: Results are paginated with 10 items per page by default
7. **User Privacy**: Only user's name and phone number are returned in responses (no user ID or other sensitive data)
