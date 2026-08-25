import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/circular_model.dart';

class CircularsService {
  final StorageService _storageService;

  CircularsService(this._storageService);

  String get _baseUrl => ApiConstants.baseUrl;

  Future<Map<String, String>> _getHeaders({bool jsonContentType = true}) async {
    final token = _storageService.getAuthToken();
    return {
      if (jsonContentType) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _extractMeta(Map<String, dynamic> data) {
    if (data['meta'] is Map<String, dynamic>) return data['meta'] as Map<String, dynamic>;
    if (data['pagination'] is Map<String, dynamic>) return data['pagination'] as Map<String, dynamic>;
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['meta'] != null) {
      final nestedMeta = (data['data'] as Map<String, dynamic>)['meta'];
      if (nestedMeta is Map<String, dynamic>) return nestedMeta;
    }
    return {};
  }

  List<CircularModel> _mapCirculars(dynamic data) {
    if (data is List) {
      return data.map((e) => CircularModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  void _logRequest({
    required String method,
    required Uri uri,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? fields,
    bool hasFile = false,
  }) {
    final safeHeaders = headers == null ? <String, dynamic>{} : Map<String, dynamic>.from(headers);
    if (safeHeaders.containsKey('Authorization')) {
      safeHeaders['Authorization'] = 'Bearer ***';
    }

    debugPrint('[CircularsService] $method ${uri.toString()}');
    if (safeHeaders.isNotEmpty) {
      debugPrint('[CircularsService] headers=$safeHeaders');
    }
    if (fields != null && fields.isNotEmpty) {
      debugPrint('[CircularsService] fields=$fields');
    }
    if (hasFile) {
      debugPrint('[CircularsService] file attachments present');
    }
  }

  List<CircularModel> _extractCircularList(Map<String, dynamic> data) {
    if (data['data'] is List) return _mapCirculars(data['data']);
    if (data['circulars'] is List) return _mapCirculars(data['circulars']);
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapCirculars((data['data'] as Map<String, dynamic>)['data']);
    }
    return [];
  }

  Future<Map<String, dynamic>> getCirculars({int page = 1, String? search}) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.circulars}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      final uri = Uri.parse(url);
      _logRequest(method: 'GET', uri: uri, headers: headers);

      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {
          'circulars': _extractCircularList(data),
          'meta': _extractMeta(data),
        };
      }

      throw Exception(data['message'] ?? 'Failed to load circulars');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<CircularModel> createCircular({
    required String title,
    required String content,
    File? image,
    bool isPublished = false,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.circulars}');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _getHeaders(jsonContentType: false))
        ..fields['title'] = title
        ..fields['content'] = content
        ..fields['is_published'] = isPublished ? '1' : '0';

      _logRequest(
        method: 'POST',
        uri: uri,
        headers: request.headers,
        fields: request.fields,
        hasFile: image != null && image.existsSync(),
      );

      if (image != null && image.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      debugPrint('[CircularsService] POST /circulars status=${response.statusCode}');
      debugPrint('[CircularsService] response body=${response.body}');
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final payload = data['data'] ?? data['circular'] ?? data;
        return CircularModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to create circular');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<CircularModel> updateCircular({
    required String id,
    String? title,
    String? content,
    File? image,
    bool? isPublished,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.circulars}/$id');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _getHeaders(jsonContentType: false))
        ..fields['_method'] = 'PUT';

      if (title != null) request.fields['title'] = title;
      if (content != null) request.fields['content'] = content;
      if (isPublished != null) request.fields['is_published'] = isPublished ? '1' : '0';

      _logRequest(
        method: 'PUT',
        uri: uri,
        headers: request.headers,
        fields: request.fields,
        hasFile: image != null && image.existsSync(),
      );

      if (image != null && image.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final payload = data['data'] ?? data['circular'] ?? data;
        return CircularModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to update circular');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteCircular(String id) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$_baseUrl${ApiConstants.circulars}/$id');
      _logRequest(method: 'DELETE', uri: uri, headers: headers);

      final response = await http.delete(uri, headers: headers);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(data['message'] ?? 'Failed to delete circular');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<CircularModel> togglePublish(String id, bool isPublished) async {
    return updateCircular(id: id, isPublished: isPublished);
  }
}
