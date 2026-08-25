import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  static ApiService? _instance;
  late Dio _dio;
  final StorageService _storageService;

  ApiService._(this._storageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.headers,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to headers if available
          final token = _storageService.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - Token expired
          if (error.response?.statusCode == 401) {
            await _storageService.clearSession();
            // Navigate to login screen (will be handled by provider)
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<ApiService> getInstance() async {
    if (_instance == null) {
      final storage = await StorageService.getInstance();
      _instance = ApiService._(storage);
    }
    return _instance!;
  }

  // GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload file
  Future<Response> uploadFile(
    String endpoint,
    String filePath, {
    String fileKey = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload with FormData
  Future<Response> upload(
    String endpoint,
    FormData formData, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException error) {
    String errorMessage = 'حدث خطأ غير متوقع';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'انتهت مهلة الاتصال بالخادم';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'انتهت مهلة إرسال البيانات';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'انتهت مهلة استقبال البيانات';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else {
          switch (statusCode) {
            case 400:
              errorMessage = 'طلب غير صحيح';
              break;
            case 401:
              errorMessage = 'غير مصرح لك بالوصول';
              break;
            case 403:
              errorMessage = 'ممنوع الوصول';
              break;
            case 404:
              errorMessage = 'المورد غير موجود';
              break;
            case 422:
              errorMessage = 'بيانات غير صالحة';
              break;
            case 500:
              errorMessage = 'خطأ في الخادم';
              break;
            default:
              errorMessage = 'حدث خطأ في الخادم';
          }
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'تم إلغاء الطلب';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'فشل الاتصال بالإنترنت';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'خطأ في شهادة الأمان';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'خطأ غير معروف';
        break;
    }

    return errorMessage;
  }

  // Update auth token
  void updateAuthToken(String token) {
    _storageService.saveAuthToken(token);
  }

  // Clear auth token
  void clearAuthToken() {
    _storageService.remove('auth_token');
  }
}
