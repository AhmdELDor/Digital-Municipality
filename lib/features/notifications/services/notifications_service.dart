import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/notification_model.dart';

class NotificationsService {
  final StorageService _storageService;

  NotificationsService(this._storageService);

  String get _baseUrl => ApiConstants.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _extractMeta(Map<String, dynamic> data) {
    // First check if meta exists and is a Map
    if (data['meta'] != null && data['meta'] is Map<String, dynamic>) {
      return data['meta'] as Map<String, dynamic>;
    }
    
    // Check for pagination key
    if (data['pagination'] != null && data['pagination'] is Map<String, dynamic>) {
      return data['pagination'] as Map<String, dynamic>;
    }
    
    // Check for nested meta in data
    if (data['data'] is Map<String, dynamic>) {
      final dataMap = data['data'] as Map<String, dynamic>;
      if (dataMap['meta'] != null && dataMap['meta'] is Map<String, dynamic>) {
        return dataMap['meta'] as Map<String, dynamic>;
      }
    }
    
    // If meta is not found or not a Map, return empty map
    print('⚠️ Warning: Meta not found or invalid type. Data keys: ${data.keys}');
    if (data['meta'] != null) {
      print('⚠️ Meta type: ${data['meta'].runtimeType}');
    }
    
    return {};
  }

  List<NotificationModel> _mapNotifications(dynamic data) {
    if (data is List) {
      return data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  List<NotificationModel> _extractNotificationList(Map<String, dynamic> data) {
    if (data['data'] is List) return _mapNotifications(data['data']);
    if (data['notifications'] is List) {
      return _mapNotifications(data['notifications']);
    }
    if (data['data'] is Map<String, dynamic> &&
        (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapNotifications(
          (data['data'] as Map<String, dynamic>)['data']);
    }
    return [];
  }

  // Get user notifications
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    String? type,
    bool? isRead,
  }) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl/notifications?page=$page';
      if (type != null && type.isNotEmpty) url += '&type=$type';
      if (isRead != null) url += '&is_read=${isRead ? 1 : 0}';

      final response = await http.get(Uri.parse(url), headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      print('🔍 Notifications API Response:');
      print('📍 URL: $url');
      print('📊 Status Code: ${response.statusCode}');
      print('📦 Data keys: ${data.keys}');
      print('� Full data structure: ${json.encode(data)}');
      
      // Check data types
      if (data['data'] != null) {
        print('📋 data type: ${data['data'].runtimeType}');
        if (data['data'] is List) {
          print('📋 Notifications count: ${(data['data'] as List).length}');
        }
      }
      if (data['meta'] != null) {
        print('📄 meta type: ${data['meta'].runtimeType}');
        if (data['meta'] is Map) {
          print('📄 meta content: ${data['meta']}');
        }
      }
      if (data['pagination'] != null) {
        print('📄 pagination type: ${data['pagination'].runtimeType}');
      }

      if (response.statusCode == 200) {
        final meta = _extractMeta(data);
        final notifications = _extractNotificationList(data);
        print('✅ Extracted meta: $meta');
        print('✅ Extracted notifications: ${notifications.length}');
        return {
          'notifications': notifications,
          'meta': meta,
        };
      }

      throw Exception(data['message'] ?? 'Failed to load notifications');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/notifications/unread-count'),
        headers: headers,
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return data['data']?['count'] ?? data['count'] ?? 0;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/notifications/$notificationId/read'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Mark all as read
  Future<bool> markAllAsRead() async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/notifications/mark-all-read'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/notifications/$notificationId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Admin: Send to all citizens
  Future<Map<String, dynamic>> sendToAllCitizens({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/send-to-citizens'),
        headers: headers,
        body: json.encode({
          'title': title,
          'body': body,
          'type': type,
          if (data != null) 'data': data,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception(responseData['message'] ?? 'Failed to send notification');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Admin: Send to specific users
  Future<Map<String, dynamic>> sendToBulk({
    required List<String> userIds,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/send-to-bulk'),
        headers: headers,
        body: json.encode({
          'user_ids': userIds,
          'title': title,
          'body': body,
          'type': type,
          if (data != null) 'data': data,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception(responseData['message'] ?? 'Failed to send notification');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Admin: Send to all admins
  Future<Map<String, dynamic>> sendToAllAdmins({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/send-to-admins'),
        headers: headers,
        body: json.encode({
          'title': title,
          'body': body,
          'type': type,
          if (data != null) 'data': data,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception(responseData['message'] ?? 'Failed to send notification');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Admin: Send to all employees
  Future<Map<String, dynamic>> sendToAllEmployees({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/send-to-employees'),
        headers: headers,
        body: json.encode({
          'title': title,
          'body': body,
          'type': type,
          if (data != null) 'data': data,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception(responseData['message'] ?? 'Failed to send notification');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Admin: Broadcast to everyone
  Future<Map<String, dynamic>> broadcast({
    required String title,
    required String body,
    String type = 'announcement',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/broadcast'),
        headers: headers,
        body: json.encode({
          'title': title,
          'body': body,
          'type': type,
          if (data != null) 'data': data,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception(responseData['message'] ?? 'Failed to broadcast notification');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Admin: Send by role
  Future<Map<String, dynamic>> sendByRole({
    required String role,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/notifications/send-by-role'),
        headers: headers,
        body: json.encode({
          'role': role,
          'title': title,
          'body': body,
          'type': type,
          if (data != null) 'data': data,
          if (imageUrl != null) 'image_url': imageUrl,
        }),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      }

      throw Exception(responseData['message'] ?? 'Failed to send notification');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
