import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:story_api_dicoding/model/api_response.dart';
import 'package:story_api_dicoding/model/story.dart';
import 'package:story_api_dicoding/values/strings.dart';

class StoryRepository {
  final String token;
  late Dio dio;

  StoryRepository({required this.token}) {
    dio = Dio();
    dio.options.baseUrl = Strings.baseUrl;
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<ListStory> getAllStory(int? size) async {
    try {
      Response response = await dio.get(
        '/stories',
        queryParameters: {"size": size ?? 10},
      );
      ApiResponse<ListStory> apiResponse = ApiResponse.fromJson(
        response.data,
        'listStory',
        (data) => ListStory.fromJson(data),
      );

      return apiResponse.data!;
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
          throw e.response?.data["message"] ?? 'Bad response';
        case DioExceptionType.cancel:
          throw 'Request cancelled';
        case DioExceptionType.connectionError:
          throw 'Connection error';
        case DioExceptionType.unknown:
          throw 'Unknown';
      }
    }
  }

  Future<ApiResponse> postNewStory({
    required String? description,
    required PlatformFile? photoFile,
  }) async {
    try {
      // final MultipartFile? photo =
      //     photoFile != null ? MultipartFile.fromBytes(photoFile.bytes!) : null;

      final MultipartFile? photo =
          photoFile != null
              ? MultipartFile.fromBytes(
                photoFile.bytes!,
                filename: photoFile.name,
                // contentType: DioMediaType(
                //   "image",
                //   photoFile.extension ?? "jpeg",
                // ),
              )
              : null;

      // final FormData formData = FormData.fromMap({
      //   'description': description,
      //   if (photo != null) 'photo': photo,
      // });

      Response response = await dio.post(
        '/stories',
        data: FormData.fromMap({'description': description, 'photo': photo}),
        // data: formData,
        // options: Options(
        //   headers: {
        //     "Content-Type": "multipart/form-data",
        //   }
        // ),
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
          throw e.response?.data["message"] ?? 'Bad response';
        case DioExceptionType.cancel:
          throw 'Request cancelled';
        case DioExceptionType.connectionError:
          throw 'Connection error';
        case DioExceptionType.unknown:
          throw 'Unknown Error ${e.response?.data}';
      }
    }
  }
}
