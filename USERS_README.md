# User Management System - Admin Portal

## Overview

The Digital Municipality system includes a comprehensive user management system with role-based access control. This README provides complete documentation for implementing and managing users in the admin portal.

## User Roles

The system supports the following user roles:

- **`citizen`** - Regular users who can access public services and submit requests
- **`official`** - Municipality officials with elevated permissions
- **`admin`** - System administrators with full access to user management
- **`superadmin`** - Super administrators with complete system access

## User Model Structure

```php
User Model Fields:
- id: ULID (Primary Key)
- full_name: string (required)
- phonenumber: string (required, unique)
- role: string (default: 'citizen')
- address: string (nullable)
- password: string (hashed)
- created_at: timestamp
- updated_at: timestamp
```

## Authentication

### Admin Login
```http
POST /api/login/admin
Content-Type: application/json

{
  "phonenumber": "1111111111",
  "password": "password"
}
```

**Response:**
```json
{
  "code": 200,
  "data": {
    "user": {
      "id": "01KD...",
      "full_name": "Admin User",
      "phonenumber": "1111111111",
      "role": "admin",
      "address": "123 Admin Street, City, Country"
    },
    "token": "1|abc123..."
  },
  "message": "Admin login successful"
}
```

### Mobile/Citizen Login
```http
POST /api/login
Content-Type: application/json

{
  "phonenumber": "phone_number",
  "password": "password"
}
```

## Admin User Management API

All user management endpoints require authentication with `admin` or `superadmin` role.

### List Users
```http
GET /api/users
Authorization: Bearer {admin_token}
```

**Response:**
```json
{
  "code": 200,
  "data": [
    {
      "id": "01KD...",
      "full_name": "John Doe",
      "phonenumber": "1234567890",
      "role": "citizen",
      "address": "123 Main St"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 10,
    "total": 25,
    "next_page_url": "http://localhost:8000/api/users?page=2",
    "prev_page_url": null
  },
  "message": "Users retrieved successfully"
}
```

### Get Single User
```http
GET /api/users/{user_id}
Authorization: Bearer {admin_token}
```

### Create New User
```http
POST /api/users
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "full_name": "New User Name",
  "phonenumber": "9876543210",
  "role": "citizen",
  "address": "456 New Street, City",
  "password": "secure_password_123"
}
```

**Response:**
```json
{
  "code": 201,
  "data": {
    "id": "01KD...",
    "full_name": "New User Name",
    "phonenumber": "9876543210",
    "role": "citizen",
    "address": "456 New Street, City"
  },
  "message": "User created successfully"
}
```

**Validation Rules:**
- `full_name`: required, string, max 255 characters
- `phonenumber`: required, string, unique
- `role`: optional, string (defaults to 'citizen')
- `address`: required, string, max 255 characters
- `password`: required, string, min 8 characters

**Note:** Admin can fill all fields including the password. The password will be automatically hashed before storage.

### Update User
```http
PUT /api/users/{user_id}
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "full_name": "Updated Name",
  "phonenumber": "9876543210",
  "role": "official",
  "address": "Updated Address"
}
```

**Note:** Password is optional in updates. Phone number must be unique except for the current user.

### Delete User
```http
DELETE /api/users/{user_id}
Authorization: Bearer {admin_token}
```

## Sample Users (from Seeder)

The system includes sample users created by the `UserSeeder`:

### Admin User
- **Name:** Admin User
- **Phone:** 1111111111
- **Role:** admin
- **Password:** password
- **Address:** 123 Admin Street, City, Country

### Municipality Official
- **Name:** Municipality Official
- **Phone:** 2222222222
- **Role:** official
- **Password:** password
- **Address:** 456 Official Avenue, City, Country

### Citizen Users
10 additional users are created using the UserFactory with random data.

## Frontend Implementation Guide

### Admin Portal User Management Page

#### 1. User List Component
```javascript
// Fetch users with pagination
const fetchUsers = async (page = 1) => {
  try {
    const response = await fetch(`/api/users?page=${page}`, {
      headers: {
        'Authorization': `Bearer ${adminToken}`,
        'Accept': 'application/json'
      }
    });
    const data = await response.json();
    setUsers(data.data);
    setPagination(data.meta);
  } catch (error) {
    console.error('Error fetching users:', error);
  }
};
```

#### 2. Create User Form
```javascript
const createUser = async (userData) => {
  try {
    const response = await fetch('/api/users', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${adminToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    });
    const result = await response.json();
    if (result.code === 201) {
      // Refresh user list
      fetchUsers();
      // Show success message
      alert(result.message);
    } else {
      // Handle error
      alert('Error: ' + result.message);
    }
  } catch (error) {
    console.error('Error creating user:', error);
  }
};
```

#### 3. Edit User Form
```javascript
const updateUser = async (userId, userData) => {
  try {
    const response = await fetch(`/api/users/${userId}`, {
      method: 'PUT',
      headers: {
        'Authorization': `Bearer ${adminToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    });
    const result = await response.json();
    if (result.code === 200) {
      // Refresh user list
      fetchUsers();
      // Show success message
      alert(result.message);
    } else {
      // Handle error
      alert('Error: ' + result.message);
    }
  } catch (error) {
    console.error('Error updating user:', error);
  }
};
```

#### 4. Delete User
```javascript
const deleteUser = async (userId) => {
  if (!confirm('Are you sure you want to delete this user?')) return;

  try {
    const response = await fetch(`/api/users/${userId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${adminToken}`
      }
    });
    const result = await response.json();
    if (result.code === 200) {
      // Refresh user list
      fetchUsers();
      // Show success message
      alert(result.message);
    } else {
      // Handle error
      alert('Error: ' + result.message);
    }
  } catch (error) {
    console.error('Error deleting user:', error);
  }
};
```

### Role-Based UI Components

```javascript
// Role badge component
const RoleBadge = ({ role }) => {
  const colors = {
    citizen: 'bg-blue-100 text-blue-800',
    official: 'bg-green-100 text-green-800',
    admin: 'bg-red-100 text-red-800',
    superadmin: 'bg-purple-100 text-purple-800'
  };

  return (
    <span className={`px-2 py-1 rounded-full text-xs font-medium ${colors[role] || 'bg-gray-100 text-gray-800'}`}>
      {role}
    </span>
  );
};

// User actions based on current admin role
const UserActions = ({ user, currentUserRole }) => {
  const canEdit = ['admin', 'superadmin'].includes(currentUserRole);
  const canDelete = currentUserRole === 'superadmin' ||
                   (currentUserRole === 'admin' && user.role === 'citizen');

  return (
    <div className="flex space-x-2">
      {canEdit && (
        <button onClick={() => editUser(user)} className="text-blue-600 hover:text-blue-800">
          Edit
        </button>
      )}
      {canDelete && (
        <button onClick={() => deleteUser(user.id)} className="text-red-600 hover:text-red-800">
          Delete
        </button>
      )}
    </div>
  );
};
```

## Security Considerations

### Password Requirements
- Minimum 8 characters
- Should be hashed using Laravel's `Hash::make()`
- Consider implementing password complexity rules

### Role-Based Access Control
- Admin routes are protected by `role:admin,superadmin` middleware
- Always validate user permissions on the frontend
- Implement proper authorization checks

### Phone Number Validation
- Phone numbers must be unique across all users
- Consider implementing phone number formatting/validation
- Support international phone number formats if needed

## Database Seeding

To populate the database with sample users:

```bash
# Run specific seeder
php artisan db:seed --class=UserSeeder

# Run all seeders
php artisan db:seed
```

## Testing User Management

### Unit Tests
```php
// Test user creation
public function test_admin_can_create_user()
{
    $admin = User::factory()->create(['role' => 'admin']);
    $this->actingAs($admin, 'sanctum');

    $userData = [
        'full_name' => 'Test User',
        'phonenumber' => '1234567890',
        'role' => 'citizen',
        'address' => 'Test Address',
        'password' => 'password123'
    ];

    $response = $this->postJson('/api/users', $userData);

    $response->assertStatus(201)
             ->assertJsonStructure([
                 'success',
                 'data' => [
                     'user' => [
                         'id', 'full_name', 'phonenumber', 'role', 'address'
                     ]
                 ],
                 'message'
             ]);
}
```

## Error Handling

Common error responses:

### Validation Errors (422)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "phonenumber": ["The phonenumber has already been taken."]
  }
}
```

### Unauthorized (403)
```json
{
  "success": false,
  "message": "Unauthorized. Admin access required."
}
```

### Not Found (404)
```json
{
  "success": false,
  "message": "User not found"
}
```

## Future Enhancements

- User profile pictures
- Email verification
- Password reset functionality
- User activity logging
- Bulk user operations
- Advanced search and filtering
- User import/export functionality
