import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';

class ProductsAPI extends AbstractAPI {
  Future<Response<dynamic>> getProducts() async {
    return await get('/products');
  }

  Future<Response<dynamic>> addProduct(Map<String, dynamic> productData) async {
    return await post('/products', productData);
  }
}
