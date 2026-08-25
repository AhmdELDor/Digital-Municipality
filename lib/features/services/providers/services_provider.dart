import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/services_service.dart';

class ServicesProvider with ChangeNotifier {
  final ServicesService _servicesService;

  ServicesProvider(this._servicesService);

  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  int _currentPage = 1;
  String _searchQuery = '';

  List<ServiceModel> get services => _services;
  ServiceModel? get selectedService => _selectedService;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  Future<void> fetchServices({int page = 1, String? search}) async {
    _isLoading = true;
    _error = null;
    _currentPage = page;
    if (search != null) {
      _searchQuery = search;
    }
    notifyListeners();

    try {
      final result = await _servicesService.getServices(
        page: page,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _services = result['services'] as List<ServiceModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchServices(String query) async {
    _searchQuery = query;
    await fetchServices(page: 1, search: query);
  }

  Future<void> fetchService(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedService = await _servicesService.getService(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createService({
    required String name,
    required String phoneNumber,
    bool priority = false,
    String? logoPath,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newService = await _servicesService.createService(
        name: name,
        phoneNumber: phoneNumber,
        priority: priority,
        logoPath: logoPath,
      );
      _services.insert(0, newService);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateService({
    required String id,
    String? name,
    String? phoneNumber,
    bool? priority,
    String? logoPath,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _servicesService.updateService(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
        priority: priority,
        logoPath: logoPath,
      );

      final index = _services.indexWhere((s) => s.id == id);
      if (index != -1) {
        _services[index] = updated;
      }
      if (_selectedService?.id == id) {
        _selectedService = updated;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteService(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _servicesService.deleteService(id);
      _services.removeWhere((s) => s.id == id);
      if (_selectedService?.id == id) {
        _selectedService = null;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedService() {
    _selectedService = null;
    notifyListeners();
  }

  static Future<ServicesProvider> create(ServicesService servicesService) async {
    return ServicesProvider(servicesService);
  }
}
