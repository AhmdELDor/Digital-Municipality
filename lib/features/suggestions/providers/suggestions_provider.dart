import 'package:flutter/material.dart';
import '../models/suggestion_model.dart';
import '../services/suggestions_service.dart';

class SuggestionsProvider with ChangeNotifier {
  final SuggestionsService _service;

  SuggestionsProvider(this._service);

  factory SuggestionsProvider.create(SuggestionsService service) {
    return SuggestionsProvider(service);
  }

  List<SuggestionModel> _suggestions = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _meta;
  String _searchQuery = '';

  List<SuggestionModel> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get meta => _meta;

  Future<void> fetchSuggestions({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getSuggestions(page: page, search: _searchQuery);
      _suggestions = result['suggestions'];
      _meta = result['meta'];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchSuggestions(String query) async {
    _searchQuery = query;
    await fetchSuggestions(page: 1);
  }

  Future<bool> createSuggestion(String desc) async {
    try {
      final success = await _service.createSuggestion(desc: desc);
      if (success) {
        await fetchSuggestions();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSuggestion(String id, String desc) async {
    try {
      final success = await _service.updateSuggestion(id: id, desc: desc);
      if (success) {
        await fetchSuggestions();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSuggestion(String id) async {
    try {
      final success = await _service.deleteSuggestion(id);
      if (success) {
        await fetchSuggestions();
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
}
