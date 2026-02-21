import 'dart:io';

import 'package:backonnect/core/constants/api_constants.dart';
import 'package:backonnect/core/exceptions/app_exceptions.dart';
import 'package:backonnect/core/network/interceptors/auth_interceptor.dart';
import 'package:backonnect/core/network/interceptors/logging_interceptor.dart';
import 'package:backonnect/core/storage/token_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.apiPrefix}',
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        sendTimeout:
            const Duration(milliseconds: ApiConstants.sendTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(tokenService: Get.find<TokenStorageService>()),
    ]);
  }

  Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException('No internet connection');
    }
  }

  Future<Response<dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException('No internet connection');
    }
  }

  Future<Response<dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException('No internet connection');
    }
  }

  Future<Response<dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      // DELETE returns 204 No Content — treat as success
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException('No internet connection');
    }
  }

  Response<dynamic> _handleResponse(Response<dynamic> response) {
    final status = response.statusCode ?? 0;
    if (status >= 500) {
      throw ServerException('Server error ($status)', statusCode: status);
    }
    return response;
  }

  AppException _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkException('Request timed out');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException('No internet connection');
    }

    final status = e.response?.statusCode;
    final message = _extractMessage(e.response?.data) ?? e.message ?? 'Unknown error';

    switch (status) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 409:
        return ConflictException(message);
      case 422:
        return ValidationException(message, errors: e.response?.data);
      case 500:
      case 503:
        return ServerException(message, statusCode: status);
      default:
        return ServerException(message, statusCode: status);
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['detail'] as String?;
    }
    return null;
  }
}
