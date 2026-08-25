import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../models/dashboard_stats.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService;
  
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DashboardProvider(this._apiService);

  Future<void> fetchDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/admin/dashboard/stats');
      
      if (response.statusCode == 200 && response.data['code'] == 200) {
        _stats = DashboardStats.fromJson(response.data['data']);
      } else {
        _error = response.data['message'] ?? 'فشل في تحميل الإحصائيات';
      }
    } catch (e) {
      _error = 'حدث خطأ في الاتصال';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  static Future<DashboardProvider> create() async {
    final apiService = await ApiService.getInstance();
    return DashboardProvider(apiService);
  }
}
