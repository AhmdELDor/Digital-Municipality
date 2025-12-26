import '../../core/config/api_config.dart';
import '../../core/services/api_service.dart';
import '../models/user_api_model.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  // Get all users with pagination
  Future<UsersListResponse> getUsers({int page = 1}) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.users}?page=$page',
      );
      return UsersListResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Get single user by ID
  Future<UserApiModel> getUserById(String id) async {
    try {
      final response = await _apiService.get(
        ApiConfig.userById(id),
      );
      final userResponse = UserResponse.fromJson(response.data);
      return userResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  // Create new user
  Future<UserApiModel> createUser(CreateUserRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConfig.users,
        data: request.toJson(),
      );
      final userResponse = UserResponse.fromJson(response.data);
      return userResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  // Update existing user
  Future<UserApiModel> updateUser(String id, UpdateUserRequest request) async {
    try {
      final response = await _apiService.put(
        ApiConfig.userById(id),
        data: request.toJson(),
      );
      final userResponse = UserResponse.fromJson(response.data);
      return userResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    try {
      await _apiService.delete(ApiConfig.userById(id));
    } catch (e) {
      rethrow;
    }
  }
}
