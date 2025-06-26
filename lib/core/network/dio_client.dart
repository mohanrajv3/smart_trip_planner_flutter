import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({String? baseUrl})
      : dio = Dio(BaseOptions(
    baseUrl: baseUrl ?? 'https://api.example.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authentication headers if needed
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors
        return handler.next(error);
      },
    ));
  }
}
