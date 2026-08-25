import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/poll_model.dart';

class PollsService {
  final StorageService _storageService;
  final String _baseUrl = ApiConstants.baseUrl;

  PollsService(this._storageService);

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  List<PollModel> _mapPolls(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => PollModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Map<String, dynamic>? _extractMeta(Map<String, dynamic> data) {
    if (data.containsKey('meta')) {
      return data['meta'] as Map<String, dynamic>;
    }
    if (data.containsKey('pagination')) {
      return data['pagination'] as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>> getPolls({int page = 1, String search = ''}) async {
    try {
      var url = '$_baseUrl${ApiConstants.polls}?page=$page';
      if (search.isNotEmpty) {
        url += '&search=$search';
      }

      if (kDebugMode) {
        print('[PollsService] GET $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print('[PollsService] GET /polls status=${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (kDebugMode) {
          print('📊 [PollsService] Response keys: ${data.keys.toList()}');
          print('📊 [PollsService] Data length: ${data['data']?.length ?? 0}');
          print('📊 [PollsService] Pagination: ${data['pagination']}');
          print('📊 [PollsService] Raw response body: ${response.body}');
        }
        
        final polls = _mapPolls(data['data']);
        final meta = _extractMeta(data);
        
        if (kDebugMode) {
          print('✅ [PollsService] Parsed ${polls.length} polls');
          print('✅ [PollsService] Meta: $meta');
        }
        
        return {
          'polls': polls,
          'meta': meta,
        };
      } else {
        throw Exception('Failed to load polls: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[PollsService] Error fetching polls: $e');
      }
      rethrow;
    }
  }

  Future<PollModel?> getPoll(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.polls}/$id');
      
      if (kDebugMode) {
        print('[PollsService] GET ${uri.toString()}');
      }

      final response = await http.get(uri, headers: await _getHeaders());

      if (kDebugMode) {
        print('[PollsService] GET /polls/$id status=${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PollModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('[PollsService] Error fetching poll: $e');
      }
      return null;
    }
  }

  Future<bool> createPoll({
    required String title,
    String? description,
    required List<String> options,
    DateTime? startAt,
    DateTime? endAt,
    required String status,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.polls}');
      
      final body = {
        'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        'options': options,
        if (startAt != null) 'start_at': startAt.toIso8601String(),
        if (endAt != null) 'end_at': endAt.toIso8601String(),
        'status': status,
      };

      if (kDebugMode) {
        print('[PollsService] POST ${uri.toString()}');
        print('[PollsService] body=$body');
      }

      final response = await http.post(
        uri,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('[PollsService] POST /polls status=${response.statusCode}');
        print('[PollsService] response=${response.body}');
      }

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[PollsService] Error creating poll: $e');
      }
      return false;
    }
  }

  Future<bool> updatePoll({
    required String id,
    String? title,
    String? description,
    List<String>? options,
    DateTime? startAt,
    DateTime? endAt,
    String? status,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.polls}/$id');
      
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (options != null) body['options'] = options;
      if (startAt != null) body['start_at'] = startAt.toIso8601String();
      if (endAt != null) body['end_at'] = endAt.toIso8601String();
      if (status != null) body['status'] = status;

      if (kDebugMode) {
        print('[PollsService] PUT ${uri.toString()}');
        print('[PollsService] body=$body');
      }

      final response = await http.put(
        uri,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('[PollsService] PUT /polls/$id status=${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[PollsService] Error updating poll: $e');
      }
      return false;
    }
  }

  Future<bool> deletePoll(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.polls}/$id');
      
      if (kDebugMode) {
        print('[PollsService] DELETE ${uri.toString()}');
      }

      final response = await http.delete(uri, headers: await _getHeaders());

      if (kDebugMode) {
        print('[PollsService] DELETE /polls/$id status=${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[PollsService] Error deleting poll: $e');
      }
      return false;
    }
  }

  Future<bool> votePoll(String id, String option) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.polls}/$id/vote');
      
      final body = {'option': option};

      if (kDebugMode) {
        print('[PollsService] POST ${uri.toString()}');
        print('[PollsService] body=$body');
      }

      final response = await http.post(
        uri,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      if (kDebugMode) {
        print('[PollsService] POST /polls/$id/vote status=${response.statusCode}');
        print('[PollsService] response=${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[PollsService] Error voting on poll: $e');
      }
      return false;
    }
  }
}
