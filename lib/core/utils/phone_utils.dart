import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneUtils {
  // Lebanon country code
  static const String lebanonCountryCode = '+961';
  
  // Format phone number with Lebanon prefix
  static String formatWithCountryCode(String phoneNumber) {
    // First, remove all non-digit characters (spaces, |, +, etc.) except we need to preserve the leading +
    // So we extract only digits
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // If starts with 961, add +
    if (cleanNumber.startsWith('961')) {
      return '+$cleanNumber';
    }
    
    // If starts with 0, remove it and add country code
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }
    
    // Add country code
    return '$lebanonCountryCode$cleanNumber';
  }
  
  // Validate Lebanese phone number
  static bool isValidLebanesePhone(String phoneNumber) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Remove country code for validation
    if (cleanNumber.startsWith('961')) {
      cleanNumber = cleanNumber.substring(3);
    }
    
    // Lebanese mobile numbers are 8 digits and start with specific prefixes
    // Mobile: 03, 70, 71, 76, 78, 79, 81
    // Landline: 01, 04, 05, 06, 07, 08, 09
    final mobileRegex = RegExp(r'^(03|70|71|76|78|79|81)\d{6}$');
    final landlineRegex = RegExp(r'^(01|04|05|06|07|08|09)\d{6}$');
    
    return mobileRegex.hasMatch(cleanNumber) || landlineRegex.hasMatch(cleanNumber);
  }
  
  // Get phone input formatter - simple version
  static TextInputFormatter getPhoneInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String newText = newValue.text;
      
      // Always keep +961 prefix
      const prefix = '+961';
      
      // If user is trying to delete the prefix, prevent it
      if (!newText.startsWith(prefix)) {
        // Extract only the numbers after any prefix attempts
        String numbers = newText.replaceAll(RegExp(r'[^\d]'), '');
        if (numbers.startsWith('961')) {
          numbers = numbers.substring(3);
        }
        
        // Build the text with prefix
        newText = prefix + numbers;
        
        // Limit to 8 digits after prefix
        if (numbers.length > 8) {
          numbers = numbers.substring(0, 8);
          newText = prefix + numbers;
        }
        
        // Calculate cursor position
        int cursorPos = newText.length;
        if (cursorPos < prefix.length) {
          cursorPos = prefix.length;
        }
        
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPos),
        );
      }
      
      // Get numbers after prefix
      String numbers = newText.substring(prefix.length).replaceAll(RegExp(r'[^\d]'), '');
      
      // Limit to 8 digits
      if (numbers.length > 8) {
        numbers = numbers.substring(0, 8);
      }
      
      newText = prefix + numbers;
      
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    });
  }
  
  // Create phone text field with Lebanon formatting
  static Widget buildPhoneTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    // Initialize with prefix if empty
    if (controller.text.isEmpty) {
      controller.text = '+961';
      controller.selection = TextSelection.collapsed(offset: controller.text.length);
    }
    
    return TextFormField(
      controller: controller,
      inputFormatters: [getPhoneInputFormatter()],
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: hint ?? '+961xxxxxxxx',
        helperText: 'أدخل الرقم بعد +961',
      ),
      keyboardType: TextInputType.phone,
      validator: validator ?? (value) {
        if (isRequired && (value == null || value.isEmpty || value == '+961')) {
          return 'الرجاء إدخال رقم الهاتف';
        }
        if (value != null && value.isNotEmpty && value != '+961' && !isValidLebanesePhone(value)) {
          return 'رقم الهاتف غير صحيح';
        }
        return null;
      },
    );
  }
}