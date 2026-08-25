import 'package:flutter/foundation.dart';
import '../models/request_form_model.dart';
import '../services/request_forms_service.dart';

class RequestFormsProvider with ChangeNotifier {
  final RequestFormsService _service;

  RequestFormsProvider(this._service);

  factory RequestFormsProvider.create(RequestFormsService service) {
    return RequestFormsProvider(service);
  }

  List<RequestFormModel> _requestForms = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  String _searchQuery = '';

  List<RequestFormModel> get requestForms => _requestForms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  String get searchQuery => _searchQuery;

  Future<void> fetchRequestForms({int page = 1}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _service.getRequestForms(
        page: page,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (response != null) {
        final data = response['data'] as List;
        _requestForms = data.map((json) => RequestFormModel.fromJson(json)).toList();
        _meta = response['meta'];
      } else {
        _error = 'فشل في تحميل النماذج';
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in fetchRequestForms: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRequestForms(String query) async {
    _searchQuery = query;
    await fetchRequestForms(page: 1);
  }

  Future<bool> createRequestForm(Map<String, dynamic> formData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _service.createRequestForm(formData);

      if (success) {
        await fetchRequestForms(page: 1);
        return true;
      } else {
        _error = 'فشل في إنشاء النموذج';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in createRequestForm: $e');
      }
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRequestForm(String id, Map<String, dynamic> formData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _service.updateRequestForm(id, formData);

      if (success) {
        await fetchRequestForms(page: _meta?['current_page'] ?? 1);
        return true;
      } else {
        _error = 'فشل في تحديث النموذج';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in updateRequestForm: $e');
      }
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRequestForm(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _service.deleteRequestForm(id);

      if (success) {
        await fetchRequestForms(page: _meta?['current_page'] ?? 1);
        return true;
      } else {
        _error = 'فشل في حذف النموذج';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('Error in deleteRequestForm: $e');
      }
      notifyListeners();
      return false;
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
