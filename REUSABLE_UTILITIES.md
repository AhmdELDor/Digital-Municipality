# Reusable Utilities Documentation

## Overview
This document describes the reusable utilities created for the Digital Municipality Flutter app to reduce code duplication and improve maintainability.

## Phone Number Utility (`PhoneUtils`)

**Location**: `lib/core/utils/phone_utils.dart`

### Features
- Automatic +961 (Lebanon) country code prefixing
- Lebanese phone number validation (mobile and landline)
- Input formatting and filtering
- Reusable text field widget

### Usage
```dart
// Import the utility
import '../../../core/utils/phone_utils.dart';

// Use the reusable phone text field
PhoneUtils.buildPhoneTextField(
  controller: phoneController,
  label: 'رقم الهاتف',
  hint: '+961xxxxxxxx',
  isRequired: true, // Optional, defaults to true
)

// Format phone number programmatically
String formatted = PhoneUtils.formatWithCountryCode('70123456');
// Result: '+96170123456'

// Validate phone number
bool isValid = PhoneUtils.isValidLebanesePhone('+96170123456');
```

### Validation Rules
- **Mobile numbers**: 8 digits starting with: 03, 70, 71, 76, 78, 79, 81
- **Landline numbers**: 8 digits starting with: 01, 04, 05, 06, 07, 08, 09
- Automatic formatting removes any non-digits and adds +961 prefix
- Handles various input formats (with/without country code)

## Image Upload Utility (`ImageUploadUtils`)

**Location**: `lib/core/utils/image_upload_utils.dart`

### Features
- Image selection from device gallery
- File type validation (JPG, PNG, GIF, WebP, BMP)
- File size validation using FileUploadService
- Image preview with error handling
- Success/error message utilities
- Reusable upload widget

### Usage
```dart
// Import the utility
import '../../../core/utils/image_upload_utils.dart';

// Use the reusable image upload field
ImageUploadUtils.buildImageUploadField(
  label: 'شعار الخدمة',
  controller: imageController,
  onImageSelected: _pickImage,
  selectedImage: selectedImageFile,
  currentImageUrl: existingImageUrl, // For edit mode
  isRequired: false, // Optional, defaults to false
)

// Pick image programmatically
File? imageFile = await ImageUploadUtils.pickImage();

// Show messages
ImageUploadUtils.showErrorMessage(context, 'خطأ في الصورة');
ImageUploadUtils.showSuccessMessage(context, 'تم رفع الصورة بنجاح');
```

### Validation Rules
- **Supported formats**: JPG, JPEG, PNG, GIF, BMP, WebP
- **File size limit**: Configured in `FileUploadService.maxFileSize`
- **Image optimization**: Automatically resizes to 1024x1024 max with 80% quality
- **Error handling**: Comprehensive validation with Arabic error messages

## Implementation

### Updated Components
1. **Login Screen** - Uses `PhoneUtils.buildPhoneTextField()`
2. **Service Form Dialog** - Uses both utilities
3. **User Form Dialog** - Uses `PhoneUtils.buildPhoneTextField()`

### Benefits
- ✅ **Consistent UI/UX** across all forms
- ✅ **Reduced code duplication** - over 100 lines saved
- ✅ **Centralized validation** - easy to update rules
- ✅ **Better maintainability** - single point of change
- ✅ **Standardized formatting** - consistent Lebanese phone format
- ✅ **Improved error handling** - unified message system

### File Structure
```
lib/
  core/
    utils/
      phone_utils.dart          ← Lebanese phone number handling
      image_upload_utils.dart   ← Image selection and validation
      call_utils.dart          ← WhatsApp/SMS calling (existing)
```

## Migration Notes

### Before
Each form had its own phone validation logic:
```dart
TextFormField(
  // Custom validation and formatting for each form
  validator: (value) {
    // Repeated validation logic
  },
  onChanged: (value) {
    // Manual +961 prefixing
  },
)
```

### After
All forms use the same utility:
```dart
PhoneUtils.buildPhoneTextField(
  controller: phoneController,
  label: 'رقم الهاتف',
)
```

### Breaking Changes
- None - backward compatible
- Existing forms migrated automatically
- Phone formatting now happens automatically

### Testing
- ✅ Phone validation works consistently across login, user, and service forms
- ✅ Image upload maintains existing file validation
- ✅ Error messages display properly in Arabic
- ✅ No compilation errors introduced