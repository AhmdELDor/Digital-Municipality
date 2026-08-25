import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/request_form_model.dart';

class UserRequestsService {
  final StorageService _storageService;

  UserRequestsService(this._storageService);

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> _getMultipartHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>?> getUserRequests({
    int page = 1,
    String? search,
    String? status,
  }) async {
    try {
      final headers = await _getHeaders();
      var url = '${ApiConstants.baseUrl}${ApiConstants.userRequests}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }

      if (kDebugMode) {
        print('GET User Requests: $url');
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
        print('Error getting user requests: $e');
      }
      return null;
    }
  }

  Future<UserRequestModel?> getUserRequest(String id) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.userRequests}/$id';

      if (kDebugMode) {
        print('GET User Request: $url');
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
        return UserRequestModel.fromJson(jsonResponse['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user request: $e');
      }
      return null;
    }
  }

  Future<bool> updateRequestStatus({
    required String id,
    required String status,
    String? adminNote,
  }) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.userRequests}/$id';

      final data = {
        'status': status,
        if (adminNote != null && adminNote.isNotEmpty) 'admin_note': adminNote,
      };

      if (kDebugMode) {
        print('PUT User Request Status: $url');
        print('Data: $data');
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating request status: $e');
      }
      return false;
    }
  }

  Future<UserRequestModel?> submitRequest({
    required String requestFormId,
    required Map<String, dynamic> data,
    Map<String, List<File>>? attachments, // Changed from List to Map
  }) async {
    try {
      final token = _storageService.getAuthToken();
      final url = '${ApiConstants.baseUrl}${ApiConstants.userRequests}';

      if (kDebugMode) {
        print('POST Submit Request: $url');
        print('Request Form ID: $requestFormId');
        print('Data: $data');
        print('Attachments fields: ${attachments?.keys.toList() ?? []}');
      }

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Add request form ID
      request.fields['request_form_id'] = requestFormId;

      // Add form data as JSON string
      request.fields['data'] = json.encode(data);

      // Add file attachments organized by field name
      if (attachments != null && attachments.isNotEmpty) {
        for (var entry in attachments.entries) {
          final fieldName = entry.key;
          final files = entry.value;
          
          if (files.length == 1) {
            // Single file - send without array notation
            var file = files.first;
            var stream = http.ByteStream(file.openRead());
            var length = await file.length();
            var multipartFile = http.MultipartFile(
              fieldName,
              stream,
              length,
              filename: file.path.split(Platform.pathSeparator).last,
            );
            request.files.add(multipartFile);
          } else {
            // Multiple files - send with array notation
            for (var file in files) {
              var stream = http.ByteStream(file.openRead());
              var length = await file.length();
              var multipartFile = http.MultipartFile(
                '$fieldName[]',
                stream,
                length,
                filename: file.path.split(Platform.pathSeparator).last,
              );
              request.files.add(multipartFile);
            }
          }
        }
      }

      if (kDebugMode) {
        print('Sending multipart request...');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return UserRequestModel.fromJson(jsonResponse['data']);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting request: $e');
      }
      return null;
    }
  }
}
