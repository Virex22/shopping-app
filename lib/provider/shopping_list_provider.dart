import 'package:flutter/material.dart';
import 'package:shopping_app/api/shopping_list_api.dart';
import 'package:shopping_app/model/shopping_list.dart';

class ShoppingListProvider extends ChangeNotifier {
  List<ShoppingList>? _shoppingList;

  List<ShoppingList>? get shoppingList =>
      _shoppingList == null ? null : List.unmodifiable(_shoppingList!.reversed);

  void addShoppingList(ShoppingList shoppingList) {
    _shoppingList ??= [];
    _shoppingList!.add(shoppingList);
    notifyListeners();
  }

  void removeShoppingList(ShoppingList shoppingList) {
    _shoppingList!.remove(shoppingList);
    notifyListeners();
  }

  void updateShoppingList(ShoppingList shoppingList) {
    int index =
        _shoppingList!.indexWhere((element) => element.id == shoppingList.id);
    _shoppingList![index] = shoppingList;
    notifyListeners();
  }

  void refreshSoppingListFromApi() {
    ShoppingListAPI api = ShoppingListAPI();
    api.getAllShoppingLists().then((value) {
      _shoppingList ??= [];
      _shoppingList!.clear();
      _shoppingList!.addAll(value);
      notifyListeners();
    }).catchError((error) {
      throw Exception('Failed to load shopping list, error: $error');
    });
  }
}
