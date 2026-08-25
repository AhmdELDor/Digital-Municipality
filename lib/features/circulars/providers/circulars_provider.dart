import 'dart:io';
import 'package:flutter/material.dart';
import '../models/circular_model.dart';
import '../services/circulars_service.dart';

class CircularsProvider with ChangeNotifier {
  final CircularsService _circularsService;

  CircularsProvider(this._circularsService);

  List<CircularModel> _circulars = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  int _currentPage = 1;
  String _searchQuery = '';

  List<CircularModel> get circulars => _circulars;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;
  int get currentPage => _currentPage;
  String get searchQuery => _searchQuery;

  Future<void> fetchCirculars({int page = 1, String? search}) async {
    _isLoading = true;
    _error = null;
    _currentPage = page;
    if (search != null) {
      _searchQuery = search;
    }
    notifyListeners();

    try {
      final result = await _circularsService.getCirculars(
        page: page,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _circulars = result['circulars'] as List<CircularModel>;
      _meta = result['meta'] as Map<String, dynamic>?;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCircular({
    required String title,
    required String content,
    File? image,
    bool isPublished = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final circular = await _circularsService.createCircular(
        title: title,
        content: content,
        image: image,
        isPublished: isPublished,
      );
      _circulars.insert(0, circular);
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

  Future<bool> updateCircular({
    required String id,
    String? title,
    String? content,
    File? image,
    bool? isPublished,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _circularsService.updateCircular(
        id: id,
        title: title,
        content: content,
        image: image,
        isPublished: isPublished,
      );
      final index = _circulars.indexWhere((c) => c.id == id);
      if (index != -1) {
        _circulars[index] = updated;
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

  Future<bool> deleteCircular(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _circularsService.deleteCircular(id);
      _circulars.removeWhere((c) => c.id == id);
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

  Future<bool> togglePublish(String id) async {
    final index = _circulars.indexWhere((c) => c.id == id);
    if (index == -1) return false;

    final circular = _circulars[index];
    final newStatus = !circular.isPublished;

    try {
      final updated = await _circularsService.togglePublish(id, newStatus);
      _circulars[index] = updated;
      notifyListeners();
      return true;
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

  static Future<CircularsProvider> create(CircularsService circularsService) async {
    return CircularsProvider(circularsService);
  }
}
