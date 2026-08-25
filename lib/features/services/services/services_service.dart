import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/services/storage_service.dart';
import '../../../core/constants/api_constants.dart';
import '../models/service_model.dart';

class ServicesService {
  final StorageService _storageService;

  ServicesService(this._storageService);

  String get _baseUrl => ApiConstants.baseUrl;

  Future<Map<String, String>> _getHeaders({bool jsonContentType = true}) async {
    final token = _storageService.getAuthToken();
    return {
      if (jsonContentType) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  List<ServiceModel> _mapServices(dynamic data) {
    if (data is List) {
      return data.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
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

  List<ServiceModel> _extractList(Map<String, dynamic> data) {
    if (data['data'] is List) {
      return _mapServices(data['data']);
    }
    if (data['services'] is List) {
      return _mapServices(data['services']);
    }
    if (data['data'] is Map<String, dynamic> && (data['data'] as Map<String, dynamic>)['data'] is List) {
      return _mapServices((data['data'] as Map<String, dynamic>)['data']);
    }
    return [];
  }

  Future<Map<String, dynamic>> getServices({int page = 1, String? search}) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.services}?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return {
          'services': _extractList(data),
          'meta': _extractMeta(data),
        };
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(error['message'] ?? 'Failed to load services');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ServiceModel> getService(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$_baseUrl${ApiConstants.getService}/$id'), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final payload = data['data'] ?? data['service'] ?? data;
        return ServiceModel.fromJson(payload as Map<String, dynamic>);
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(error['message'] ?? 'Failed to load service');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ServiceModel> createService({
    required String name,
    required String phoneNumber,
    bool priority = false,
    String? logoPath,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.createService}');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(await _getHeaders(jsonContentType: false));

      request.fields['name'] = name;
      request.fields['phone_number'] = phoneNumber;
      request.fields['priority'] = priority ? '1' : '0';

      if (logoPath != null && logoPath.isNotEmpty && File(logoPath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('logo', logoPath));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final payload = data['data'] ?? data['service'] ?? data;
        return ServiceModel.fromJson(payload as Map<String, dynamic>);
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(error['message'] ?? 'Failed to create service');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ServiceModel> updateService({
    required String id,
    String? name,
    String? phoneNumber,
    bool? priority,
    String? logoPath,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl${ApiConstants.updateService}/$id');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _getHeaders(jsonContentType: false))
        ..fields['_method'] = 'PUT';

      if (name != null) request.fields['name'] = name;
      if (phoneNumber != null) request.fields['phone_number'] = phoneNumber;
      if (priority != null) request.fields['priority'] = priority ? '1' : '0';

      if (logoPath != null && logoPath.isNotEmpty && File(logoPath).existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('logo', logoPath));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final payload = data['data'] ?? data['service'] ?? data;
        return ServiceModel.fromJson(payload as Map<String, dynamic>);
      } else {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(error['message'] ?? 'Failed to update service');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(Uri.parse('$_baseUrl${ApiConstants.deleteService}/$id'), headers: headers);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = json.decode(response.body) as Map<String, dynamic>;
        throw Exception(error['message'] ?? 'Failed to delete service');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
