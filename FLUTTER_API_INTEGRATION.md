# Flutter App - API Integration Documentation

## Configuration

### API Base URL Configuration

The API base URL is configured in `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  static const Environment currentEnvironment = Environment.development;
  
  // Update these URLs for your environments
  static const String _devBaseUrl = 'http://localhost:8000';
  static const String _stagingBaseUrl = 'https://staging.your-api.com';
  static const String _productionBaseUrl = 'https://api.your-api.com';
}
```

**To change environment:**
1. Open `lib/core/config/api_config.dart`
2. Change `currentEnvironment` to your desired environment:
   - `Environment.development` for local development
   - `Environment.staging` for staging server
   - `Environment.production` for production server

**For local backend:**
- Use `http://localhost:8000` if backend is on same machine
- Use `http://10.0.2.2:8000` for Android emulator
- Use your local IP (e.g., `http://192.168.1.100:8000`) for physical devices

---

## API Service Architecture

### 1. API Service (`lib/core/services/api_service.dart`)

Handles all HTTP communication using Dio:

**Features:**
- Automatic token injection in request headers
- Automatic 401 handling (redirect to login)
- Error handling and Arabic error messages
- Request/response interceptors

**Methods:**
- `get(path, queryParameters)` - GET requests
- `post(path, data)` - POST requests
- `put(path, data)` - PUT requests
- `delete(path, data)` - DELETE requests

### 2. Auth Repository (`lib/data/repositories/auth_repository.dart`)

Handles all authentication-related API calls:

**Methods:**
- `loginAdmin()` - Admin login (for admin portal)
- `login()` - Regular user login
- `register()` - User registration
- `logout()` - Regular logout
- `logoutAdmin()` - Admin logout
- `getCurrentUser()` - Get authenticated user details
- `verifyPhone()` - Verify phone for password reset
- `verifyOtp()` - Verify OTP code
- `resetPassword()` - Reset password

### 3. Auth Storage Service (`lib/core/services/auth_storage_service.dart`)

Handles local storage of auth data using GetStorage:

**Methods:**
- `saveToken()` / `getToken()` - Auth token management
- `saveUser()` / `getUser()` - User data management
- `saveRememberMe()` / `getRememberMe()` - Remember me preference
- `saveSavedPhone()` / `getSavedPhone()` - Saved phone number
- `isAuthenticated()` - Check if user is logged in
- `clearAuth()` - Clear auth data (logout)

---

## Authentication Flow

### Admin Login Flow

```
User enters phone & password
    ↓
Validate input
    ↓
Call API: POST /api/login/admin
    ↓
Backend validates credentials & role (admin/superadmin only)
    ↓
Success: Return token + user data
    ↓
Save token to local storage
Save user data to local storage
    ↓
Navigate to dashboard
```

**Implementation:**

```dart
// In sign_in_controller.dart
final response = await _authRepository.loginAdmin(
  phonenumber: completePhoneNumber.value,
  password: passwordController.text,
);

if (response.success && response.data != null) {
  await _authStorage.saveToken(response.data!.token);
  await _authStorage.saveUser(response.data!.user);
  context.go(AppRouteName.dashboardView);
}
```

---

## API Endpoints Reference

### 1. Admin Login

**Endpoint:** `POST /api/login/admin`

**Request:**
```json
{
  "phonenumber": "+966512345678",
  "password": "your_password"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Admin login successful",
  "data": {
    "user": {
      "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
      "full_name": "Admin User",
      "phonenumber": "+966512345678",
      "role": "admin",
      "address": "Admin Office"
    },
    "token": "2|xyz9876abc5432def1098ghi7654jkl3210mno8765pqr"
  }
}
```

**Error Responses:**
- **401**: Invalid credentials
- **403**: Unauthorized (not admin/superadmin role)
- **422**: Validation error

### 2. Verify Phone (Forgot Password)

**Endpoint:** `POST /api/verify-phone`

**Request:**
```json
{
  "phonenumber": "+966512345678"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "OTP sent successfully"
}
```

### 3. Verify OTP

**Endpoint:** `POST /api/verify-otp`

**Request:**
```json
{
  "phonenumber": "+966512345678",
  "otp": "123456"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "OTP verified",
  "data": {
    "reset_token": "temporary_token_for_password_reset"
  }
}
```

### 4. Reset Password

**Endpoint:** `POST /api/reset-password`

**Request:**
```json
{
  "phonenumber": "+966512345678",
  "password": "new_password",
  "password_confirmation": "new_password",
  "token": "reset_token_from_otp_verification"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Password reset successful"
}
```

### 5. Logout

**Endpoint:** `POST /api/logout/admin`

**Headers:**
```
Authorization: Bearer {token}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

### 6. Get Current User

**Endpoint:** `GET /api/user`

**Headers:**
```
Authorization: Bearer {token}
```

**Success Response (200):**
```json
{
  "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
  "full_name": "Admin User",
  "phonenumber": "+966512345678",
  "role": "admin",
  "address": "Admin Office"
}
```

---

## Error Handling

### Error Response Format

All API errors follow this format:

```json
{
  "success": false,
  "message": "Error message in Arabic or English"
}
```

### Validation Errors (422)

```json
{
  "success": false,
  "message": "Validation error",
  "errors": {
    "phonenumber": ["رقم الهاتف مطلوب"],
    "password": ["كلمة المرور يجب أن تكون 6 أحرف على الأقل"]
  }
}
```

### Common HTTP Status Codes

- **200**: Success
- **201**: Created successfully
- **400**: Bad request
- **401**: Unauthorized (invalid/expired token)
- **403**: Forbidden (insufficient permissions)
- **404**: Not found
- **422**: Validation error
- **500**: Server error

### Error Messages in Flutter

The `ApiService` automatically converts errors to Arabic messages:

```dart
String _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى';
    case DioExceptionType.badResponse:
      return _handleResponseError(error.response);
    case DioExceptionType.connectionError:
      return 'خطأ في الاتصال. يرجى التحقق من الإنترنت';
    default:
      return 'حدث خطأ غير متوقع';
  }
}
```

---

## Testing

### Test with Backend

1. **Start your Laravel backend:**
   ```bash
   cd /path/to/backend
   php artisan serve
   ```

2. **Update API URL in Flutter:**
   ```dart
   // lib/core/config/api_config.dart
   static const String _devBaseUrl = 'http://localhost:8000';
   ```

3. **Test login with existing admin user:**
   - Ensure you have an admin user in your database
   - Use their phone number and password

### Test Without Backend (Mock)

To test UI without backend, you can temporarily mock the API responses:

```dart
// In auth_repository.dart
Future<AuthResponse> loginAdmin({...}) async {
  // Mock response for testing
  await Future.delayed(Duration(seconds: 1));
  
  return AuthResponse(
    success: true,
    message: 'Login successful',
    data: AuthData(
      user: UserModel(
        id: 1,
        name: 'Test Admin',
        phonenumber: phonenumber,
        role: 'admin',
      ),
      token: 'mock_token_123',
    ),
  );
}
```

---

## Debugging

### Enable Dio Logging

To see all HTTP requests/responses, add logging interceptor:

```dart
// In api_service.dart constructor
dio.interceptors.add(
  LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
  ),
);
```

### Check Network Errors

1. **Connection Timeout:**
   - Backend not running
   - Wrong API URL
   - Firewall blocking connection

2. **401 Unauthorized:**
   - Token expired
   - Token not sent
   - Invalid token

3. **403 Forbidden:**
   - User doesn't have admin role
   - Trying to access protected resource

### Common Issues

**Issue: "Connection refused"**
- Backend not running
- Wrong port number
- Using `localhost` on physical device (use IP address instead)

**Issue: "Invalid credentials"**
- Wrong phone number format
- Wrong password
- User doesn't exist in database

**Issue: "Unauthorized. Admin access required"**
- User role is 'citizen', not 'admin' or 'superadmin'
- Check user role in database

---

## Security Best Practices

### 1. Token Storage
- Tokens are stored securely using GetStorage
- Never log tokens to console in production
- Clear tokens on logout

### 2. HTTPS in Production
Update for production:
```dart
static const String _productionBaseUrl = 'https://api.your-domain.com';
```

### 3. Token Expiration
- Tokens expire after 30 days (configured in backend)
- User must re-login after expiration
- 401 errors automatically redirect to login

### 4. Phone Number Format
- Always send phone with country code: `+966512345678`
- IntlPhoneField automatically formats it correctly

---

## Future Enhancements

### 1. Refresh Token
Implement refresh token to avoid re-login:
```dart
Future<void> refreshToken() async {
  final response = await _apiService.post('/api/refresh-token');
  await _authStorage.saveToken(response.data['token']);
}
```

### 2. Biometric Authentication
Add fingerprint/face ID after initial login:
```yaml
dependencies:
  local_auth: ^2.1.0
```

### 3. Offline Mode
Cache data for offline access:
```yaml
dependencies:
  sqflite: ^2.3.0
```

---

## File Structure Reference

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart           # API configuration
│   ├── models/
│   │   ├── user_model.dart           # User data model
│   │   └── auth_response.dart        # API response models
│   └── services/
│       ├── api_service.dart          # Dio HTTP client
│       └── auth_storage_service.dart # Local storage
│
└── data/
    └── repositories/
        └── auth_repository.dart      # Auth API calls
```

---

## Quick Reference

### Change API URL
```dart
// lib/core/config/api_config.dart
static const String _devBaseUrl = 'http://YOUR_IP:8000';
```

### Test Login
```dart
Phone: +966512345678
Password: your_admin_password
```

### Check if User is Logged In
```dart
final isLoggedIn = AuthStorageService().isAuthenticated();
```

### Get Current User
```dart
final user = await AuthStorageService().getUser();
print(user?.name); // User name
print(user?.role); // User role (admin/superadmin)
```

### Logout
```dart
await AuthRepository().logoutAdmin();
await AuthStorageService().clearAuth();
context.go(AppRouteName.signInView);
```

---

**Last Updated:** December 25, 2025
