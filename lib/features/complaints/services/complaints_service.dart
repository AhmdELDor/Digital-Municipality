import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/complaint_model.dart';

class ComplaintsService {
  final StorageService _storageService;
  final String _baseUrl = ApiConstants.baseUrl;

  ComplaintsService(this._storageService);

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  List<ComplaintModel> _mapComplaints(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Map<String, dynamic>? _extractMeta(Map<String, dynamic> data) {
    if (data['pagination'] != null) {
      return data['pagination'] as Map<String, dynamic>;
    }
    if (data['meta'] != null) {
      return data['meta'] as Map<String, dynamic>;
    }
    return null;
  }

  List<ComplaintModel> _extractComplaintList(Map<String, dynamic> data) {
    if (data['data'] is List) return _mapComplaints(data['data']);
    if (data['complaints'] is List) return _mapComplaints(data['complaints']);
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapComplaints((data['data'] as Map<String, dynamic>)['data']);
    }
    return [];
  }

  void _logRequest({
    required String method,
    required Uri uri,
    Map<String, dynamic>? headers,
  }) {
    final safeHeaders = headers == null ? <String, dynamic>{} : Map<String, dynamic>.from(headers);
    if (safeHeaders.containsKey('Authorization')) {
      safeHeaders['Authorization'] = 'Bearer ***';
    }
    debugPrint('[ComplaintsService] $method ${uri.toString()}');
    if (safeHeaders.isNotEmpty) debugPrint('[ComplaintsService] headers=$safeHeaders');
  }

  Future<Map<String, dynamic>> getComplaints({int page = 1, String? search}) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.complaints}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      final uri = Uri.parse(url);
      _logRequest(method: 'GET', uri: uri, headers: headers);

      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {
          'complaints': _extractComplaintList(data),
          'meta': _extractMeta(data),
        };
      }

      throw Exception(data['message'] ?? 'Failed to load complaints');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ComplaintModel> getComplaint(String id) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$_baseUrl${ApiConstants.complaints}/$id');
      _logRequest(method: 'GET', uri: uri, headers: headers);

      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final payload = data['data'] ?? data['complaint'] ?? data;
        return ComplaintModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to load complaint');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ComplaintModel> updateComplaintResult({
    required String id,
    required String result,
  }) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$_baseUrl${ApiConstants.complaints}/$id');
      
      final body = json.encode({'result': result});
      
      _logRequest(method: 'PUT', uri: uri, headers: headers);
      debugPrint('[ComplaintsService] body=$body');

      final response = await http.put(uri, headers: headers, body: body);
      debugPrint('[ComplaintsService] PUT /complaints/$id status=${response.statusCode}');
      debugPrint('[ComplaintsService] response body=${response.body}');
      
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final payload = data['data'] ?? data['complaint'] ?? data;
        return ComplaintModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to update complaint');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteComplaint(String id) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$_baseUrl${ApiConstants.complaints}/$id');
      _logRequest(method: 'DELETE', uri: uri, headers: headers);

      final response = await http.delete(uri, headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? 'Failed to delete complaint');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
