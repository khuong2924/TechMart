import 'package:dio/dio.dart';

abstract class BaseRepository {
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          final statusCode = e.response?.statusCode;
          final message = e.response?.data['message'] ?? 'An error occurred';
          throw Exception('Error $statusCode: $message');
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled');
        case DioExceptionType.connectionError:
          throw Exception('No internet connection');
        case DioExceptionType.unknown:
          throw Exception('An unknown error occurred');
        case DioExceptionType.badCertificate:
          throw Exception('Bad certificate');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
} 