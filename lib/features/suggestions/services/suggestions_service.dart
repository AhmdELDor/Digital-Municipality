import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/suggestion_model.dart';

class SuggestionsService {
  final StorageService _storageService;
  final String _baseUrl = ApiConstants.baseUrl;

  SuggestionsService(this._storageService);

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  List<SuggestionModel> _mapSuggestions(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => SuggestionModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Map<String, dynamic>? _extractMeta(Map<String, dynamic> data) {
    if (data.containsKey('pagination')) {
      return data['pagination'] as Map<String, dynamic>;
    }
    if (data.containsKey('meta')) {
      return data['meta'] as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>> getSuggestions({int page = 1, String search = ''}) async {
    try {
      var url = '$_baseUrl${ApiConstants.suggestions}?page=$page';
      if (search.isNotEmpty) {
        url += '&search=$search';
      }

      if (kDebugMode) {
        print('[SuggestionsService] GET $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print('[SuggestionsService] GET /suggestions status=${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'suggestions': _mapSuggestions(data['data']),
          'meta': _extractMeta(data),
        };
      } else {
        throw Exception('Failed to load suggestions: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[SuggestionsService] Error fetching suggestions: $e');
      }
      rethrow;
    }
  }

  Future<SuggestionModel?> getSuggestion(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.suggestions}/$id');
      
      if (kDebugMode) {
        print('[SuggestionsService] GET ${uri.toString()}');
      }

      final response = await http.get(uri, headers: await _getHeaders());

      if (kDebugMode) {
        print('[SuggestionsService] GET /suggestions/$id status=${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SuggestionModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('[SuggestionsService] Error fetching suggestion: $e');
      }
      return null;
    }
  }

  Future<bool> createSuggestion({required String desc}) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.suggestions}');
      
      final body = {
        'desc': desc,
      };

      if (kDebugMode) {
        print('[SuggestionsService] POST ${uri.toString()}');
        print('[SuggestionsService] body=$body');
      }

      final response = await http.post(
        uri,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('[SuggestionsService] POST /suggestions status=${response.statusCode}');
        print('[SuggestionsService] response=${response.body}');
      }

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[SuggestionsService] Error creating suggestion: $e');
      }
      return false;
    }
  }

  Future<bool> updateSuggestion({
    required String id,
    required String desc,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.suggestions}/$id');
      
      final body = {'desc': desc};

      if (kDebugMode) {
        print('[SuggestionsService] PUT ${uri.toString()}');
        print('[SuggestionsService] body=$body');
      }

      final response = await http.put(
        uri,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('[SuggestionsService] PUT /suggestions/$id status=${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[SuggestionsService] Error updating suggestion: $e');
      }
      return false;
    }
  }

  Future<bool> deleteSuggestion(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.suggestions}/$id');
      
      if (kDebugMode) {
        print('[SuggestionsService] DELETE ${uri.toString()}');
      }

      final response = await http.delete(uri, headers: await _getHeaders());

      if (kDebugMode) {
        print('[SuggestionsService] DELETE /suggestions/$id status=${response.statusCode}');
      }

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      if (kDebugMode) {
        print('[SuggestionsService] Error deleting suggestion: $e');
      }
      return false;
    }
  }
}

