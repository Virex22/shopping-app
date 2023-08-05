import 'package:flutter/material.dart';
import 'package:shopping_app/api/shopping_list_api.dart';
import 'package:shopping_app/model/shopping_list.dart';
import 'package:shopping_app/model/shopping_list_item.dart';

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
    });
  }

  Future<List<ShoppingList>> fetchAllShoppingListFromApi() async {
    ShoppingListAPI api = ShoppingListAPI();
    List<ShoppingList> shoppingLists = await api.getAllShoppingLists();
    _shoppingList ??= [];
    _shoppingList!.clear();
    _shoppingList!.addAll(shoppingLists);
    notifyListeners();
    return shoppingLists;
  }

  void deleteShoppingListItem(
      ShoppingListItem shoppingListItem, int shoppingListId) {
    ShoppingList shoppingList =
        _shoppingList!.firstWhere((element) => element.id == shoppingListId);
    shoppingList.items!
        .removeWhere((element) => element.id == shoppingListItem.id);
    notifyListeners();
  }

  void updateShoppingListItem(
      ShoppingListItem shoppingListItem, int shoppingListId) {
    ShoppingList shoppingList =
        _shoppingList!.firstWhere((element) => element.id == shoppingListId);
    int index = shoppingList.items!
        .indexWhere((element) => element.id == shoppingListItem.id);
    shoppingList.items![index] = shoppingListItem;
    notifyListeners();
  }

  void addShoppingListItem(
      ShoppingListItem shoppingListItem, int shoppingListId) {
    ShoppingList shoppingList =
        _shoppingList!.firstWhere((element) => element.id == shoppingListId);
    shoppingList.items!.add(shoppingListItem);
    notifyListeners();
  }
}
