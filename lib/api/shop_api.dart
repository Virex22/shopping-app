import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/shop.dart';

class ShopAPI extends AbstractAPI {
  Future<List<Shop>> getAllShops() async {
    final response = await get('/shops');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> shopList = data['hydra:member'];
    return shopList.map((shopJson) => Shop.fromJson(shopJson)).toList();
  }

  Future<Shop> getShop(int id) async {
    final response = await get('/shops/$id');
    final data = response.data as Map<String, dynamic>;
    return Shop.fromJson(data);
  }

  Future<Shop> addShop(Map<String, dynamic> shopData) async {
    final response = await post('/shops', shopData);
    final data = response.data as Map<String, dynamic>;
    return Shop.fromJson(data);
  }

  Future<void> deleteShop(int id) async {
    await delete('/shops/$id');
  }

  Future<Shop> updateShop(int id, Map<String, dynamic> updatedData) async {
    final response = await put('/shops/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return Shop.fromJson(data);
  }
}
