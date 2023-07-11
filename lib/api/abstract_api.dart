import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AbstractAPI {
  late Dio dio;

  AbstractAPI() {
    final String? baseUrl = dotenv.env['API_URL'];

    dio = Dio(BaseOptions(
      baseUrl: baseUrl!,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token'
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final authToken = dotenv.env['AUTH_TOKEN'];
        options.headers['X-AUTH-TOKEN'] = authToken;
        return handler.next(options);
      },
    ));
  }

  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la requête GET : $e');
    }
  }

  Future<Response<dynamic>> post(String path, dynamic data) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la requête POST reponse de dio : $e ');
    }
  }

  Future<Response<dynamic>> put(String path, dynamic data) async {
    try {
      final response = await dio.put(path, data: data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la requête PUT : $e');
    }
  }

  Future<Response<dynamic>> delete(String path) async {
    try {
      final response = await dio.delete(path);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la requête DELETE : $e');
    }
  }
}
