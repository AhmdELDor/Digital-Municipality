import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/request_form_model.dart';

class RequestFormsService {
  final StorageService _storageService;

  RequestFormsService(this._storageService);

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>?> getRequestForms({
    int page = 1,
    String? search,
  }) async {
    try {
      final headers = await _getHeaders();
      var url = '${ApiConstants.baseUrl}${ApiConstants.requestForms}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      if (kDebugMode) {
        print('GET Request Forms: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting request forms: $e');
      }
      return null;
    }
  }

  Future<RequestFormModel?> getRequestForm(String id) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.requestForms}/$id';

      if (kDebugMode) {
        print('GET Request Form: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return RequestFormModel.fromJson(jsonResponse['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting request form: $e');
      }
      return null;
    }
  }

  Future<bool> createRequestForm(Map<String, dynamic> formData) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.requestForms}';

      if (kDebugMode) {
        print('POST Request Form: $url');
        print('Form data: $formData');
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(formData),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating request form: $e');
      }
      return false;
    }
  }

  Future<bool> updateRequestForm(String id, Map<String, dynamic> formData) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.requestForms}/$id';

      if (kDebugMode) {
        print('PUT Request Form: $url');
        print('Form data: $formData');
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(formData),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating request form: $e');
      }
      return false;
    }
  }

  Future<bool> deleteRequestForm(String id) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.requestForms}/$id';

      if (kDebugMode) {
        print('DELETE Request Form: $url');
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting request form: $e');
      }
      return false;
    }
  }
}
