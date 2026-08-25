import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/project_model.dart';

class ProjectsService {
  final StorageService _storageService;

  ProjectsService(this._storageService);

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

  List<ProjectModel> _mapProjects(dynamic data) {
    if (data is List) {
      return data.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  List<ProjectModel> _extractProjectList(Map<String, dynamic> data) {
    if (data['data'] is List) return _mapProjects(data['data']);
    if (data['projects'] is List) return _mapProjects(data['projects']);
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapProjects((data['data'] as Map<String, dynamic>)['data']);
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
    debugPrint('[ProjectsService] $method ${uri.toString()}');
    if (safeHeaders.isNotEmpty) debugPrint('[ProjectsService] headers=$safeHeaders');
    if (fields != null && fields.isNotEmpty) debugPrint('[ProjectsService] fields=$fields');
    if (hasFile) debugPrint('[ProjectsService] file attachments present');
  }

  Future<Map<String, dynamic>> getProjects({int page = 1, String? search}) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.projects}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      final uri = Uri.parse(url);
      _logRequest(method: 'GET', uri: uri, headers: headers);

      final response = await http.get(uri, headers: headers);
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {
          'projects': _extractProjectList(data),
          'meta': _extractMeta(data),
        };
      }

      throw Exception(data['message'] ?? 'Failed to load projects');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ProjectModel> createProject({
    required String title,
    required String description,
    String? category,
    String? location,
    String? startDate,
    String? endDate,
    String? status,
    List<File>? images,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.projects}');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _getHeaders(jsonContentType: false))
        ..fields['title'] = title
        ..fields['description'] = description;

      if (category != null && category.isNotEmpty) request.fields['category'] = category;
      if (location != null && location.isNotEmpty) request.fields['location'] = location;
      if (startDate != null && startDate.isNotEmpty) request.fields['start_date'] = startDate;
      if (endDate != null && endDate.isNotEmpty) request.fields['end_date'] = endDate;
      if (status != null && status.isNotEmpty) request.fields['status'] = status;

      if (images != null && images.isNotEmpty) {
        for (final file in images) {
          if (file.existsSync()) {
            request.files.add(await http.MultipartFile.fromPath('images[]', file.path));
          }
        }
      }

      _logRequest(
        method: 'POST',
        uri: uri,
        headers: request.headers,
        fields: request.fields,
        hasFile: images != null && images.isNotEmpty,
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      debugPrint('[ProjectsService] POST /projects status=${response.statusCode}');
      debugPrint('[ProjectsService] response body=${response.body}');
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final payload = data['data'] ?? data['project'] ?? data;
        return ProjectModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to create project');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ProjectModel> updateProject({
    required String id,
    String? title,
    String? description,
    String? category,
    String? location,
    String? startDate,
    String? endDate,
    String? status,
    List<File>? images,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.projects}/$id');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _getHeaders(jsonContentType: false))
        ..fields['_method'] = 'PUT';

      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (category != null) request.fields['category'] = category;
      if (location != null) request.fields['location'] = location;
      if (startDate != null) request.fields['start_date'] = startDate;
      if (endDate != null) request.fields['end_date'] = endDate;
      if (status != null) request.fields['status'] = status;

      if (images != null && images.isNotEmpty) {
        for (final file in images) {
          if (file.existsSync()) {
            request.files.add(await http.MultipartFile.fromPath('images[]', file.path));
          }
        }
      }

      _logRequest(
        method: 'PUT',
        uri: uri,
        headers: request.headers,
        fields: request.fields,
        hasFile: images != null && images.isNotEmpty,
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      debugPrint('[ProjectsService] PUT /projects/$id status=${response.statusCode}');
      debugPrint('[ProjectsService] response body=${response.body}');
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final payload = data['data'] ?? data['project'] ?? data;
        return ProjectModel.fromJson(payload as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to update project');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse('$_baseUrl${ApiConstants.projects}/$id'), headers: headers);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(data['message'] ?? 'Failed to delete project');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
