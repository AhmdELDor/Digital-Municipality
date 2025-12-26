# Authentication Guide - Token-Based (Sanctum)

## Overview

This application uses **Laravel Sanctum token-based authentication** for all clients (mobile apps, desktop apps, and web applications). This provides stateless, scalable authentication suitable for modern applications.

---

## Authentication Flow

### Token-Based Authentication
```
Client sends credentials → Backend validates → Token generated → Token returned → Client stores token → Token sent in Authorization header for subsequent requests
```

### Token Management
- **Token Expiration**: Configurable (set to 30 days recommended)
- **Storage**: Client-side (secure storage recommended)
- **Revocation**: Tokens can be revoked via logout or deleted manually
- **Multiple Devices**: Supports multiple active tokens per user

---

## API Endpoints

### Register

**Endpoint**: `POST /api/register`

**Headers**:
```http
Content-Type: application/json
Accept: application/json
```

**Request Body**:
```json
{
  "full_name": "John Doe",
  "phonenumber": "1234567890",
  "password": "password123",
  "password_confirmation": "password123",
  "address": "123 Main St",
  "role": "citizen"
}
```

**Success Response** (201):
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
      "full_name": "John Doe",
      "phonenumber": "1234567890",
      "role": "citizen",
      "address": "123 Main St"
    },
    "token": "1|abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx"
  }
}
```

---

### Login (Citizens & Users)

**Endpoint**: `POST /api/login`

**Headers**:
```http
Content-Type: application/json
Accept: application/json
```

**Request Body**:
```json
{
  "phonenumber": "1234567890",
  "password": "your_password"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
      "full_name": "John Doe",
      "phonenumber": "1234567890",
      "role": "citizen",
      "address": "123 Main St"
    },
    "token": "1|abcd1234efgh5678ijkl9012mnop3456qrst7890uvwx"
  }
}
```

**Error Response** (401):
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

---

### Login (Admin/SuperAdmin)

**Endpoint**: `POST /api/login/admin`

**Headers**:
```http
Content-Type: application/json
Accept: application/json
```

**Request Body**:
```json
{
  "phonenumber": "1234567890",
  "password": "admin_password"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Admin login successful",
  "data": {
    "user": {
      "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
      "full_name": "Admin User",
      "phonenumber": "1234567890",
      "role": "admin",
      "address": "Admin Office"
    },
    "token": "2|xyz9876abc5432def1098ghi7654jkl3210mno8765pqr"
  }
}
```

**Error Responses**:

- **Invalid Credentials** (401):
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

- **Unauthorized Role** (403):
```json
{
  "success": false,
  "message": "Unauthorized. Admin access required."
}
```

**Important Notes**:
- Only users with `admin` or `superadmin` roles can use this endpoint
- Regular citizens will receive a 403 error if attempting admin login

---

### Logout

**Endpoint**: `POST /api/logout`

**Headers**:
```http
Content-Type: application/json
Accept: application/json
Authorization: Bearer {your-token}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Logged out successfully",
  "data": null
}
```

**Important Notes**:
- Revokes only the current token used in the request
- User's other active tokens remain valid
- To revoke all tokens, backend can call `$user->tokens()->delete()`

---

### Get Current User

**Endpoint**: `GET /api/user`

**Headers**:
```http
Accept: application/json
Authorization: Bearer {your-token}
```

**Success Response** (200):
```json
{
  "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
  "full_name": "John Doe",
  "phonenumber": "1234567890",
  "role": "citizen",
  "address": "123 Main St"
}
```

---

## Client Implementation Guide

### 1. Mobile App (Android/iOS)

#### React Native Example

```javascript
import AsyncStorage from '@react-native-async-storage/async-storage';

const API_URL = 'http://your-backend.com/api';

// Login
async function login(phonenumber, password) {
  try {
    const response = await fetch(`${API_URL}/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify({ phonenumber, password }),
    });

    const data = await response.json();

    if (response.ok) {
      // Store token securely
      await AsyncStorage.setItem('auth_token', data.data.token);
      await AsyncStorage.setItem('user', JSON.stringify(data.data.user));
      return data;
    } else {
      throw new Error(data.message);
    }
  } catch (error) {
    console.error('Login error:', error);
    throw error;
  }
}

// Make authenticated request
async function fetchUserData() {
  const token = await AsyncStorage.getItem('auth_token');
  
  const response = await fetch(`${API_URL}/user`, {
    method: 'GET',
    headers: {
      'Accept': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
  });

  return await response.json();
}

// Logout
async function logout() {
  const token = await AsyncStorage.getItem('auth_token');
  
  await fetch(`${API_URL}/logout`, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
  });

  // Clear local storage
  await AsyncStorage.removeItem('auth_token');
  await AsyncStorage.removeItem('user');
}
```

#### Flutter/Dart Example

```dart
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String apiUrl = 'http://your-backend.com/api';

  // Login
  Future<Map<String, dynamic>> login(String phonenumber, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phonenumber': phonenumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Store token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['data']['token']);
      await prefs.setString('user', jsonEncode(data['data']['user']));
      
      return data;
    } else {
      throw Exception('Login failed');
    }
  }

  // Make authenticated request
  Future<http.Response> authenticatedRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.get(
      Uri.parse('$apiUrl/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    await http.post(
      Uri.parse('$apiUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    await prefs.remove('auth_token');
    await prefs.remove('user');
  }
}
```

---

### 2. Windows Desktop App (.NET/C#)

#### C# Example with HttpClient

```csharp
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

public class AuthService
{
    private static readonly HttpClient client = new HttpClient();
    private const string ApiUrl = "http://your-backend.com/api";

    // Login
    public static async Task<LoginResponse> Login(string phonenumber, string password)
    {
        var loginData = new
        {
            phonenumber = phonenumber,
            password = password
        };

        var json = JsonSerializer.Serialize(loginData);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        var response = await client.PostAsync($"{ApiUrl}/login", content);
        var responseBody = await response.Content.ReadAsStringAsync();

        if (response.IsSuccessStatusCode)
        {
            var result = JsonSerializer.Deserialize<LoginResponse>(responseBody);
            
            // Store token (use secure storage in production)
            Properties.Settings.Default.AuthToken = result.data.token;
            Properties.Settings.Default.Save();
            
            return result;
        }
        else
        {
            throw new Exception("Login failed");
        }
    }

    // Make authenticated request
    public static async Task<string> GetUserData()
    {
        client.DefaultRequestHeaders.Authorization = 
            new AuthenticationHeaderValue("Bearer", Properties.Settings.Default.AuthToken);

        var response = await client.GetAsync($"{ApiUrl}/user");
        return await response.Content.ReadAsStringAsync();
    }

    // Logout
    public static async Task Logout()
    {
        client.DefaultRequestHeaders.Authorization = 
            new AuthenticationHeaderValue("Bearer", Properties.Settings.Default.AuthToken);

        await client.PostAsync($"{ApiUrl}/logout", null);

        // Clear stored token
        Properties.Settings.Default.AuthToken = string.Empty;
        Properties.Settings.Default.Save();
    }
}

// Response models
public class LoginResponse
{
    public bool success { get; set; }
    public string message { get; set; }
    public LoginData data { get; set; }
}

public class LoginData
{
    public User user { get; set; }
    public string token { get; set; }
}

public class User
{
    public string id { get; set; }
    public string full_name { get; set; }
    public string phonenumber { get; set; }
    public string role { get; set; }
    public string address { get; set; }
}
```

---

### 3. Web Application (React/Vue/Angular)

#### React with Axios

```javascript
import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000/api';

// Create axios instance
const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Add token to requests
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Handle auth errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('auth_token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth functions
export const authService = {
  async login(phonenumber, password) {
    const response = await api.post('/login', { phonenumber, password });
    if (response.data.success) {
      localStorage.setItem('auth_token', response.data.data.token);
      localStorage.setItem('user', JSON.stringify(response.data.data.user));
    }
    return response.data;
  },

  async adminLogin(phonenumber, password) {
    const response = await api.post('/login/admin', { phonenumber, password });
    if (response.data.success) {
      localStorage.setItem('auth_token', response.data.data.token);
      localStorage.setItem('user', JSON.stringify(response.data.data.user));
    }
    return response.data;
  },

  async logout() {
    await api.post('/logout');
    localStorage.removeItem('auth_token');
    localStorage.removeItem('user');
  },

  async getCurrentUser() {
    const response = await api.get('/user');
    return response.data;
  },

  getToken() {
    return localStorage.getItem('auth_token');
  },

  getUser() {
    const user = localStorage.getItem('user');
    return user ? JSON.parse(user) : null;
  },

  isAuthenticated() {
    return !!this.getToken();
  },
};

export default api;
```

#### Usage in React Component

```jsx
import React, { useState } from 'react';
import { authService } from './services/authService';

function LoginPage() {
  const [phonenumber, setPhonenumber] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      await authService.login(phonenumber, password);
      window.location.href = '/dashboard';
    } catch (err) {
      setError(err.response?.data?.message || 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleLogin}>
      <input
        type="text"
        placeholder="Phone Number"
        value={phonenumber}
        onChange={(e) => setPhonenumber(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      {error && <div className="error">{error}</div>}
      <button type="submit" disabled={loading}>
        {loading ? 'Logging in...' : 'Login'}
      </button>
    </form>
  );
}
```

---

## Backend Configuration

### Environment Variables

Add to your `.env` file:

```env
# Application
APP_URL=http://localhost:8000

# Sanctum Configuration
SANCTUM_STATEFUL_DOMAINS=localhost:3000,localhost:5173,localhost:8080

# Optional: Token Expiration (in minutes, null = never expires)
# Add this to config/sanctum.php: 'expiration' => env('SANCTUM_TOKEN_EXPIRATION', 43200), // 30 days
```

### Token Expiration (Recommended)

Update `config/sanctum.php`:

```php
return [
    // ... existing config ...

    // Token expiration in minutes (43200 = 30 days)
    'expiration' => env('SANCTUM_TOKEN_EXPIRATION', 43200),

    // ... rest of config ...
];
```

### CORS Configuration

Update `config/cors.php` for cross-origin requests:

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // Restrict in production
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false, // false for token-based auth
];
```

---

## Security Best Practices

### 1. Secure Token Storage

**Mobile Apps**:
- **iOS**: Use Keychain Services
- **Android**: Use EncryptedSharedPreferences or Keystore
- **Never** store in plain SharedPreferences/UserDefaults

**Windows Apps**:
- Use Windows Data Protection API (DPAPI)
- Or PasswordVault for UWP apps
- Avoid plain text files

**Web Apps**:
- Store in `localStorage` or `sessionStorage`
- Consider HttpOnly cookies for better XSS protection
- Never expose tokens in URLs

### 2. Token Expiration
```php
// config/sanctum.php
'expiration' => 43200, // 30 days in minutes
```

### 3. Refresh Token Pattern (Optional)
Implement refresh tokens for long-lived sessions:
- Short-lived access token (15 minutes)
- Long-lived refresh token (30 days)
- Refresh endpoint to get new access token

### 4. Rate Limiting
Add rate limiting to login endpoints in `app/Http/Kernel.php` or `bootstrap/app.php`.

### 5. HTTPS in Production
Always use HTTPS in production to prevent token interception.

### 6. Revoke Compromised Tokens
```php
// Revoke single token
$request->user()->currentAccessToken()->delete();

// Revoke all user tokens
$user->tokens()->delete();

// Revoke specific token
$user->tokens()->where('id', $tokenId)->delete();
```

---

## Testing

### Test with cURL

```bash
# Register
curl -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "full_name": "Test User",
    "phonenumber": "1234567890",
    "password": "password123",
    "address": "Test Address"
  }'

# Login (Citizen)
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "phonenumber": "1234567890",
    "password": "password123"
  }'

# Login (Admin)
curl -X POST http://localhost:8000/api/login/admin \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "phonenumber": "admin_phone",
    "password": "admin_password"
  }'

# Get User (replace YOUR_TOKEN)
curl -X GET http://localhost:8000/api/user \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Logout
curl -X POST http://localhost:8000/api/logout \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Test with Postman

1. **POST** `http://localhost:8000/api/login` with JSON body
2. Copy the token from response
3. In Postman, go to Authorization tab → Type: Bearer Token → Paste token
4. Make authenticated requests (GET `/api/user`, POST `/api/logout`, etc.)

---

## Troubleshooting

### Common Issues

#### 1. 401 Unauthorized
**Causes**:
- Token not sent in Authorization header
- Token expired or invalid
- Token revoked

**Solutions**:
- Ensure `Authorization: Bearer {token}` header is included
- Check token expiration setting
- Re-login to get new token

#### 2. CORS Error
**Cause**: Frontend origin not allowed

**Solutions**:
- Update `config/cors.php` to allow your frontend origin
- Ensure CORS middleware is enabled
- Check `allowed_origins` configuration

#### 3. Token Not Working After Login
**Causes**:
- Token not stored correctly
- Token not sent in requests
- Bearer prefix missing

**Solutions**:
- Verify token is stored after login
- Check Authorization header format: `Bearer {token}`
- Ensure no extra spaces in header

---

## Role-Based Access Control

### Protect Routes by Role

Add middleware to routes in `routes/api.php`:

```php
// Admin only routes
Route::middleware(['auth:sanctum', 'role:admin,superadmin'])->group(function () {
    Route::get('/admin/users', [AdminController::class, 'users']);
    Route::post('/admin/settings', [AdminController::class, 'updateSettings']);
    // ... more admin routes
});

// Citizen only routes
Route::middleware(['auth:sanctum', 'role:citizen'])->group(function () {
    Route::post('/complaints', [ComplaintController::class, 'store']);
    Route::post('/suggestions', [SuggestionController::class, 'store']);
});
```

### Check Role in Frontend

```javascript
// React example
const user = authService.getUser();

if (user.role === 'admin' || user.role === 'superadmin') {
  // Show admin dashboard
} else {
  // Show citizen dashboard
}
```

---

## Production Deployment Checklist

- [ ] Enable HTTPS for all API endpoints
- [ ] Set token expiration (`SANCTUM_TOKEN_EXPIRATION=43200`)
- [ ] Configure CORS for production domains only
- [ ] Use secure token storage on clients
- [ ] Enable rate limiting on authentication endpoints
- [ ] Implement token refresh mechanism (optional)
- [ ] Set up proper error logging
- [ ] Configure database indexes on `personal_access_tokens` table
- [ ] Implement account lockout after failed login attempts
- [ ] Add monitoring for suspicious authentication activity

---

## Comparison: Mobile vs Desktop vs Web

| Feature | Mobile App | Windows App | Web App |
|---------|-----------|-------------|---------|
| **Token Storage** | Keychain/Keystore | DPAPI/PasswordVault | localStorage |
| **Security** | ✅✅✅ High | ✅✅✅ High | ✅✅ Medium |
| **XSS Vulnerability** | ❌ No | ❌ No | ⚠️ Yes |
| **Token Expiration** | Recommended 30 days | Recommended 30 days | Recommended 1-7 days |
| **Offline Support** | ✅ Yes | ✅ Yes | ⚠️ Limited |
| **CORS Issues** | ❌ No | ❌ No | ⚠️ Possible |

---

## Support

For issues or questions:
1. Check Laravel logs: `storage/logs/laravel.log`
2. Verify `.env` configuration
3. Test with cURL to isolate client issues
4. Check token is being sent correctly in Authorization header

---

**Authentication Type**: Token-Based (Laravel Sanctum)  
**Supported Platforms**: Mobile (iOS/Android), Desktop (Windows), Web (React/Vue/Angular)  
**Last Updated**: December 25, 2025

---

## Authentication Flow

### 1. Login Process
```
Frontend sends credentials → Backend validates → Session created → Cookie returned → Subsequent requests authenticated
```

### 2. Session Management
- **Session Duration**: 2 hours (120 minutes) - configurable via `SESSION_LIFETIME` in `.env`
- **Driver**: Database (sessions stored in `sessions` table)
- **Cookie Name**: `laravel_session` (or `{APP_NAME}_session`)
- **CSRF Protection**: Required for all POST/PUT/PATCH/DELETE requests

---

## API Endpoints

### Login (Admin Portal)

**Endpoint**: `POST /admin/login`

**Headers**:
```http
Content-Type: application/json
Accept: application/json
X-XSRF-TOKEN: {csrf-token}  // Required for CSRF protection
```

**Request Body**:
```json
{
  "phonenumber": "1234567890",
  "password": "your_password"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Admin login successful",
  "data": {
    "user": {
      "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
      "full_name": "John Doe",
      "phonenumber": "1234567890",
      "role": "admin",
      "address": "123 Main St"
    }
  }
}
```

**Error Responses**:

- **Invalid Credentials** (401):
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

- **Unauthorized Role** (403):
```json
{
  "success": false,
  "message": "Unauthorized. Admin access required."
}
```

**Important Notes**:
- Only users with `admin` or `superadmin` roles can login
- Session cookie is automatically set in response headers
- Citizens cannot access admin portal

---

### Logout (Admin Portal)

**Endpoint**: `POST /admin/logout`

**Headers**:
```http
Content-Type: application/json
Accept: application/json
X-XSRF-TOKEN: {csrf-token}
Cookie: laravel_session={session-id}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Admin logged out successfully",
  "data": null
}
```

**Important Notes**:
- Requires active session (authenticated user)
- Invalidates session and regenerates CSRF token
- All session data is cleared

---

### Get Current User

**Endpoint**: `GET /api/user`

**Headers**:
```http
Accept: application/json
Cookie: laravel_session={session-id}
```

**Success Response** (200):
```json
{
  "id": "01JG8X2Y3Z4A5B6C7D8E9F0G1H",
  "full_name": "John Doe",
  "phonenumber": "1234567890",
  "role": "admin",
  "address": "123 Main St"
}
```

---

## Frontend Implementation Guide

### 1. CSRF Token Setup

Laravel requires CSRF tokens for all state-changing requests (POST, PUT, PATCH, DELETE).

**Option A: Using Laravel Sanctum (SPA Authentication)**

For single-page applications on the same domain:

```javascript
// Step 1: Initialize CSRF cookie
await fetch('http://your-backend.com/sanctum/csrf-cookie', {
  method: 'GET',
  credentials: 'include', // Important: include cookies
});

// Step 2: Make authenticated requests
const response = await fetch('http://your-backend.com/admin/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  credentials: 'include', // Important: include cookies
  body: JSON.stringify({
    phonenumber: '1234567890',
    password: 'password123',
  }),
});
```

**Option B: Manual CSRF Token (if not using Sanctum SPA)**

```javascript
// Get CSRF token from cookie
function getCsrfToken() {
  const name = 'XSRF-TOKEN=';
  const decodedCookie = decodeURIComponent(document.cookie);
  const cookieArray = decodedCookie.split(';');
  
  for(let cookie of cookieArray) {
    cookie = cookie.trim();
    if (cookie.indexOf(name) === 0) {
      return cookie.substring(name.length);
    }
  }
  return null;
}

// Include in request headers
const response = await fetch('http://your-backend.com/admin/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-XSRF-TOKEN': getCsrfToken(),
  },
  credentials: 'include',
  body: JSON.stringify(credentials),
});
```

---

### 2. Login Implementation

#### React Example

```jsx
import { useState } from 'react';

function LoginPage() {
  const [phonenumber, setPhonenumber] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      // Step 1: Get CSRF cookie (for Sanctum SPA)
      await fetch(`${process.env.REACT_APP_API_URL}/sanctum/csrf-cookie`, {
        credentials: 'include',
      });

      // Step 2: Login
      const response = await fetch(`${process.env.REACT_APP_API_URL}/admin/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        credentials: 'include',
        body: JSON.stringify({ phonenumber, password }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Login failed');
      }

      // Success - redirect to dashboard
      localStorage.setItem('user', JSON.stringify(data.data.user));
      window.location.href = '/admin/dashboard';
      
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleLogin}>
      <input
        type="text"
        placeholder="Phone Number"
        value={phonenumber}
        onChange={(e) => setPhonenumber(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
        minLength={6}
      />
      {error && <div className="error">{error}</div>}
      <button type="submit" disabled={loading}>
        {loading ? 'Logging in...' : 'Login'}
      </button>
    </form>
  );
}
```

#### Vue.js Example

```vue
<template>
  <form @submit.prevent="handleLogin">
    <input
      v-model="phonenumber"
      type="text"
      placeholder="Phone Number"
      required
    />
    <input
      v-model="password"
      type="password"
      placeholder="Password"
      required
      minlength="6"
    />
    <div v-if="error" class="error">{{ error }}</div>
    <button type="submit" :disabled="loading">
      {{ loading ? 'Logging in...' : 'Login' }}
    </button>
  </form>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      phonenumber: '',
      password: '',
      error: '',
      loading: false,
    };
  },
  methods: {
    async handleLogin() {
      this.loading = true;
      this.error = '';

      try {
        // Get CSRF cookie
        await axios.get(`${process.env.VUE_APP_API_URL}/sanctum/csrf-cookie`);

        // Login
        const response = await axios.post(
          `${process.env.VUE_APP_API_URL}/admin/login`,
          {
            phonenumber: this.phonenumber,
            password: this.password,
          }
        );

        // Success
        localStorage.setItem('user', JSON.stringify(response.data.data.user));
        this.$router.push('/admin/dashboard');
        
      } catch (err) {
        this.error = err.response?.data?.message || 'Login failed';
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
```

#### Vanilla JavaScript Example

```javascript
document.getElementById('loginForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  
  const phonenumber = document.getElementById('phonenumber').value;
  const password = document.getElementById('password').value;
  const errorDiv = document.getElementById('error');
  
  try {
    // Get CSRF cookie
    await fetch('http://localhost:8000/sanctum/csrf-cookie', {
      credentials: 'include',
    });
    
    // Login
    const response = await fetch('http://localhost:8000/admin/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify({ phonenumber, password }),
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.message);
    }
    
    // Success
    localStorage.setItem('user', JSON.stringify(data.data.user));
    window.location.href = '/admin/dashboard.html';
    
  } catch (error) {
    errorDiv.textContent = error.message;
  }
});
```

---

### 3. Logout Implementation

```javascript
async function logout() {
  try {
    const response = await fetch(`${API_URL}/admin/logout`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      credentials: 'include',
    });

    if (response.ok) {
      // Clear local storage
      localStorage.removeItem('user');
      
      // Redirect to login
      window.location.href = '/admin/login';
    }
  } catch (error) {
    console.error('Logout failed:', error);
  }
}
```

---

### 4. Axios Configuration (Recommended)

For easier session management, configure Axios globally:

```javascript
// api.js
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:8000',
  withCredentials: true, // Important: send cookies with requests
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Add CSRF token interceptor
api.interceptors.request.use(
  (config) => {
    // Get CSRF token from cookie
    const token = document.cookie
      .split('; ')
      .find(row => row.startsWith('XSRF-TOKEN='))
      ?.split('=')[1];
    
    if (token) {
      config.headers['X-XSRF-TOKEN'] = decodeURIComponent(token);
    }
    
    return config;
  },
  (error) => Promise.reject(error)
);

// Add response interceptor for auth errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Redirect to login
      localStorage.removeItem('user');
      window.location.href = '/admin/login';
    }
    return Promise.reject(error);
  }
);

export default api;
```

**Usage**:
```javascript
import api from './api';

// Login
const login = async (phonenumber, password) => {
  // Get CSRF cookie first
  await api.get('/sanctum/csrf-cookie');
  
  const response = await api.post('/admin/login', { phonenumber, password });
  return response.data;
};

// Logout
const logout = async () => {
  const response = await api.post('/admin/logout');
  return response.data;
};
```

---

## Backend Configuration

### Required Environment Variables

Add to your `.env` file:

```env
# Application
APP_URL=http://localhost:8000

# Session Configuration
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_SECURE_COOKIE=false  # Set to true in production with HTTPS
SESSION_SAME_SITE=lax

# Sanctum Configuration (for SPA authentication)
SANCTUM_STATEFUL_DOMAINS=localhost:3000,localhost:5173
```

### CORS Configuration

If frontend is on a different domain/port, update `config/cors.php`:

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie', 'admin/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'http://localhost:3000',  // React default
        'http://localhost:5173',  // Vite default
        'http://localhost:8080',  // Vue CLI default
    ],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,  // Important: must be true for sessions
];
```

---

## Security Best Practices

### 1. HTTPS in Production
Always use HTTPS in production. Update `.env`:
```env
SESSION_SECURE_COOKIE=true
```

### 2. Same-Site Cookie Policy
```env
SESSION_SAME_SITE=lax  # or 'strict' for more security
```

### 3. CSRF Protection
- Always include CSRF token in state-changing requests
- CSRF token is automatically included in cookies by Sanctum

### 4. Session Timeout
- Sessions expire after 2 hours of inactivity (configurable)
- Users must re-login after expiration

### 5. Role-Based Access
- Only `admin` and `superadmin` roles can access admin portal
- Role is checked on every login attempt
- Frontend should also verify role from user object

---

## Testing

### Test Login with cURL

```bash
# Step 1: Get CSRF cookie
curl -X GET http://localhost:8000/sanctum/csrf-cookie \
  -c cookies.txt

# Step 2: Login
curl -X POST http://localhost:8000/admin/login \
  -b cookies.txt \
  -c cookies.txt \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "phonenumber": "1234567890",
    "password": "your_password"
  }'

# Step 3: Access protected route
curl -X GET http://localhost:8000/api/user \
  -b cookies.txt \
  -H "Accept: application/json"

# Step 4: Logout
curl -X POST http://localhost:8000/admin/logout \
  -b cookies.txt \
  -H "Accept: application/json"
```

### Test with Postman

1. **Settings** → Enable "Automatically follow redirects"
2. **GET** `http://localhost:8000/sanctum/csrf-cookie`
3. **POST** `http://localhost:8000/admin/login` with JSON body
4. Cookies are automatically saved and sent with subsequent requests

---

## Troubleshooting

### Common Issues

#### 1. CSRF Token Mismatch (419)
**Cause**: CSRF token not sent or invalid

**Solutions**:
- Ensure you call `/sanctum/csrf-cookie` before login
- Include `credentials: 'include'` in fetch requests
- Add `withCredentials: true` in Axios config
- Check CORS `supports_credentials` is `true`

#### 2. CORS Error
**Cause**: Frontend domain not allowed

**Solutions**:
- Add frontend URL to `SANCTUM_STATEFUL_DOMAINS` in `.env`
- Update `config/cors.php` to allow frontend origin
- Ensure `supports_credentials: true` in CORS config

#### 3. Session Not Persisting
**Cause**: Cookies not being saved/sent

**Solutions**:
- Use `credentials: 'include'` in all requests
- Check `withCredentials: true` in Axios
- Verify cookies are enabled in browser
- Check `SESSION_DOMAIN` matches your domain

#### 4. 401 Unauthorized on Protected Routes
**Cause**: Session expired or invalid

**Solutions**:
- Check session lifetime in `.env`
- Ensure cookies are sent with request
- Re-login if session expired

---

## Production Deployment Checklist

- [ ] Set `SESSION_SECURE_COOKIE=true` in `.env`
- [ ] Use HTTPS for all requests
- [ ] Update `SANCTUM_STATEFUL_DOMAINS` with production domain
- [ ] Configure CORS for production frontend URL
- [ ] Set `SESSION_SAME_SITE=strict` or `lax`
- [ ] Configure proper `SESSION_DOMAIN` if using subdomains
- [ ] Enable rate limiting on login endpoint
- [ ] Implement proper error logging
- [ ] Set up session garbage collection
- [ ] Configure secure session storage (Redis recommended)

---

## Support

For issues or questions:
1. Check Laravel logs: `storage/logs/laravel.log`
2. Verify `.env` configuration
3. Test with cURL to isolate frontend issues
4. Check browser network tab for cookie/header details

---

**Last Updated**: December 25, 2025
