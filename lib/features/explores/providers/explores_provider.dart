import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../models/explore_model.dart';
import '../services/explores_service.dart';

class ExploresProvider with ChangeNotifier {
  final ExploresService _service;

  List<ExploreModel> _explores = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  String? _statusFilter;
  String? _typeFilter;

  ExploresProvider(StorageService storageService)
      : _service = ExploresService(storageService);

  List<ExploreModel> get explores => _explores;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  String? get statusFilter => _statusFilter;
  String? get typeFilter => _typeFilter;

  int get pendingCount => _explores.where((e) => e.isPending).length;
  int get approvedCount => _explores.where((e) => e.isApproved).length;

  // Fetch public explores (approved only)
  Future<void> fetchPublicExplores({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getExplores(page: page);
      _explores = result['explores'] as List<ExploreModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch admin explores (all)
  Future<void> fetchAdminExplores({
    int page = 1,
    String? status,
    String? type,
  }) async {
    _isLoading = true;
    _error = null;
    _statusFilter = status;
    _typeFilter = type;
    notifyListeners();

    try {
      final result = await _service.getExplores(
        page: page,
        status: status,
        type: type,
      );
      _explores = result['explores'] as List<ExploreModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch explores by user
  Future<void> fetchUserExplores(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _explores = await _service.getExploresByUser(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Apply for explore (citizen)
  Future<bool> applyExplore({
    required String title,
    required String desc,
    required String type,
    List<File>? images,
  }) async {
    try {
      await _service.applyExplore(
        title: title,
        desc: desc,
        type: type,
        images: images,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Create explore (admin)
  Future<bool> createExplore({
    required String title,
    required String desc,
    required String category,
    required String type,
    required String citizenId,
    required String startDate,
    required String endDate,
    String? status,
    List<File>? images,
  }) async {
    try {
      final explore = await _service.createExplore(
        title: title,
        desc: desc,
        category: category,
        type: type,
        citizenId: citizenId,
        startDate: startDate,
        endDate: endDate,
        status: status,
        images: images,
      );
      _explores.insert(0, explore);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update explore (admin)
  Future<bool> updateExplore({
    required String id,
    String? title,
    String? desc,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    String? status,
    List<File>? images,
  }) async {
    try {
      final updatedExplore = await _service.updateExplore(
        id: id,
        title: title,
        desc: desc,
        category: category,
        type: type,
        startDate: startDate,
        endDate: endDate,
        status: status,
        images: images,
      );
      final index = _explores.indexWhere((e) => e.id == id);
      if (index != -1) {
        _explores[index] = updatedExplore;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Approve explore (admin)
  Future<bool> approveExplore({
    required String id,
    String? category,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final approvedExplore = await _service.approveExplore(
        id: id,
        category: category,
        startDate: startDate,
        endDate: endDate,
      );
      final index = _explores.indexWhere((e) => e.id == id);
      if (index != -1) {
        _explores[index] = approvedExplore;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete explore (admin)
  Future<bool> deleteExplore(String id) async {
    try {
      final success = await _service.deleteExplore(id);
      if (success) {
        _explores.removeWhere((e) => e.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _typeFilter = null;
    notifyListeners();
  }
}
