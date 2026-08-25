# Notification Sending API - Quick Reference

## Admin Notification Endpoints

All endpoints require **Admin or SuperAdmin** authentication.

---

### 1. Send to All Citizens
Send notification to all users with role "citizen".

**POST** `/api/notifications/send-to-citizens`

**Body:**
```json
{
  "title": "إعلان للمواطنين",
  "body": "رسالة مهمة لجميع المواطنين",
  "type": "announcement",
  "data": {
    "priority": "high"
  },
  "image_url": "https://example.com/image.jpg"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent to all citizens successfully",
  "data": {
    "success": 150,
    "failure": 2
  }
}
```

---

### 2. Send to Specific Citizens (Bulk)
Send notification to specific citizen IDs.

**POST** `/api/notifications/send-to-bulk`

**Body:**
```json
{
  "user_ids": [
    "01JGUSER123456789012345678",
    "01JGUSER987654321098765432",
    "01JGUSER456789012345678901"
  ],
  "title": "تحديث على طلبكم",
  "body": "تم تحديث حالة طلبكم",
  "type": "request_update",
  "data": {
    "request_id": "01JGREQ123"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent to selected users successfully",
  "data": {
    "success": 3,
    "failure": 0
  }
}
```

---

### 3. Send to All Admins & SuperAdmins
Send notification to all users with role "admin" or "superadmin".

**POST** `/api/notifications/send-to-admins`

**Body:**
```json
{
  "title": "اجتماع الإدارة",
  "body": "اجتماع طارئ في الساعة 3 عصراً",
  "type": "meeting",
  "data": {
    "meeting_time": "15:00",
    "location": "قاعة الاجتماعات"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent to all admins successfully",
  "data": {
    "success": 10,
    "failure": 0
  }
}
```

---

### 4. Send to All Employees
Send notification to all users with role "employee".

**POST** `/api/notifications/send-to-employees`

**Body:**
```json
{
  "title": "تعليمات العمل",
  "body": "تعليمات جديدة لموظفي البلدية",
  "type": "instructions"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent to all employees successfully",
  "data": {
    "success": 45,
    "failure": 1
  }
}
```

---

### 5. Send by Role (Flexible)
Send notification to all users with a specific role.

**POST** `/api/notifications/send-by-role`

**Body:**
```json
{
  "role": "citizen",
  "title": "إشعار عام",
  "body": "رسالة لجميع المواطنين"
}
```

**Available roles:**
- `citizen`
- `employee`
- `admin`
- `superadmin`

**Response:**
```json
{
  "success": true,
  "message": "Notification sent to all citizens successfully",
  "data": {
    "success": 200,
    "failure": 5
  }
}
```

---

### 6. Send Test Notification
Send notification to a specific user (for testing).

**POST** `/api/notifications/send-test`

**Body:**
```json
{
  "user_id": "01JGUSER123456789012345678",
  "title": "اختبار الإشعار",
  "body": "هذا إشعار تجريبي",
  "type": "test"
}
```

---

### 7. Broadcast to Everyone
Send notification to ALL users in the system.

**POST** `/api/notifications/broadcast`

**Body:**
```json
{
  "title": "إعلان عام مهم",
  "body": "البلدية ستكون مغلقة يوم الجمعة",
  "type": "announcement",
  "image_url": "https://example.com/announcement.jpg"
}
```

---

## Request Parameters

### Required Fields
- `title` (string, max 255) - Notification title
- `body` (string) - Notification message body

### Optional Fields
- `type` (string) - Notification type: `general`, `announcement`, `request`, `complaint`, `bill`, `poll`, `meeting`, `instructions`
- `data` (object) - Additional data as JSON object
- `image_url` (url) - Image URL for rich notification

### Bulk Sending
- `user_ids` (array) - Array of user IDs (for bulk sending)
- `role` (string) - User role (for role-based sending)

---

## Response Format

**Success:**
```json
{
  "success": true,
  "message": "Notification sent successfully",
  "data": {
    "success": 150,  // Number of successful sends
    "failure": 2     // Number of failed sends
  }
}
```

**Error:**
```json
{
  "success": false,
  "message": "No users found"
}
```

---

## Usage Examples

### Example 1: Notify all citizens about new service

```bash
curl -X POST https://api.example.com/api/notifications/send-to-citizens \
  -H "Authorization: Bearer {admin_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "خدمة جديدة متاحة",
    "body": "يمكنكم الآن التقديم على رخصة البناء عبر التطبيق",
    "type": "announcement",
    "data": {
      "service_id": "building_permit"
    }
  }'
```

### Example 2: Notify specific citizens about request approval

```bash
curl -X POST https://api.example.com/api/notifications/send-to-bulk \
  -H "Authorization: Bearer {admin_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "user_ids": ["01JG001", "01JG002", "01JG003"],
    "title": "تمت الموافقة على طلبكم",
    "body": "يمكنكم استلام الرخصة من المكتب",
    "type": "request",
    "data": {
      "status": "approved"
    }
  }'
```

### Example 3: Emergency notification to all employees

```bash
curl -X POST https://api.example.com/api/notifications/send-to-employees \
  -H "Authorization: Bearer {admin_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "تنبيه طارئ",
    "body": "يرجى الحضور للعمل فوراً",
    "type": "emergency",
    "data": {
      "priority": "urgent"
    }
  }'
```

---

## Database Tables

The system uses existing tables:
- **device_tokens** - Stores FCM tokens for each user device
- **notifications** - Stores notification history

---

## Notes

1. **Firebase Required**: Ensure Firebase is configured in `.env`
2. **Device Registration**: Users must register their device tokens first
3. **Success/Failure Count**: Shows how many devices received the notification
4. **Notification History**: All sent notifications are stored in database
5. **Admin Only**: All these endpoints require admin or superadmin role

---

**Last Updated**: January 4, 2026
