import 'user_model.dart';

class AuthResponse {
  final int code;
  final bool success;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final code = json['code'] ?? 0;
    return AuthResponse(
      code: code,
      success: code == 200, // Consider 200 as success
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class AuthData {
  final UserModel user;
  final String token;

  AuthData({
    required this.user,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}
