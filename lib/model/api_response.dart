class ApiResponse<T> {
  final bool error;
  final String message;
  final T? data;

  ApiResponse({required this.error, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, String? dataKeyName, Function(List<dynamic>) dataList) {

    if (dataKeyName != null) {
      return ApiResponse(
        error: json["error"],
        message: json["message"],
        data: dataList(json[dataKeyName]),
      );
    }

    return ApiResponse(
      error: json["error"],
      message: json["message"],
      data: null,
    );
  }
}
