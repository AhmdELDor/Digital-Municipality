import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../config/api_config.dart';
import 'auth_storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to headers if available
          final token = await AuthStorageService().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            await AuthStorageService().clearAuth();
            // Navigate to sign-in page
            getx.Get.offAllNamed('/sign-in');
          }
          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(String path, {dynamic data}) async {
    try {
      final response = await dio.delete(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException error) {
    String errorMessage = '';
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleResponseError(error.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'تم إلغاء الطلب';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'خطأ في الاتصال. يرجى التحقق من الإنترنت';
        break;
      default:
        errorMessage = 'حدث خطأ غير متوقع';
    }
    
    return errorMessage;
  }

  String _handleResponseError(Response? response) {
    if (response == null) {
      return 'لا يوجد رد من الخادم';
    }

    switch (response.statusCode) {
      case 400:
        return response.data['message'] ?? 'طلب غير صالح';
      case 401:
        return response.data['message'] ?? 'بيانات الاعتماد غير صالحة';
      case 403:
        return response.data['message'] ?? 'ممنوع الوصول';
      case 404:
        return 'المورد غير موجود';
      case 422:
        return _handleValidationError(response.data);
      case 500:
        return 'خطأ في الخادم. يرجى المحاولة لاحقاً';
      default:
        return response.data['message'] ?? 'حدث خطأ غير متوقع';
    }
  }

  String _handleValidationError(dynamic data) {
    if (data is Map && data.containsKey('errors')) {
      final errors = data['errors'] as Map;
      if (errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError[0].toString();
        }
      }
    }
    return data['message'] ?? 'خطأ في التحقق من البيانات';
  }
}
