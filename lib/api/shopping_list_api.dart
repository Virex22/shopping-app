import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/shopping_list.dart';

class ShoppingListAPI extends AbstractAPI {
  Future<List<ShoppingList>> getAllShoppingLists() async {
    final response = await get('/shopping_lists');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> shoppingList = data['hydra:member'];
    return shoppingList
        .map((shoppingListJson) => ShoppingList.fromJson(shoppingListJson))
        .toList();
  }

  Future<ShoppingList> getShoppingList(int id) async {
    final response = await get('/shopping_lists/$id');
    final data = response.data as Map<String, dynamic>;
    return ShoppingList.fromJson(data);
  }

  Future<ShoppingList> addShoppingList(
      Map<String, dynamic> shoppingListData) async {
    final response = await post('/shopping_lists', shoppingListData);
    if (response.statusCode != 201) {
      throw Exception('Failed to create shopping list, error $response');
    }
    final data = response.data as Map<String, dynamic>;
    return ShoppingList.fromJson(data);
  }

  Future<bool> deleteShoppingList(int id) async {
    final Response<dynamic> response = await delete('/shopping_lists/$id');
    return response.statusCode == 204;
  }

  Future<ShoppingList> updateShoppingList(
      int id, Map<String, dynamic> updatedData) async {
    final response = await put('/shopping_lists/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return ShoppingList.fromJson(data);
  }
}
