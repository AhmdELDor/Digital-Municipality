import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/request_form_model.dart';
import '../services/user_requests_service.dart';

class UserRequestsProvider with ChangeNotifier {
  final UserRequestsService _service;

  UserRequestsProvider(this._service);

  factory UserRequestsProvider.create(UserRequestsService service) {
    return UserRequestsProvider(service);
  }

  List<UserRequestModel> _userRequests = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  String _searchQuery = '';
  String? _statusFilter;

  List<UserRequestModel> get userRequests => _userRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  String get searchQuery => _searchQuery;
  String? get statusFilter => _statusFilter;

  Future<void> fetchUserRequests({int page = 1}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _service.getUserRequests(
        page: page,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        status: _statusFilter,
      );

      if (response != null) {
        final data = response['data'] as List;
        _userRequests = data.map((json) => UserRequestModel.fromJson(json)).toList();
        _meta = response['meta'];
      } else {
        _error = 'فشل في تحميل الطلبات';
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in fetchUserRequests: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUserRequests(String query) async {
    _searchQuery = query;
    await fetchUserRequests(page: 1);
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    await fetchUserRequests(page: 1);
  }

  Future<bool> updateRequestStatus({
    required String id,
    required String status,
    String? adminNote,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _service.updateRequestStatus(
        id: id,
        status: status,
        adminNote: adminNote,
      );

      if (success) {
        await fetchUserRequests(page: _meta?['current_page'] ?? 1);
        return true;
      } else {
        _error = 'فشل في تحديث حالة الطلب';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in updateRequestStatus: $e');
      }
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserRequestModel?> submitRequest({
    required String requestFormId,
    required Map<String, dynamic> data,
    Map<String, List<File>>? attachments,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _service.submitRequest(
        requestFormId: requestFormId,
        data: data,
        attachments: attachments,
      );

      if (result != null) {
        await fetchUserRequests(page: 1);
        return result;
      } else {
        _error = 'فشل في إرسال الطلب';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in submitRequest: $e');
      }
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
