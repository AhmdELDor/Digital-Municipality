import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/storage_service.dart';
import '../models/explore_model.dart';

class ExploresService {
  final StorageService _storageService;

  ExploresService(this._storageService);

  String get _baseUrl => ApiConstants.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get all explores with pagination and filtering
  Future<Map<String, dynamic>> getExplores({
    int page = 1,
    String? status,
    String? type,
  }) async {
    try {
      final headers = await _getHeaders();
      var url = '$_baseUrl${ApiConstants.explores}?page=$page';
      if (status != null && status.isNotEmpty) url += '&status=$status';
      if (type != null && type.isNotEmpty) url += '&type=$type';

      print('Request: GET $url');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final List<ExploreModel> explores = [];
        if (data['data'] is List) {
          explores.addAll((data['data'] as List)
              .map((e) => ExploreModel.fromJson(e as Map<String, dynamic>))
              .toList());
        }

        final meta = data['meta'] as Map<String, dynamic>?;

        return {
          'explores': explores,
          'meta': meta ?? {},
        };
      }

      throw Exception(data['message'] ?? 'Failed to load explores');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get explores by user ID
  Future<List<ExploreModel>> getExploresByUser(String userId) async {
    try {
      final headers = await _getHeaders();
      final url = '$_baseUrl${ApiConstants.explores}/by-user/$userId';
      print('Request: GET $url');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final List<ExploreModel> explores = [];
        if (data['data'] is List) {
          explores.addAll((data['data'] as List)
              .map((e) => ExploreModel.fromJson(e as Map<String, dynamic>))
              .toList());
        }
        return explores;
      }

      throw Exception(data['message'] ?? 'Failed to load user explores');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get single explore
  Future<ExploreModel> getExplore(String id) async {
    try {
      final headers = await _getHeaders();
      final url = '$_baseUrl${ApiConstants.explores}/$id';
      print('Request: GET $url');
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ExploreModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to load explore');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Apply for explore
  Future<ExploreModel> applyExplore({
    required String title,
    required String desc,
    required String type,
    List<File>? images,
  }) async {
    try {
      final token = _storageService.getAuthToken();
      final url = '$_baseUrl${ApiConstants.explores}/apply';
      print('Request: POST $url');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['desc'] = desc;
      request.fields['type'] = type;
      print('Request fields: ${request.fields}');

      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            'images[$i]',
            stream,
            length,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');
      final data = json.decode(responseBody) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ExploreModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to apply explore');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create explore
  Future<ExploreModel> createExplore({
    required String title,
    required String desc,
    required String category,
    required String type,
    required String citizenId,
    required String startDate,
    required String endDate,
    String? status,
    List<File>? images,
  }) async {
    try {
      final token = _storageService.getAuthToken();
      final url = '$_baseUrl${ApiConstants.explores}';
      print('Request: POST $url');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['desc'] = desc;
      request.fields['category'] = category;
      request.fields['type'] = type;
      request.fields['citizen_id'] = citizenId;
      request.fields['start_date'] = startDate;
      request.fields['end_date'] = endDate;
      if (status != null) request.fields['status'] = status;
      print('Request fields: ${request.fields}');

      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            'images[$i]',
            stream,
            length,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');
      final data = json.decode(responseBody) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ExploreModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to create explore');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update explore
  Future<ExploreModel> updateExplore({
    required String id,
    String? title,
    String? desc,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    String? status,
    List<File>? images,
  }) async {
    try {
      final token = _storageService.getAuthToken();
      final url = '$_baseUrl${ApiConstants.explores}/$id?_method=PUT';
      print('Request: POST $url');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );

      request.headers['Authorization'] = 'Bearer $token';
      if (title != null) request.fields['title'] = title;
      if (desc != null) request.fields['desc'] = desc;
      if (category != null) request.fields['category'] = category;
      if (type != null) request.fields['type'] = type;
      if (startDate != null) request.fields['start_date'] = startDate;
      if (endDate != null) request.fields['end_date'] = endDate;
      if (status != null) request.fields['status'] = status;
      print('Request fields: ${request.fields}');

      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            'images[$i]',
            stream,
            length,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');
      final data = json.decode(responseBody) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ExploreModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to update explore');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Approve explore
  Future<ExploreModel> approveExplore({
    required String id,
    String? category,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = <String, dynamic>{};
      if (category != null) body['category'] = category;
      if (startDate != null) body['start_date'] = startDate;
      if (endDate != null) body['end_date'] = endDate;

      final url = '$_baseUrl${ApiConstants.explores}/$id/approve';
      print('Request: POST $url');
      print('Request body: ${json.encode(body)}');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ExploreModel.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception(data['message'] ?? 'Failed to approve explore');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete explore
  Future<bool> deleteExplore(String id) async {
    try {
      final headers = await _getHeaders();
      final url = '$_baseUrl${ApiConstants.explores}/$id';
      
      print('Request: DELETE $url');
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
