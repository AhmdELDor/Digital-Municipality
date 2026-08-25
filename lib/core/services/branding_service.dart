import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api_service.dart';
import 'storage_service.dart';
import '../constants/api_constants.dart';

class BrandingService {
  final ApiService _apiService;
  final StorageService _storageService;

  BrandingService(this._apiService, this._storageService);

  // Fetch branding settings from API
  Future<Map<String, dynamic>> fetchBrandingSettings() async {
    try {
      final response = await _apiService.get(ApiConstants.settings);

      if (response.statusCode == 200) {
        final settings = response.data['data'] as List;
        
        // Extract branding settings
        String? logo;
        String? name;
        String? primaryColor;
        String? secondaryColor;

        for (var setting in settings) {
          switch (setting['key']) {
            case 'branding_logo':
              logo = setting['value'];
              break;
            case 'branding_name':
              name = setting['value'];
              break;
            case 'branding_primary_color':
              primaryColor = setting['value'];
              break;
            case 'branding_secondary_color':
              secondaryColor = setting['value'];
              break;
          }
        }

        // Save to local storage
        if (logo != null) await _storageService.saveBrandingLogo(logo);
        if (name != null) await _storageService.saveBrandingName(name);
        if (primaryColor != null && secondaryColor != null) {
          await _storageService.saveBrandingColors(primaryColor, secondaryColor);
        }

        return {
          'success': true,
          'logo': logo,
          'name': name,
          'primaryColor': primaryColor,
          'secondaryColor': secondaryColor,
        };
      } else {
        return {
          'success': false,
          'message': 'فشل جلب إعدادات العلامة التجارية',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Get branding logo (from cache or API)
  String? getBrandingLogo() {
    return _storageService.getBrandingLogo();
  }

  // Get branding name (from cache or API)
  String? getBrandingName() {
    return _storageService.getBrandingName();
  }

  // Get primary color (from cache or default)
  Color getPrimaryColor() {
    final colorString = _storageService.getPrimaryColor();
    if (colorString != null) {
      return _parseColor(colorString);
    }
    return const Color(0xFF1565C0); // Default blue
  }

  // Get secondary color (from cache or default)
  Color getSecondaryColor() {
    final colorString = _storageService.getSecondaryColor();
    if (colorString != null) {
      return _parseColor(colorString);
    }
    return const Color(0xFF0D47A1); // Default dark blue
  }

  // Parse color from hex string
  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add alpha if not present
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // Convert color to hex string
  String colorToHex(Color color) {
    final value = (color.a.toInt() << 24) |
                  (color.r.toInt() << 16) |
                  (color.g.toInt() << 8) |
                  color.b.toInt();
    return '#${value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Update branding settings (Super Admin only)
  Future<Map<String, dynamic>> updateBrandingSetting({
    required String key,
    required String value,
  }) async {
    try {
      // First, check if setting exists
      final getResponse = await _apiService.get(ApiConstants.settings);
      
      if (getResponse.statusCode == 200) {
        final settings = getResponse.data['data'] as List;
        final existingSetting = settings.firstWhere(
          (s) => s['key'] == key,
          orElse: () => null,
        );

        Response response;
        if (existingSetting != null) {
          // Update existing setting
          response = await _apiService.put(
            '${ApiConstants.settings}/${existingSetting['id']}',
            data: {'key': key, 'value': value},
          );
        } else {
          // Create new setting
          response = await _apiService.post(
            ApiConstants.settings,
            data: {'key': key, 'value': value},
          );
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Update local cache
          switch (key) {
            case 'branding_logo':
              await _storageService.saveBrandingLogo(value);
              break;
            case 'branding_name':
              await _storageService.saveBrandingName(value);
              break;
            case 'branding_primary_color':
              final secondary = _storageService.getSecondaryColor() ?? '#0D47A1';
              await _storageService.saveBrandingColors(value, secondary);
              break;
            case 'branding_secondary_color':
              final primary = _storageService.getPrimaryColor() ?? '#1565C0';
              await _storageService.saveBrandingColors(primary, value);
              break;
          }

          return {
            'success': true,
            'message': 'تم تحديث الإعدادات بنجاح',
          };
        }
      }

      return {
        'success': false,
        'message': 'فشل تحديث الإعدادات',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Clear cached branding
  Future<void> clearBrandingCache() async {
    await _storageService.remove('branding_logo');
    await _storageService.remove('branding_name');
    await _storageService.remove('branding_primary_color');
    await _storageService.remove('branding_secondary_color');
  }
}
