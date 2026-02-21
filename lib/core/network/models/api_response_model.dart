class ApiResponseModel<T> {
  final bool success;
  final int responseCode;
  final String message;
  final String tableName;
  final T? data;

  const ApiResponseModel({
    required this.success,
    required this.responseCode,
    required this.message,
    required this.tableName,
    this.data,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponseModel<T>(
      success: json['success'] as bool? ?? false,
      responseCode: json['response_code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      tableName: json['table_name'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}
