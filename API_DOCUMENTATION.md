# Digital Municipality - Comprehensive API Documentation

## Table of Contents
1. [Overview](#overview)
2. [Technology Stack](#technology-stack)
3. [Authentication System](#authentication-system)
4. [Logging & Monitoring](#logging--monitoring)
5. [API Routes](#api-routes)
6. [Database Schema](#database-schema)
7. [Models & Relationships](#models--relationships)
8. [Request Validation Rules](#request-validation-rules)
9. [API Resources](#api-resources)
10. [Controllers](#controllers)
11. [Configuration](#configuration)

---

## Overview

Digital Municipality is a comprehensive Laravel-based API system designed to manage municipal operations, citizen services, and government interactions. The system provides features for project management, bill payments, complaints, polls, circulars, and various citizen services.

**Base URL:** `http://your-domain.com/api`

---

## Technology Stack

- **Framework:** Laravel 12.x
- **PHP Version:** ^8.2
- **Authentication:** Laravel Sanctum (Token-based API authentication)
- **Database:** MySQL/PostgreSQL (configurable)
- **File Storage:** Laravel Storage (Public Disk)
- **Key Dependencies:**
  - Laravel Sanctum ^4.0
  - Laravel Tinker ^2.10.1

---

## File Upload System

### Overview

The application implements a centralized file upload system using the `FileUploadTrait` for consistent file handling across all controllers. All uploaded files are stored in `storage/app/public/` with organized directory structures.

### Storage Structure

```
storage/app/public/
├── services/
│   └── logos/              # Service logos
├── explore/
│   └── images/             # Explore post/promotion images
├── projects/
│   └── images/             # Project images
├── circulars/
│   └── images/             # Circular images
├── complaints/
│   └── images/             # Complaint evidence images
└── requests/
    └── attachments/        # User request attachments
```

### File Upload Trait

**File:** `app/Traits/FileUploadTrait.php`

The trait provides centralized methods for file handling:

**Methods:**
- `uploadSingleFile(UploadedFile $file, string $directory): string` - Upload single file and return URL
- `uploadMultipleFiles(array $files, string $directory): array` - Upload multiple files and return URLs
- `deleteFile(?string $url): bool` - Delete single file from storage
- `deleteMultipleFiles(?array $urls): void` - Delete multiple files from storage

**Features:**
- Automatic file storage to organized directories
- URL generation with `asset('storage/...')`
- Automatic cleanup on update/delete operations
- Path extraction from URLs for deletion

### Supported File Types & Size Limits

| File Type | Extensions | Max Size | Used For |
|-----------|-----------|----------|----------|
| Images | jpg, jpeg, png, svg | 5 MB | Services, Explores, Projects, Circulars, Complaints |
| Documents | jpg, jpeg, png, pdf, doc, docx | 10 MB | User Request Attachments |

### Upload Requirements

All file uploads must use `multipart/form-data` content type. When sending requests with file uploads:

```http
POST /api/services
Authorization: Bearer {token}
Content-Type: multipart/form-data

logo: [binary file]
name: "Emergency Services"
phone_number: "123-456-7890"
priority: true
```

**Important Notes:**
- Single file fields: Send as single file input
- Multiple file fields: Send as array of files (e.g., `images_url[]`)
- Old file URLs are automatically deleted when updating
- Files are deleted from storage when parent record is deleted
- All file paths are returned as full URLs in API responses

---

## Authentication System

### Authentication Method
The application uses **Laravel Sanctum** for API token-based authentication with role-based access control.

### User Roles
- `citizen` (default) - Regular users/citizens
- `admin` - Administrative users
- `superadmin` - Super administrators

### Authentication Guard
```php
// config/auth.php
'guards' => [
    'api' => [
        'driver' => 'sanctum',
        'provider' => 'users',
        'hash' => false,
    ],
]
```

### Role Middleware
The application implements a custom `CheckRole` middleware that restricts access based on user roles:

```php
// app/Http/Middleware/CheckRole.php
public function handle(Request $request, Closure $next, ...$roles): Response
{
    if (! $request->user() || ! in_array($request->user()->role, $roles)) {
        return response()->json(['message' => 'Unauthorized'], 403);
    }
    return $next($request);
}
```

Usage: `Route::middleware('role:admin,superadmin')->group(...)`

---

## Logging & Monitoring

### Logging Architecture

The application implements a **hybrid logging strategy** that balances comprehensive monitoring with database performance:

- **File-based logs** for high-frequency events (all API requests, queries, errors)
- **Database logs** for critical business events only (authentication, payments, security)
- **Automatic log rotation** to prevent disk space issues
- **Auto-cleanup** of old database logs (90+ days)

### Log Channels

The system uses multiple log channels for different purposes:

| Channel | Type | Purpose | Retention |
|---------|------|---------|-----------|
| `daily` | File | General application logs | 14 days |
| `api` | File | All API requests/responses | 30 days |
| `security` | File | Security events & warnings | 90 days |
| `query` | File | Database queries (dev only) | 7 days |

### Activity Logs (Database)

Critical events are logged to the `activity_logs` table for audit trail purposes:

#### Logged Events
- ✅ User registration
- ✅ Login/logout (mobile and admin)
- ✅ Unauthorized access attempts
- ✅ Failed authentication attempts
- ✅ API errors (4xx, 5xx responses)
- ✅ Payment transactions
- ✅ Administrative actions

#### ActivityLog Table Schema
```sql
CREATE TABLE activity_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    log_name VARCHAR(255),           -- 'authentication', 'payment', 'security'
    description TEXT,                 -- Human-readable description
    subject_type VARCHAR(255),        -- Model class (e.g., 'App\Models\User')
    subject_id CHAR(26),             -- ULID of the model
    event VARCHAR(255),              -- 'login', 'logout', 'created', 'updated'
    causer_type VARCHAR(255),        -- User model class
    causer_id CHAR(26),              -- User ULID who performed action
    properties JSON,                 -- Additional contextual data
    ip_address VARCHAR(45),          -- IPv4 or IPv6
    user_agent VARCHAR(255),         -- Browser/client info
    created_at TIMESTAMP,
    
    INDEX(subject_type, subject_id),
    INDEX(causer_type, causer_id),
    INDEX(log_name),
    INDEX(created_at)
);
```

### Logging Implementation

#### 1. LogsActivity Trait

Controllers can use the `LogsActivity` trait to log events:

```php
use App\Traits\LogsActivity;

class AuthController extends Controller
{
    use LogsActivity;
    
    // Log to database (critical events)
    $this->logActivity(
        description: "User logged in via mobile",
        logName: 'authentication',
        event: 'login',
        subject: $user,
        properties: ['login_type' => 'mobile']
    );
    
    // Log to file (non-critical)
    $this->logToFile(
        message: "Failed login attempt",
        level: 'warning',
        channel: 'security',
        context: ['ip' => $request->ip()]
    );
}
```

#### 2. Automatic API Request Logging

All API requests are automatically logged via the `LogApiRequests` middleware:

```php
// Logged to storage/logs/api.log
[2025-12-26 12:50:07] INFO: API Request {
    "method": "POST",
    "url": "https://domain.com/api/login",
    "ip": "192.168.1.100",
    "user_id": "01JGQM8K6ZB9P0K1W2X3Y4Z5",
    "status": 200,
    "duration_ms": 145.23
}
```

Failed requests (4xx/5xx) are also logged to database for critical tracking.

#### 3. Log Cleanup

**Manual Cleanup:**
```bash
php artisan logs:cleanup --days=90
```

**Scheduled Cleanup:**
The system automatically cleans up old database logs. To schedule daily cleanup, add to `routes/console.php`:

```php
use Illuminate\Support\Facades\Schedule;

Schedule::command('logs:cleanup --days=90')->daily();
```

### What to Log Where

| Event Type | Destination | Reason |
|------------|-------------|--------|
| **Authentication events** | Database | Audit trail, security compliance |
| **Payment transactions** | Database | Financial audit, legal requirements |
| **Failed logins (3+ attempts)** | Database | Security monitoring |
| **Admin actions** | Database | Accountability, audit trail |
| **All API requests** | File | Performance analysis, debugging |
| **Validation errors** | File | Development, troubleshooting |
| **System errors** | File | Quick debugging without DB load |
| **Database queries** | File (dev) | Performance optimization |

### Performance Optimization

1. **Indexed columns** - Fast queries on `log_name`, `created_at`, foreign keys
2. **Async logging** - File writes don't block requests
3. **Automatic cleanup** - 1% probability on each write prevents buildup
4. **Selective database logging** - Only critical events hit the database
5. **JSON properties** - Flexible data storage without schema changes

### Accessing Logs

**View recent activity logs:**
```php
use App\Models\ActivityLog;

// Get recent logins
$logins = ActivityLog::where('event', 'login')
    ->where('created_at', '>', now()->subDays(7))
    ->with('causer')
    ->latest()
    ->get();

// Get user's activity
$userActivity = ActivityLog::where('causer_id', $userId)
    ->orderBy('created_at', 'desc')
    ->paginate(50);

// Get failed access attempts
$failedAttempts = ActivityLog::where('log_name', 'security')
    ->where('event', 'unauthorized_access')
    ->get();
```

**View file logs:**
```bash
# API logs
tail -f storage/logs/api.log

# Security logs
tail -f storage/logs/security.log

# Application logs
tail -f storage/logs/laravel.log
```

---

## API Routes

### 1. Public Routes (No Authentication Required)

#### Authentication Endpoints

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/register` | AuthController@register | Register new citizen user |
| POST | `/login` | AuthController@loginMobile | Login for mobile app users |
| POST | `/login/admin` | AuthController@loginAdmin | Login for admin users |
| POST | `/otp/send` | OtpController@send | Send OTP verification code |
| POST | `/otp/verify` | OtpController@verify | Verify OTP code |

#### Public Content Endpoints

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/projects` | ProjectController@index | List all projects (paginated) |
| GET | `/projects/{project}` | ProjectController@show | View single project |
| GET | `/circulars` | CircularController@index | List all circulars |
| GET | `/circulars/{circular}` | CircularController@show | View single circular |
| GET | `/explores` | ExploreController@index | List explore items |
| GET | `/explores/{explore}` | ExploreController@show | View single explore item |
| GET | `/services` | ServiceController@index | List all services (with search & priority) |
| GET | `/services/{service}` | ServiceController@show | View single service |

### 2. Authenticated Routes (Require Bearer Token)

All routes below require the header: `Authorization: Bearer {token}`

#### User Profile & Auth

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/user` | Closure | Get current authenticated user |
| GET | `/profile` | UserController@profile | Get user profile with all relations |
| POST | `/logout` | AuthController@logout | Logout and revoke token |

#### Bill Management (User Actions)

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/attach-bills/{attachBill}/pay` | AttachBillController@pay | Mark bill as paid |
| POST | `/attach-bills/{attachBill}/unpay` | AttachBillController@unpay | Mark bill as unpaid |

#### Polls (User Access)

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/polls` | PollController@index | List all polls |
| GET | `/polls/{poll}` | PollController@show | View single poll |
| POST | `/polls/{poll}/vote` | PollController@vote | Submit vote on a poll |

#### User Requests (CRUD Operations)

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/user-requests` | UserRequestController@index | List user's requests |
| POST | `/user-requests` | UserRequestController@store | Create new request |
| GET | `/user-requests/{userRequest}` | UserRequestController@show | View single request |
| PUT/PATCH | `/user-requests/{userRequest}` | UserRequestController@update | Update request |
| DELETE | `/user-requests/{userRequest}` | UserRequestController@destroy | Delete request |

#### Complaints (CRUD Operations)

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/complaints` | ComplaintController@index | List user's complaints |
| POST | `/complaints` | ComplaintController@store | Create new complaint |
| GET | `/complaints/{complaint}` | ComplaintController@show | View single complaint |
| PUT/PATCH | `/complaints/{complaint}` | ComplaintController@update | Update complaint |
| DELETE | `/complaints/{complaint}` | ComplaintController@destroy | Delete complaint |

#### Suggestions (CRUD Operations)

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/suggestions` | SuggestionController@index | List user's suggestions |
| POST | `/suggestions` | SuggestionController@store | Create new suggestion |
| GET | `/suggestions/{suggestion}` | SuggestionController@show | View single suggestion |
| PUT/PATCH | `/suggestions/{suggestion}` | SuggestionController@update | Update suggestion |
| DELETE | `/suggestions/{suggestion}` | SuggestionController@destroy | Delete suggestion |

#### Explore Applications

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/explores/apply` | ExploreController@apply | Apply to an explore promotion/post |

### 3. Admin Routes (Require 'admin' or 'superadmin' Role)

All routes below require: `Authorization: Bearer {admin_token}` + role middleware

#### User Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/users` | UserController@index | List all users (with search) |
| POST | `/users` | UserController@store | Create new user |
| GET | `/users/{user}` | UserController@show | View single user |
| PUT/PATCH | `/users/{user}` | UserController@update | Update user |
| DELETE | `/users/{user}` | UserController@destroy | Delete user |

#### Settings Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/settings` | SettingController@index | List all settings |
| POST | `/settings` | SettingController@store | Create new setting |
| GET | `/settings/{setting}` | SettingController@show | View single setting |
| PUT/PATCH | `/settings/{setting}` | SettingController@update | Update setting |

#### Project Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/projects` | ProjectController@store | Create new project |
| PUT/PATCH | `/projects/{project}` | ProjectController@update | Update project |
| DELETE | `/projects/{project}` | ProjectController@destroy | Delete project |

#### Bill Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/bills` | BillController@index | List all bills |
| POST | `/bills` | BillController@store | Create new bill |
| POST | `/bills/create-for-user` | BillController@createForUser | Create bill for specific user |
| GET | `/bills/{bill}` | BillController@show | View single bill |
| PUT/PATCH | `/bills/{bill}` | BillController@update | Update bill |
| DELETE | `/bills/{bill}` | BillController@destroy | Delete bill |

#### Attach Bills (User-Specific Bills)

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/attach-bills` | AttachBillController@index | List all attached bills |
| POST | `/attach-bills` | AttachBillController@store | Create attached bill |
| POST | `/attach-bills/bulk` | AttachBillController@bulkAttach | Bulk attach bill to users or roles |
| GET | `/attach-bills/{attachBill}` | AttachBillController@show | View single attached bill |
| PUT/PATCH | `/attach-bills/{attachBill}` | AttachBillController@update | Update attached bill |
| DELETE | `/attach-bills/{attachBill}` | AttachBillController@destroy | Delete attached bill |

#### Circular Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/circulars` | CircularController@store | Create new circular |
| PUT/PATCH | `/circulars/{circular}` | CircularController@update | Update circular |
| DELETE | `/circulars/{circular}` | CircularController@destroy | Delete circular |

#### Explore Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/explores` | ExploreController@store | Create new explore item |
| PUT/PATCH | `/explores/{explore}` | ExploreController@update | Update explore item |
| DELETE | `/explores/{explore}` | ExploreController@destroy | Delete explore item |
| POST | `/explores/{explore}/approve` | ExploreController@approve | Approve explore application |

#### Service Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/services` | ServiceController@store | Create new service |
| PUT/PATCH | `/services/{service}` | ServiceController@update | Update service |
| DELETE | `/services/{service}` | ServiceController@destroy | Delete service |

#### Poll Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| POST | `/polls` | PollController@store | Create new poll |
| PUT | `/polls/{poll}` | PollController@update | Update poll |
| DELETE | `/polls/{poll}` | PollController@destroy | Delete poll |

#### Request Forms Management

| Method | Endpoint | Controller | Description |
|--------|----------|------------|-------------|
| GET | `/request-forms` | RequestFormController@index | List all request forms |
| POST | `/request-forms` | RequestFormController@store | Create new request form |
| GET | `/request-forms/{requestForm}` | RequestFormController@show | View single request form |
| PUT/PATCH | `/request-forms/{requestForm}` | RequestFormController@update | Update request form |
| DELETE | `/request-forms/{requestForm}` | RequestFormController@destroy | Delete request form |

---

## Database Schema

### 1. Users Table

```php
Schema::create('users', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('full_name');
    $table->string('phonenumber')->unique();
    $table->string('role')->default('citizen'); // citizen, admin, superadmin
    $table->string('address')->nullable();
    $table->string('password');
    $table->timestamps();
});
```

**Indexes:**
- Primary: `id` (ULID)
- Unique: `phonenumber`

### 2. Activity Logs Table (Logging System)

```php
Schema::create('activity_logs', function (Blueprint $table) {
    $table->id();
    $table->string('log_name')->nullable(); // 'authentication', 'payment', 'security'
    $table->text('description');
    $table->string('subject_type')->nullable(); // Model class
    $table->ulid('subject_id')->nullable(); // Model ID
    $table->string('event')->nullable(); // 'created', 'updated', 'deleted', 'login', 'logout'
    $table->string('causer_type')->nullable(); // User model class
    $table->ulid('causer_id')->nullable(); // User ID who performed action
    $table->json('properties')->nullable(); // Additional contextual data
    $table->string('ip_address', 45)->nullable();
    $table->string('user_agent')->nullable();
    $table->timestamp('created_at')->nullable();
});
```

**Indexes:**
- Primary: `id`
- Composite: `subject_type`, `subject_id`
- Composite: `causer_type`, `causer_id`
- Index: `log_name`, `created_at`

**Purpose:** Audit trail for critical business events (authentication, payments, security events)

### 3. Personal Access Tokens Table (Sanctum)

```php
Schema::create('personal_access_tokens', function (Blueprint $table) {
    $table->id();
    $table->ulidMorphs('tokenable');
    $table->text('name');
    $table->string('token', 64)->unique();
    $table->text('abilities')->nullable();
    $table->timestamp('last_used_at')->nullable();
    $table->timestamp('expires_at')->nullable()->index();
    $table->timestamps();
});
```

**Indexes:**
- Primary: `id`
- Unique: `token`
- Index: `expires_at`, `tokenable_type`, `tokenable_id`

### 3. Settings Table

```php
Schema::create('settings', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('key')->unique();
    $table->text('value')->nullable();
    $table->timestamps();
});
```

**Indexes:**
- Primary: `id`
- Unique: `key`

### 4. Projects Table

```php
Schema::create('projects', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('description')->nullable();
    $table->enum('status', ['pending', 'inprogress', 'finished', 'onhold'])->default('pending');
    $table->string('category')->nullable();
    $table->string('location')->nullable();
    $table->json('image_urls')->nullable();
    $table->date('start_date')->nullable();
    $table->date('end_date')->nullable();
    $table->timestamps();
});
```

**Enums:**
- `status`: pending, inprogress, finished, onhold

### 5. Bills Table

```php
Schema::create('bills', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('description')->nullable();
    $table->decimal('amount', 10, 2);
    $table->string('payment_type');
    $table->timestamps();
});
```

### 6. Attach Bills Table

```php
Schema::create('attach_bills', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->foreignUlid('citizen_id')->constrained('users')->cascadeOnDelete();
    $table->string('title');
    $table->text('desc')->nullable();
    $table->decimal('amount', 10, 2);
    $table->date('due_date');
    $table->date('paid_date')->nullable();
    $table->text('note')->nullable();
    $table->timestamps();
});
```

**Foreign Keys:**
- `citizen_id` → `users.id` (CASCADE ON DELETE)

### 7. Circulars Table

```php
Schema::create('circulars', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('content');
    $table->string('image_url')->nullable();
    $table->foreignUlid('created_by')->constrained('users')->cascadeOnDelete();
    $table->timestamp('published_at')->nullable();
    $table->boolean('is_published')->default(false);
    $table->timestamps();
});
```

**Foreign Keys:**
- `created_by` → `users.id` (CASCADE ON DELETE)

### 8. Complaints Table

```php
Schema::create('complaints', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('desc');
    $table->foreignUlid('user_id')->constrained('users')->cascadeOnDelete();
    $table->json('images_url')->nullable();
    $table->enum('status', ['received'])->default('received');
    $table->text('result')->nullable();
    $table->timestamps();
});
```

**Foreign Keys:**
- `user_id` → `users.id` (CASCADE ON DELETE)

**Enums:**
- `status`: received

### 9. Polls Table

```php
Schema::create('polls', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('description')->nullable();
    $table->json('options'); // {"Option 1": 0, "Option 2": 0}
    $table->timestamp('start_at')->nullable();
    $table->timestamp('end_at')->nullable();
    $table->enum('status', ['pending', 'in_progress', 'ended'])->default('pending');
    $table->integer('votes_count')->default(0);
    $table->timestamps();
});
```

**Enums:**
- `status`: pending, in_progress, ended

### 10. Poll Votes Table

```php
Schema::create('poll_votes', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->foreignUlid('poll_id')->constrained()->cascadeOnDelete();
    $table->foreignUlid('user_id')->constrained()->cascadeOnDelete();
    $table->string('option');
    $table->timestamps();
    
    $table->unique(['poll_id', 'user_id']); // One vote per user per poll
});
```

**Foreign Keys:**
- `poll_id` → `polls.id` (CASCADE ON DELETE)
- `user_id` → `users.id` (CASCADE ON DELETE)

**Unique Indexes:**
- Composite: `(poll_id, user_id)` - Prevents multiple votes

### 11. Request Forms Table

```php
Schema::create('request_forms', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('description')->nullable();
    $table->json('fields'); // [{"name":"age", "type":"number"}]
    $table->string('version')->default('1.0');
    $table->string('status')->default('active'); // active, inactive
    $table->text('instructions')->nullable();
    $table->json('attachments_required')->nullable(); // ["ID Card", "Deed"]
    $table->decimal('fee_amount', 10, 2)->default(0);
    $table->json('allowed_file_types')->nullable(); // ["pdf", "png"]
    $table->timestamps();
});
```

### 12. User Requests Table

```php
Schema::create('user_requests', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->foreignUlid('user_id')->constrained()->cascadeOnDelete();
    $table->foreignUlid('request_form_id')->constrained()->cascadeOnDelete();
    $table->json('data'); // Stores form field values
    $table->json('attachments')->nullable(); // URLs of uploaded files
    $table->string('status')->default('pending'); // pending, approved, rejected, info_needed
    $table->text('admin_note')->nullable();
    $table->timestamps();
});
```

**Foreign Keys:**
- `user_id` → `users.id` (CASCADE ON DELETE)
- `request_form_id` → `request_forms.id` (CASCADE ON DELETE)

### 13. OTPs Table

```php
Schema::create('otps', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('token');
    $table->string('phonenumber');
    $table->string('ip_address');
    $table->string('status')->default('pending'); // pending, verified
    $table->timestamp('verified_at')->nullable();
    $table->timestamp('expires_at');
    $table->timestamps();
});
```

### 14. Explores Table

```php
Schema::create('explores', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('title');
    $table->text('desc');
    $table->string('category');
    $table->enum('type', ['promotion', 'post']);
    $table->foreignUlid('citizen_id')->constrained('users')->onDelete('cascade');
    $table->json('images_url')->nullable();
    $table->date('start_date')->nullable();
    $table->date('end_date')->nullable();
    $table->enum('status', ['pending', 'approved'])->default('pending');
    $table->timestamps();
});
```

**Foreign Keys:**
- `citizen_id` → `users.id` (CASCADE ON DELETE)

**Enums:**
- `type`: promotion, post
- `status`: pending, approved

### 15. Suggestions Table

```php
Schema::create('suggestions', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->foreignUlid('citizen_id')->constrained('users')->onDelete('cascade');
    $table->text('desc');
    $table->timestamps();
});
```

**Foreign Keys:**
- `citizen_id` → `users.id` (CASCADE ON DELETE)

### 16. Services Table

```php
Schema::create('services', function (Blueprint $table) {
    $table->ulid('id')->primary();
    $table->string('name');
    $table->string('logo')->nullable();
    $table->string('phone_number');
    $table->timestamps();
});
```

---

## Models & Relationships

### User Model

**File:** `app/Models/User.php`

**Fillable Fields:**
```php
protected $fillable = [
    'full_name',
    'phonenumber',
    'role',
    'address',
    'password',
];
```

**Relationships:**
```php
public function requests() // hasMany UserRequest
public function complaints() // hasMany Complaint
public function suggestions() // hasMany Suggestion
public function explores() // hasMany Explore
public function attachBills() // hasMany AttachBill
public function pollVotes() // hasMany PollVote
```

**Traits Used:**
- `HasFactory`
- `Notifiable`
- `HasApiTokens` (Sanctum)
- `HasUlids`

**Hidden Fields:**
```php
protected $hidden = ['password', 'remember_token'];
```

**Casts:**
```php
'email_verified_at' => 'datetime',
'password' => 'hashed',
```

### Project Model

**File:** `app/Models/Project.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'description',
    'status',
    'category',
    'location',
    'image_urls',
    'start_date',
    'end_date',
];
```

**Casts:**
```php
'image_urls' => 'array',
'start_date' => 'date',
'end_date' => 'date',
```

**Traits Used:** `HasFactory`, `HasUlids`

### Bill Model

**File:** `app/Models/Bill.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'description',
    'amount',
    'payment_type',
];
```

**Casts:**
```php
'amount' => 'decimal:2',
```

**Traits Used:** `HasFactory`, `HasUlids`

### AttachBill Model

**File:** `app/Models/AttachBill.php`

**Fillable Fields:**
```php
protected $fillable = [
    'citizen_id',
    'title',
    'desc',
    'amount',
    'due_date',
    'paid_date',
    'note',
];
```

**Relationships:**
```php
public function citizen() // belongsTo User (citizen_id)
```

**Casts:**
```php
'amount' => 'decimal:2',
'due_date' => 'date',
'paid_date' => 'date',
```

**Traits Used:** `HasFactory`, `HasUlids`

### Circular Model

**File:** `app/Models/Circular.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'content',
    'image_url',
    'created_by',
    'published_at',
    'is_published',
];
```

**Relationships:**
```php
public function creator() // belongsTo User (created_by)
```

**Casts:**
```php
'published_at' => 'datetime',
'is_published' => 'boolean',
```

**Traits Used:** `HasFactory`, `HasUlids`

### Complaint Model

**File:** `app/Models/Complaint.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'desc',
    'user_id',
    'images_url',
    'status',
    'result',
];
```

**Relationships:**
```php
public function user() // belongsTo User
```

**Casts:**
```php
'images_url' => 'array',
```

**Traits Used:** `HasFactory`, `HasUlids`

### Poll Model

**File:** `app/Models/Poll.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'description',
    'options',
    'start_at',
    'end_at',
    'status',
    'votes_count',
];
```

**Relationships:**
```php
public function votes() // hasMany PollVote
```

**Casts:**
```php
'options' => 'array',
'start_at' => 'datetime',
'end_at' => 'datetime',
```

**Traits Used:** `HasUlids`

### PollVote Model

**File:** `app/Models/PollVote.php`

**Fillable Fields:**
```php
protected $fillable = [
    'poll_id',
    'user_id',
    'option',
];
```

**Relationships:**
```php
public function poll() // belongsTo Poll
public function user() // belongsTo User
```

**Traits Used:** `HasUlids`

### RequestForm Model

**File:** `app/Models/RequestForm.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'description',
    'fields',
    'version',
    'status',
    'instructions',
    'attachments_required',
    'fee_amount',
    'allowed_file_types',
];
```

**Casts:**
```php
'fields' => 'array',
'attachments_required' => 'array',
'allowed_file_types' => 'array',
'fee_amount' => 'decimal:2',
```

**Traits Used:** `HasFactory`, `HasUlids`

### UserRequest Model

**File:** `app/Models/UserRequest.php`

**Fillable Fields:**
```php
protected $fillable = [
    'user_id',
    'request_form_id',
    'data',
    'attachments',
    'status',
    'admin_note',
];
```

**Relationships:**
```php
public function user() // belongsTo User
public function requestForm() // belongsTo RequestForm
```

**Casts:**
```php
'data' => 'array',
'attachments' => 'array',
```

**Traits Used:** `HasFactory`, `HasUlids`

### Explore Model

**File:** `app/Models/Explore.php`

**Fillable Fields:**
```php
protected $fillable = [
    'title',
    'desc',
    'category',
    'type',
    'citizen_id',
    'images_url',
    'start_date',
    'end_date',
    'status',
];
```

**Relationships:**
```php
public function citizen() // belongsTo User (citizen_id)
```

**Casts:**
```php
'images_url' => 'array',
'start_date' => 'date',
'end_date' => 'date',
```

**Traits Used:** `HasUlids`

### Suggestion Model

**File:** `app/Models/Suggestion.php`

**Fillable Fields:**
```php
protected $fillable = [
    'citizen_id',
    'desc',
];
```

**Relationships:**
```php
public function citizen() // belongsTo User (citizen_id)
```

**Traits Used:** `HasUlids`

### Service Model

**File:** `app/Models/Service.php`

**Fillable Fields:**
```php
protected $fillable = [
    'name',
    'logo',
    'phone_number',
    'priority',
];
```

**Casts:**
```php
'priority' => 'boolean',
```

**Traits Used:** `HasUlids`

**Features:**
- `priority` field: Services with `priority=true` appear first in listings
- `logo` field: Stores file URL after upload to `storage/app/public/services/logos/`
- Search functionality: Filter by name using `?search=` query parameter

### Setting Model

**File:** `app/Models/Setting.php`

**Fillable Fields:**
```php
protected $fillable = [
    'key',
    'value',
];
```

**Traits Used:** `HasFactory`, `HasUlids`

### Otp Model

**File:** `app/Models/Otp.php`

**Fillable Fields:**
```php
protected $fillable = [
    'token',
    'phonenumber',
    'ip_address',
    'status',
    'verified_at',
    'expires_at',
];
```

**Casts:**
```php
'verified_at' => 'datetime',
'expires_at' => 'datetime',
```

**Traits Used:** `HasFactory`, `HasUlids`

---

## Request Validation Rules

### LoginRequest

**File:** `app/Http/Requests/LoginRequest.php`

```php
public function rules(): array
{
    return [
        'phonenumber' => ['required', 'string', 'max:20'],
        'password' => ['required', 'string', 'min:6'],
    ];
}
```

**Custom Messages:**
- `phonenumber.required` → "Phone number is required"
- `phonenumber.string` → "Phone number must be a string"
- `phonenumber.max` → "Phone number cannot exceed 20 characters"
- `password.required` → "Password is required"
- `password.string` → "Password must be a string"
- `password.min` → "Password must be at least 6 characters"

### StoreUserRequest

**File:** `app/Http/Requests/StoreUserRequest.php`

```php
public function rules(): array
{
    return [
        'full_name' => 'required|string|max:255',
        'phonenumber' => 'required|string|unique:users,phonenumber',
        'role' => 'sometimes|string',
        'address' => 'required|string|max:255',
        'password' => 'required|string|min:8',
    ];
}
```

### StoreProjectRequest

**File:** `app/Http/Requests/StoreProjectRequest.php`

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'description' => 'nullable|string',
        'status' => 'required|in:pending,inprogress,finished,onhold',
        'category' => 'nullable|string|max:255',
        'location' => 'nullable|string|max:255',
        'image_urls' => 'nullable|array',
        'image_urls.*' => 'string|url',
        'start_date' => 'nullable|date',
        'end_date' => 'nullable|date|after_or_equal:start_date',
    ];
}
```

### StoreBillRequest

**File:** `app/Http/Requests/StoreBillRequest.php`

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'description' => 'nullable|string',
        'amount' => 'required|numeric|min:0',
        'payment_type' => 'required|string|max:255',
    ];
}
```

### StoreCircularRequest

**File:** `app/Http/Requests/StoreCircularRequest.php`

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'content' => 'required|string',
        'image_url' => 'nullable|string|url',
        'published_at' => 'nullable|date',
        'is_published' => 'boolean',
    ];
}
```

### StoreComplaintRequest

**File:** `app/Http/Requests/StoreComplaintRequest.php`

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'desc' => 'required|string',
        'images_url' => 'nullable|array',
        'images_url.*' => 'string|url',
        'result' => 'nullable|string',
    ];
}
```

### StorePollRequest

**File:** `app/Http/Requests/StorePollRequest.php`

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'description' => 'nullable|string',
        'options' => 'required|array',
        'start_at' => 'nullable|date',
        'end_at' => 'nullable|date|after:start_at',
        'status' => 'required|in:pending,in_progress,ended',
    ];
}
```

### StoreRequestFormRequest

**File:** `app/Http/Requests/StoreRequestFormRequest.php`

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'description' => 'nullable|string',
        'fields' => 'required|array', // The form schema
        'version' => 'nullable|string',
        'status' => 'required|in:active,inactive',
        'instructions' => 'nullable|string',
        'attachments_required' => 'nullable|array',
        'fee_amount' => 'required|numeric|min:0',
        'allowed_file_types' => 'nullable|array',
    ];
}
```

---

## API Resources

### Available Resource Classes

All resources are located in `app/Http/Resources/`

1. **AttachBillResource** - Transforms AttachBill model data
2. **BillResource** - Transforms Bill model data
3. **CircularResource** - Transforms Circular model data
4. **ComplaintResource** - Transforms Complaint model data
5. **ExploreResource** - Transforms Explore model data
6. **PollResource** - Transforms Poll model data
7. **ProjectResource** - Transforms Project model data
8. **RequestFormResource** - Transforms RequestForm model data
9. **ServiceResource** - Transforms Service model data
10. **SettingResource** - Transforms Setting model data
11. **SuggestionResource** - Transforms Suggestion model data
12. **UserProfileResource** - Transforms User data with all relationships
13. **UserRequestResource** - Transforms UserRequest model data
14. **UserResource** - Transforms User model data

### API Response Format

The application uses a custom `ApiResponse` trait for consistent response formatting:

**File:** `app/Traits/ApiResponse.php`

#### Success Response
```php
protected function successResponse($data, $message = 'Success', $code = 200)
{
    return response()->json([
        'code' => $code,
        'message' => $message,
        'data' => $data,
    ], $code);
}
```

**Example:**
```json
{
    "code": 200,
    "message": "User retrieved successfully",
    "data": {
        "id": "01HXXX...",
        "full_name": "John Doe",
        "phonenumber": "+1234567890",
        "role": "citizen"
    }
}
```

#### Error Response
```php
protected function errorResponse($message, $code = 400, $data = null)
{
    return response()->json([
        'code' => $code,
        'message' => $message,
        'data' => $data,
    ], $code);
}
```

**Example:**
```json
{
    "code": 401,
    "message": "Invalid credentials",
    "data": null
}
```

#### Paginated Response
```php
protected function paginatedResponse($paginator, $data, $message = 'Success', $code = 200)
{
    return response()->json([
        'code' => $code,
        'message' => $message,
        'data' => $data,
        'meta' => [
            'current_page' => $paginator->currentPage(),
            'last_page' => $paginator->lastPage(),
            'per_page' => $paginator->perPage(),
            'total' => $paginator->total(),
            'next_page_url' => $paginator->nextPageUrl(),
            'prev_page_url' => $paginator->previousPageUrl(),
        ],
    ], $code);
}
```

**Example:**
```json
{
    "code": 200,
    "message": "Users retrieved successfully",
    "data": [...],
    "meta": {
        "current_page": 1,
        "last_page": 5,
        "per_page": 10,
        "total": 50,
        "next_page_url": "http://api.com/users?page=2",
        "prev_page_url": null
    }
}
```

---

## Controllers

All controllers are located in `app/Http/Controllers/`

### Controller List & Methods

1. **AttachBillController**
   - `index()` - List all attached bills
   - `store()` - Create new attached bill
        - `bulkAttach()` - Bulk attach bill to multiple users
            - Params: `title`, `desc`, `amount`, `due_date`, `paid_date?`, `note?`,
                `user_ids[]` (optional list of user ids), `target_role` (optional: `all`, `citizen`, `admin`)
            - Behavior: merges provided user_ids and users by role; requires at least one target; creates one bill per user
   - `show()` - View single attached bill
   - `update()` - Update attached bill
   - `destroy()` - Delete attached bill
   - `pay()` - Mark bill as paid
   - `unpay()` - Mark bill as unpaid

2. **AuthController**
   - `register()` - Register new citizen user
   - `loginMobile()` - Login for mobile app
   - `loginAdmin()` - Login for admin users
   - `logout()` - Logout and revoke token

3. **BillController**
   - `index()` - List all bills
   - `store()` - Create new bill
   - `show()` - View single bill
   - `update()` - Update bill
   - `destroy()` - Delete bill
   - `createForUser()` - Create bill for specific user

4. **CircularController**
   - `index()` - List all circulars
   - `store(StoreCircularRequest $request)` - Create new circular
     - **File Upload:** `image_url` field accepts single image file (jpg, jpeg, png, max 5MB)
     - Automatically uploads to `storage/app/public/circulars/images/`
   - `show(Circular $circular)` - View single circular
   - `update(UpdateCircularRequest $request, Circular $circular)` - Update circular
     - **File Upload:** `image_url` accepts single file
     - Automatically deletes old image when new one is uploaded
   - `destroy(Circular $circular)` - Delete circular
     - Automatically deletes associated image file from storage

5. **ComplaintController**
   - `index()` - List complaints
   - `store(StoreComplaintRequest $request)` - Create new complaint
     - **File Upload:** `images_url[]` field accepts multiple image files (jpg, jpeg, png, max 5MB each)
     - Automatically uploads to `storage/app/public/complaints/images/`
   - `show(Complaint $complaint)` - View single complaint
   - `update(UpdateComplaintRequest $request, Complaint $complaint)` - Update complaint
     - **File Upload:** `images_url[]` accepts multiple files
     - Automatically deletes old images when new ones are uploaded
   - `destroy(Complaint $complaint)` - Delete complaint
     - Automatically deletes associated image files from storage

6. **ExploreController**
   - `index()` - List explore items
   - `store(Request $request)` - Create new explore item
     - **File Upload:** `images_url[]` field accepts multiple image files (jpg, jpeg, png, max 5MB each)
     - Automatically uploads to `storage/app/public/explore/images/`
   - `show(Explore $explore)` - View single explore item
   - `update(Request $request, Explore $explore)` - Update explore item
     - **File Upload:** `images_url[]` accepts multiple files
     - Automatically deletes old images when new ones are uploaded
   - `destroy(Explore $explore)` - Delete explore item
     - Automatically deletes associated image files from storage
   - `apply(Request $request)` - Apply to explore promotion/post
     - **File Upload:** `images_url[]` accepts multiple files
   - `approve(Request $request, Explore $explore)` - Approve explore application

7. **OtpController**
   - `send()` - Send OTP verification code
   - `verify()` - Verify OTP code

8. **PollController**
   - `index()` - List all polls
   - `store()` - Create new poll
   - `show()` - View single poll
   - `update()` - Update poll
   - `destroy()` - Delete poll
   - `vote()` - Submit vote on poll

9. **ProjectController**
   - `index()` - List all projects (paginated)
   - `store(StoreProjectRequest $request)` - Create new project
     - **File Upload:** `image_urls[]` field accepts multiple image files (jpg, jpeg, png, max 5MB each)
     - Automatically uploads to `storage/app/public/projects/images/`
   - `show(Project $project)` - View single project
   - `update(UpdateProjectRequest $request, Project $project)` - Update project
     - **File Upload:** `image_urls[]` accepts multiple files
     - Automatically deletes old images when new ones are uploaded
   - `destroy(Project $project)` - Delete project
     - Automatically deletes associated image files from storage

10. **RequestFormController**
    - `index()` - List all request forms
    - `store()` - Create new request form
    - `show()` - View single request form
    - `update()` - Update request form
    - `destroy()` - Delete request form

11. **ServiceController**
    - `index(Request $request)` - List all services with search and priority ordering
      - Query Parameters:
        - `search` - Filter by service name (case-insensitive)
        - Results ordered by priority (true first), then by latest
    - `store(Request $request)` - Create new service
      - **File Upload:** `logo` field accepts file upload (jpg, jpeg, png, svg, max 5MB)
      - Automatically uploads to `storage/app/public/services/logos/`
    - `show(Service $service)` - View single service
    - `update(Request $request, Service $service)` - Update service
      - **File Upload:** `logo` field accepts file upload
      - Automatically deletes old logo when new one is uploaded
    - `destroy(Service $service)` - Delete service
      - Automatically deletes associated logo file from storage

12. **SettingController**
    - `index()` - List all settings
    - `store()` - Create new setting
    - `show()` - View single setting
    - `update()` - Update setting

13. **SuggestionController**
    - `index()` - List suggestions
    - `store()` - Create new suggestion
    - `show()` - View single suggestion
    - `update()` - Update suggestion
    - `destroy()` - Delete suggestion

14. **UserController**
    - `index()` - List all users (with search)
    - `store()` - Create new user
    - `show()` - View single user
    - `update()` - Update user
    - `destroy()` - Delete user
    - `profile()` - Get authenticated user profile with all relations

15. **UserRequestController**
    - `index()` - List user requests
   - `store(SubmitServiceRequest $request)` - Create new user request
     - **File Upload:** `attachments[]` field accepts multiple files (jpg, jpeg, png, pdf, doc, docx, max 10MB each)
     - Automatically uploads to `storage/app/public/requests/attachments/`
   - `show(UserRequest $userRequest)` - View single user request
   - `update(Request $request, UserRequest $userRequest)` - Update user request (status/notes only)
   - `destroy(Request $request, UserRequest $userRequest)` - Delete user request
     - Automatically deletes associated attachment files from storage
     - Only allowed for pending requests by the owner

## Configuration

### Environment Variables

Important configuration settings (typically in `.env` file):

```env
# Application
APP_NAME="Digital Municipality"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=digital_municipality
DB_USERNAME=root
DB_PASSWORD=

# Authentication
AUTH_GUARD=api

# Sanctum
SANCTUM_STATEFUL_DOMAINS=localhost,localhost:3000,127.0.0.1,127.0.0.1:8000
```

### Key Features

1. **ULID Primary Keys** - All models use ULID instead of auto-incrementing integers for better distributed systems support
2. **JSON Fields** - Extensive use of JSON for flexible data storage (options, fields, attachments, etc.)
3. **Role-Based Access Control** - Three-tier user system (citizen, admin, superadmin)
4. **Token Authentication** - Stateless API authentication via Laravel Sanctum
5. **Cascade Deletions** - Proper foreign key constraints with cascade on delete
6. **Request Validation** - Comprehensive validation for all input data
7. **API Resources** - Consistent data transformation for API responses
8. **Standardized Responses** - Uniform JSON response structure across all endpoints

### Installation & Setup

```bash
# Install dependencies
composer install
npm install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Run migrations
php artisan migrate

# Build frontend assets
npm run build

# Start development server
php artisan serve
```

### Testing

```bash
# Run all tests
php artisan test

# Or using composer
composer test
```

---

## API Usage Examples

### 1. Register New User

```http
POST /api/register
Content-Type: application/json

{
    "full_name": "John Doe",
    "phonenumber": "+1234567890",
    "address": "123 Main St",
    "password": "password123"
}
```

**Response:**
```json
{
    "code": 201,
    "message": "User registered successfully",
    "data": {
        "user": {
            "id": "01HXXX...",
            "full_name": "John Doe",
            "phonenumber": "+1234567890",
            "role": "citizen"
        },
        "token": "1|xxxxx..."
    }
}
```

### 2. Login

```http
POST /api/login
Content-Type: application/json

{
    "phonenumber": "+1234567890",
    "password": "password123"
}
```

**Response:**
```json
{
    "code": 200,
    "message": "Login successful",
    "data": {
        "user": {...},
        "token": "2|xxxxx..."
    }
}
```

### 3. Get User Profile (Authenticated)

```http
GET /api/profile
Authorization: Bearer 2|xxxxx...
```

**Response:**
```json
{
    "code": 200,
    "message": "Profile retrieved successfully",
    "data": {
        "id": "01HXXX...",
        "full_name": "John Doe",
        "phonenumber": "+1234567890",
        "role": "citizen",
        "requests": [...],
        "complaints": [...],
        "suggestions": [...],
        "attach_bills": [...]
    }
}
```

### 4. Create Service with File Upload (Admin Only)

```http
POST /api/services
Authorization: Bearer {admin_token}
Content-Type: multipart/form-data

name: "Emergency Services"
phone_number: "123-456-7890"
priority: true
logo: [binary file - jpg/png/svg, max 5MB]
```

**Response:**
```json
{
    "code": 201,
    "message": "Service created successfully",
    "data": {
        "id": "01HXXX...",
        "name": "Emergency Services",
        "logo": "http://domain.com/storage/services/logos/abc123.jpg",
        "phone_number": "123-456-7890",
        "priority": true,
        "created_at": "2025-12-27T10:00:00.000000Z",
        "updated_at": "2025-12-27T10:00:00.000000Z"
    }
}
```

### 5. Search Services with Priority

```http
GET /api/services?search=emergency
Authorization: Bearer {token}
```

**Response:**
```json
{
    "code": 200,
    "message": "Services retrieved successfully",
    "data": [...],
    "pagination": {
        "current_page": 1,
        "per_page": 20,
        "total": 5
    }
}
```

**Note:** Results are automatically ordered by priority (true first), then by latest creation date.

### 6. Create Project with Multiple Images (Admin Only)

```http
POST /api/projects
Authorization: Bearer {admin_token}
Content-Type: multipart/form-data

title: "Road Construction Project"
description: "Building new highway"
status: "pending"
category: "Infrastructure"
location: "Downtown Area"
start_date: "2025-01-01"
end_date: "2025-12-31"
image_urls[]: [binary file 1]
image_urls[]: [binary file 2]
image_urls[]: [binary file 3]
```

**Response:**
```json
{
    "code": 201,
    "message": "Project created successfully",
    "data": {
        "id": "01HXXX...",
        "title": "Road Construction Project",
        "description": "Building new highway",
        "status": "pending",
        "category": "Infrastructure",
        "location": "Downtown Area",
        "image_urls": [
            "http://domain.com/storage/projects/images/img1.jpg",
            "http://domain.com/storage/projects/images/img2.jpg",
            "http://domain.com/storage/projects/images/img3.jpg"
        ],
        "start_date": "2025-01-01",
        "end_date": "2025-12-31",
        "created_at": "2025-12-27T10:00:00.000000Z",
        "updated_at": "2025-12-27T10:00:00.000000Z"
    }
}
```

### 7. Submit Complaint with Images

```http
POST /api/complaints
Authorization: Bearer {token}
Content-Type: multipart/form-data

title: "Street Light Not Working"
desc: "The street light on Main St has been out for 3 days"
images_url[]: [binary file 1]
images_url[]: [binary file 2]
```

**Response:**
```json
{
    "code": 201,
    "message": "Complaint created successfully",
    "data": {
        "id": "01HXXX...",
        "title": "Street Light Not Working",
        "desc": "The street light on Main St has been out for 3 days",
        "images_url": [
            "http://domain.com/storage/complaints/images/evidence1.jpg",
            "http://domain.com/storage/complaints/images/evidence2.jpg"
        ],
        "user_id": "01HYYY...",
        "result": null,
        "created_at": "2025-12-27T10:00:00.000000Z",
        "updated_at": "2025-12-27T10:00:00.000000Z"
    }
}
```

### 8. Create Circular with Image (Admin Only)

```http
POST /api/circulars
Authorization: Bearer {admin_token}
Content-Type: multipart/form-data

title: "Community Meeting Notice"
content: "Annual community meeting scheduled for..."
image_url: [binary file]
is_published: true
published_at: "2025-12-27"
```

### 9. Submit User Request with Attachments

```http
POST /api/user-requests
Authorization: Bearer {token}
Content-Type: multipart/form-data

request_form_id: "01HXXX..."
data: {"field1": "value1", "field2": "value2"}
attachments[]: [binary file 1 - pdf/doc]
attachments[]: [binary file 2 - image]
```

**Response:**
```json
{
    "code": 201,
    "message": "Request submitted successfully",
    "data": {
        "id": "01HXXX...",
        "user_id": "01HYYY...",
        "request_form_id": "01HZZZ...",
        "data": {"field1": "value1", "field2": "value2"},
        "attachments": [
            "http://domain.com/storage/requests/attachments/doc1.pdf",
            "http://domain.com/storage/requests/attachments/img1.jpg"
        ],
        "status": "pending",
        "admin_note": null,
        "created_at": "2025-12-27T10:00:00.000000Z",
        "updated_at": "2025-12-27T10:00:00.000000Z"
    }
}
```

### 10. Vote on Poll

```http
POST /api/polls/{poll_id}/vote
Authorization: Bearer {token}
Content-Type: application/json

{
    "option": "Option 1"
}
```

---

## Notes

- All timestamps are in UTC
- All dates follow ISO 8601 format (YYYY-MM-DD)
- **File Uploads:** Use `multipart/form-data` content type for all endpoints that accept file uploads
- **Multiple Files:** Use array notation (e.g., `images_url[]`, `attachments[]`) when sending multiple files
- **File URLs:** All uploaded files return full URLs in responses, stored in database
- **Automatic Cleanup:** Old files are automatically deleted when updating or deleting records
- Pagination is set to 10-20 items per page by default (varies by endpoint)
- ULIDs are used instead of auto-incrementing IDs for better scalability
- OTP verification system is implemented for additional security
- Dynamic form system allows admins to create custom request forms
- Poll voting is restricted to one vote per user per poll
- Service priority ordering: Services with `priority=true` always appear first

### File Upload Limits

| Endpoint | Field Name | File Types | Max Size | Max Count |
|----------|-----------|------------|----------|-----------|
| Services | `logo` | jpg, jpeg, png, svg | 5 MB | 1 |
| Projects | `image_urls[]` | jpg, jpeg, png | 5 MB | Multiple |
| Circulars | `image_url` | jpg, jpeg, png | 5 MB | 1 |
| Complaints | `images_url[]` | jpg, jpeg, png | 5 MB | Multiple |
| Explores | `images_url[]` | jpg, jpeg, png | 5 MB | Multiple |
| User Requests | `attachments[]` | jpg, jpeg, png, pdf, doc, docx | 10 MB | Multiple |

---

## Support & Maintenance

For issues, feature requests, or contributions, please refer to the main repository documentation.

**Laravel Version:** 12.x  
**PHP Version:** 8.2+  
**License:** MIT
