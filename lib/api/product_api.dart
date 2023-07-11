import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/product.dart';

class ProductAPI extends AbstractAPI {
  Future<List<Product>> getAllProducts() async {
    final response = await get('/products');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> productList = data['hydra:member'];
    return productList
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }

  Future<Product> getProduct(int id) async {
    final response = await get('/products/$id');
    final data = response.data as Map<String, dynamic>;
    return Product.fromJson(data);
  }

  Future<List<Product>> getProductsByShopId(int shopId) async {
    final response = await get('/products?shop=$shopId');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> productList = data['hydra:member'];
    return productList
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }

  Future<Product> addProduct(Map<String, dynamic> productData) async {
    final response = await post('/products', productData);
    final data = response.data as Map<String, dynamic>;
    return Product.fromJson(data);
  }

  Future<bool> deleteProduct(int id) async {
    final Response<dynamic> response = await delete('/products/$id');
    return response.statusCode == 204;
  }

  Future<Product> updateProduct(
      int id, Map<String, dynamic> updatedData) async {
    final response = await put('/products/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}
