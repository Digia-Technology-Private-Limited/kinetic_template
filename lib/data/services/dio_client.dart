import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: ApiConstants.defaultHeaders,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Response> post(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
