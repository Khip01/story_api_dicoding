import 'package:dio/dio.dart';
import 'package:story_api_dicoding/model/api_response.dart';
import 'package:story_api_dicoding/model/login_result.dart';
import 'package:story_api_dicoding/values/strings.dart';

class AuthRepository {
  late final Dio dio;

  AuthRepository() {
    dio = Dio();
    dio.options.baseUrl = Strings.baseUrl;
  }

  Future<ApiResponse<LoginResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      return ApiResponse<LoginResult>(
        error: response.data["error"],
        message: response.data["message"],
        data: LoginResult.fromJson(response.data["loginResult"]),
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw 'Connection timeout';
        case DioExceptionType.sendTimeout:
          throw 'Send timeout';
        case DioExceptionType.receiveTimeout:
          throw 'Receive timeout';
        case DioExceptionType.badCertificate:
          throw 'Bad certificate';
        case DioExceptionType.badResponse:
          throw e.response?.data["message"] ?? 'bad response';
        case DioExceptionType.cancel:
          throw 'Request cancelled';
        case DioExceptionType.connectionError:
          throw 'Connection error';
        case DioExceptionType.unknown:
          throw 'Unknown';
      }
    }
  }

  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      return ApiResponse(
        error: response.data["error"],
        message: response.data["message"],
        data: null,
      );
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw 'Connection timeout';
        case DioExceptionType.sendTimeout:
          throw 'Send timeout';
        case DioExceptionType.receiveTimeout:
          throw 'Receive timeout';
        case DioExceptionType.badCertificate:
          throw 'Bad certificate';
        case DioExceptionType.badResponse:
          throw e.response?.data["message"] ?? 'bad response';
        case DioExceptionType.cancel:
          throw 'Request cancelled';
        case DioExceptionType.connectionError:
          throw 'Connection error';
        case DioExceptionType.unknown:
          throw 'Unknown';
      }
    }
  }
}
