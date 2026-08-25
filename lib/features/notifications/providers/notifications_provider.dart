import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../models/notification_model.dart';
import '../services/notifications_service.dart';

class NotificationsProvider with ChangeNotifier {
  final NotificationsService _service;
  
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;
  String? _selectedType;
  bool? _selectedReadStatus;
  int _unreadCount = 0;
  Map<String, dynamic>? _metadata;

  NotificationsProvider(StorageService storageService)
      : _service = NotificationsService(storageService);

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMore => _hasMore;
  String? get selectedType => _selectedType;
  bool? get selectedReadStatus => _selectedReadStatus;
  int get unreadCount => _unreadCount;
  Map<String, dynamic>? get metadata => _metadata;

  Future<void> fetchNotifications({bool refresh = false, int? page}) async {
    print('\n🔄 fetchNotifications called:');
    print('  refresh: $refresh');
    print('  page: $page');
    print('  _currentPage before: $_currentPage');
    print('  _hasMore before: $_hasMore');
    print('  _isLoading before: $_isLoading');

    if (refresh) {
      _currentPage = 1;
      _notifications = [];
      _hasMore = true;
      print('  ♻️  Refreshing - reset to page 1');
    }

    if (page != null) {
      _currentPage = page;
      print('  📄 Setting page to: $page');
    }

    if (_isLoading) {
      print('  ⏸️  Already loading, returning early');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('  🌐 Fetching page: $_currentPage');
      final result = await _service.getNotifications(
        page: _currentPage,
        type: _selectedType,
        isRead: _selectedReadStatus,
      );

      final newNotifications = result['notifications'] as List<NotificationModel>;
      final meta = result['meta'] as Map<String, dynamic>;

      print('  📦 Result received:');
      print('    Notifications: ${newNotifications.length}');
      print('    Meta: $meta');

      _metadata = meta;

      // Always replace notifications when navigating to a specific page
      // Only append if it's infinite scroll (loadMore)
      if (refresh || page != null) {
        _notifications = newNotifications;
        print('  🔄 Replacing notifications list');
      } else {
        _notifications.addAll(newNotifications);
        print('  ➕ Appending to notifications list');
      }

      _currentPage = meta['current_page'] ?? _currentPage;
      _totalPages = meta['last_page'] ?? 1;
      _hasMore = _currentPage < _totalPages;

      print('  ✅ State updated:');
      print('    _currentPage: $_currentPage');
      print('    _totalPages: $_totalPages');
      print('    _hasMore: $_hasMore');
      print('    Total notifications: ${_notifications.length}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('  ❌ Error: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;
    _currentPage++;
    await fetchNotifications();
  }

  Future<void> filterByType(String? type) async {
    _selectedType = type;
    await fetchNotifications(refresh: true);
  }

  Future<void> filterByReadStatus(bool? isRead) async {
    _selectedReadStatus = isRead;
    await fetchNotifications(refresh: true);
  }

  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await _service.getUnreadCount();
      notifyListeners();
    } catch (e) {
      // Silently fail for unread count
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final success = await _service.markAsRead(notificationId);
      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
          if (_unreadCount > 0) _unreadCount--;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final success = await _service.markAllAsRead();
      if (success) {
        _notifications = _notifications.map((n) {
          return n.copyWith(isRead: true, readAt: DateTime.now());
        }).toList();
        _unreadCount = 0;
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      final success = await _service.deleteNotification(notificationId);
      if (success) {
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  // Admin methods
  Future<Map<String, dynamic>?> sendToAllCitizens({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final result = await _service.sendToAllCitizens(
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendToBulk({
    required List<String> userIds,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final result = await _service.sendToBulk(
        userIds: userIds,
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendToAllAdmins({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final result = await _service.sendToAllAdmins(
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendToAllEmployees({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final result = await _service.sendToAllEmployees(
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> broadcast({
    required String title,
    required String body,
    String type = 'announcement',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final result = await _service.broadcast(
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendByRole({
    required String role,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      final result = await _service.sendByRole(
        role: role,
        title: title,
        body: body,
        type: type,
        data: data,
        imageUrl: imageUrl,
      );
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
