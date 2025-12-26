# Quick Start Guide - Digital Municipality Admin Portal

## 🚀 Getting Started in 5 Minutes

### Step 1: Update API URL

Open `lib/core/config/api_config.dart` and update:

```dart
// For local backend on same machine
static const String _devBaseUrl = 'http://localhost:8000';

// For testing on physical device (use your computer's IP)
// static const String _devBaseUrl = 'http://192.168.1.100:8000';

// For Android emulator
// static const String _devBaseUrl = 'http://10.0.2.2:8000';
```

### Step 2: Ensure Backend is Running

```bash
cd /path/to/your/backend
php artisan serve
```

Backend should be accessible at: `http://localhost:8000`

### Step 3: Create Admin User (if not exists)

In your backend, ensure you have an admin user:

```sql
-- Check if admin exists
SELECT * FROM users WHERE role IN ('admin', 'superadmin');

-- If not, you can create one via tinker or seeder
```

### Step 4: Run the Flutter App

```bash
flutter run -d windows    # For Windows
flutter run -d chrome     # For Web  
flutter run               # For mobile/other
```

### Step 5: Test Login

1. App opens to sign-in screen (Arabic RTL interface)
2. Select country code (default: Saudi Arabia 🇸🇦)
3. Enter phone number: e.g., `512345678`
4. Enter password
5. Click "تسجيل الدخول" (Sign In)
6. ✅ You're in!

---

## 📱 Test Credentials

Use your backend admin user credentials:
- **Phone**: Your admin's phone number
- **Password**: Your admin's password
- **Role**: Must be 'admin' or 'superadmin'

---

## ⚠️ Troubleshooting

### Problem: "خطأ في الاتصال" (Connection Error)

**Solution:**
1. Check backend is running: `php artisan serve`
2. Verify API URL matches backend URL
3. For physical devices, use your computer's IP address, not `localhost`

### Problem: "Invalid credentials"

**Solution:**
1. Verify phone number format (should include country code)
2. Check password is correct
3. Ensure user exists in database

### Problem: "Unauthorized. Admin access required"

**Solution:**
1. Check user role in database
2. Must be 'admin' or 'superadmin', not 'citizen'

---

## 🎯 What Works Now

✅ Arabic RTL interface  
✅ Phone number authentication  
✅ Country code picker  
✅ Token-based API authentication  
✅ Remember me functionality  
✅ Forgot password flow (phone verification)  
✅ Error handling with Arabic messages  
✅ Auto-logout on 401 errors  
✅ Secure token storage  

---

## 📂 Key Files to Know

| File | Purpose | When to Edit |
|------|---------|-------------|
| `lib/core/config/api_config.dart` | API URL & endpoints | Change backend URL |
| `lib/core/services/api_service.dart` | HTTP client | Modify requests |
| `lib/data/repositories/auth_repository.dart` | API calls | Add new endpoints |
| `lib/presentation/screens/auth_module/sign_in/` | Sign-in UI & logic | Change UI/behavior |

---

## 🔄 API Flow Visualization

```
Flutter App → API Service → Backend
     ↓             ↓           ↓
  UI Layer    HTTP Client   Laravel
     ↓             ↓           ↓
Controller ← Repository ← Auth API
     ↓
   Storage (Token saved)
     ↓
  Navigate to Dashboard
```

---

## 📝 Quick Commands

```bash
# Run app
flutter run -d windows

# Hot reload (while app is running)
Press 'r' in terminal

# Hot restart
Press 'R' in terminal

# Clear and rebuild
flutter clean
flutter pub get
flutter run

# Check for errors
flutter analyze
```

---

## 🌐 Network Configuration Reference

### Local Development

| Device Type | API URL | Notes |
|------------|---------|-------|
| Same machine | `http://localhost:8000` | Backend on same PC |
| Android Emulator | `http://10.0.2.2:8000` | Special emulator address |
| iOS Simulator | `http://localhost:8000` | Works like local |
| Physical Device | `http://192.168.1.X:8000` | Use your PC's local IP |

**To find your local IP:**
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

Look for "IPv4 Address" (e.g., 192.168.1.100)

---

## 📖 Full Documentation

For complete details, see:
- **IMPLEMENTATION_SUMMARY.md** - What was implemented
- **FLUTTER_API_INTEGRATION.md** - API integration guide
- **README_AUTH_ADMIN.md** - Backend API documentation
- **TEMPLATE_DOCUMENTATION.md** - Original template docs

---

## 🎉 Success Checklist

After completing steps above, you should see:
- ✅ Arabic interface with RTL layout
- ✅ Phone number input with country flags
- ✅ Password input field
- ✅ "تسجيل الدخول" button
- ✅ "نسيت كلمة المرور؟" link
- ✅ No Google/Apple sign-in buttons

When you login successfully:
- ✅ "تم تسجيل الدخول بنجاح" toast message
- ✅ Redirects to dashboard
- ✅ Token saved to storage

---

## 💡 Pro Tips

1. **Development Mode**: Keep `Environment.development` in api_config.dart
2. **Hot Reload**: Use 'r' key for quick UI changes
3. **Inspect Network**: Add LogInterceptor to see API requests
4. **Clear Data**: Logout to clear stored tokens
5. **Test Offline**: Turn off backend to see error handling

---

## 📞 Need Help?

1. Check terminal output for errors
2. Verify backend logs: `storage/logs/laravel.log`
3. Use Flutter DevTools for debugging
4. Check browser network tab (for web)

---

**Ready to go! 🚀**

Start your backend, run the app, and login with your admin credentials!
