import 'package:url_launcher/url_launcher.dart';

class CallUtils {
  // Launch WhatsApp with phone number
  static Future<bool> launchWhatsApp(String phoneNumber) async {
    try {
      // Remove any special characters and spaces from phone number
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      // WhatsApp URL scheme
      final whatsappUrl = 'https://wa.me/$cleanNumber';
      
      final uri = Uri.parse(whatsappUrl);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      throw Exception('Failed to open WhatsApp: ${e.toString()}');
    }
  }

  // Launch SMS with phone number
  static Future<bool> launchSMS(String phoneNumber, {String? message}) async {
    try {
      // Remove any special characters and spaces from phone number
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      // SMS URL scheme
      String smsUrl = 'sms:$cleanNumber';
      if (message != null && message.isNotEmpty) {
        smsUrl += '?body=${Uri.encodeComponent(message)}';
      }
      
      final uri = Uri.parse(smsUrl);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch SMS');
      }
    } catch (e) {
      throw Exception('Failed to open SMS: ${e.toString()}');
    }
  }

  // Launch phone dialer
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      // Remove any special characters and spaces from phone number
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      // Phone URL scheme
      final phoneUrl = 'tel:$cleanNumber';
      
      final uri = Uri.parse(phoneUrl);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch phone dialer');
      }
    } catch (e) {
      throw Exception('Failed to open phone dialer: ${e.toString()}');
    }
  }

  // Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Basic validation: should have at least 7 digits and may start with +
    final phoneRegex = RegExp(r'^\+?[1-9]\d{6,14}$');
    return phoneRegex.hasMatch(cleanNumber);
  }

  // Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it's a valid international number starting with +, return as is
    if (cleanNumber.startsWith('+')) {
      return cleanNumber;
    }
    
    // If it doesn't start with +, add country code (you may want to adjust this)
    if (cleanNumber.length >= 7) {
      return '+$cleanNumber';
    }
    
    return phoneNumber; // Return original if can't format
  }
}