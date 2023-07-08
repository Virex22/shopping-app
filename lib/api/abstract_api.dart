import 'package:dio/dio.dart';

abstract class AbstractAPI {
  static const String baseUrl = 'http://api-shop.vincent-remy.fr';
  late Dio dio;

  AbstractAPI() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
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
      throw Exception('Erreur lors de la requête POST : $e');
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
