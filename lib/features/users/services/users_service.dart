import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/storage_service.dart';
import '../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class UsersService {
  final StorageService _storageService;
  
  String get baseUrl => ApiConstants.baseUrl;

  UsersService(this._storageService);

  Future<Map<String, String>> _getHeaders() async {
    final token = _storageService.getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get all users with pagination
  Future<Map<String, dynamic>> getUsers({
    int page = 1,
    String? search,
  }) async {
    try {
      final headers = await _getHeaders();
      var url = '$baseUrl/users?page=$page';
      if (search != null && search.isNotEmpty) {
        url += '&search=$search';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final users = (data['data'] as List)
            .map((json) => User.fromJson(json))
            .toList();

        return {
          'users': users,
          'meta': data['meta'] ?? {},
        };
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get single user
  Future<User> getUser(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['data']);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create user
  Future<User> createUser({
    required String fullName,
    required String phonenumber,
    required String role,
    required String address,
    required String password,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: headers,
        body: json.encode({
          'full_name': fullName,
          'phonenumber': phonenumber,
          'role': role,
          'address': address,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['data']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update user
  Future<User> updateUser({
    required String id,
    String? fullName,
    String? phonenumber,
    String? role,
    String? address,
    String? password,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = <String, dynamic>{};
      
      if (fullName != null) body['full_name'] = fullName;
      if (phonenumber != null) body['phonenumber'] = phonenumber;
      if (role != null) body['role'] = role;
      if (address != null) body['address'] = address;
      if (password != null) body['password'] = password;

      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['data']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
