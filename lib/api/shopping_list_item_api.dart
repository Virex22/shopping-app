import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/shopping_list_item.dart';

class ShoppingListItemApi extends AbstractAPI {
  Future<List<ShoppingListItem>> getAllShoppingListItems() async {
    final response = await get('/shopping_list_items');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> shoppingListItem = data['hydra:member'];
    return shoppingListItem
        .map((shoppingListItemJson) =>
            ShoppingListItem.fromJson(shoppingListItemJson))
        .toList();
  }

  Future<ShoppingListItem> getShoppingListItem(int id) async {
    final response = await get('/shopping_list_items/$id');
    final data = response.data as Map<String, dynamic>;
    return ShoppingListItem.fromJson(data);
  }

  Future<ShoppingListItem> addShoppingListItem(
      Map<String, dynamic> shoppingListItemData) async {
    final response = await post('/shopping_list_items', shoppingListItemData);
    final data = response.data as Map<String, dynamic>;
    return ShoppingListItem.fromJson(data);
  }

  Future<bool> deleteShoppingListItem(int id) async {
    final Response<dynamic> response = await delete('/shopping_list_items/$id');
    return response.statusCode == 204;
  }

  Future<ShoppingListItem> updateShoppingListItem(
      int id, Map<String, dynamic> updatedData) async {
    final response = await put('/shopping_list_items/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return ShoppingListItem.fromJson(data);
  }
}
