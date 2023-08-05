import 'package:intl/intl.dart';
import 'package:shopping_app/model/shopping_list_item.dart';

class ShoppingList {
  static String getIrifromId(int id) {
    return '/api/shopping_lists/$id';
  }

  int id;
  String name;
  DateTime dateAdd;
  List<ShoppingListItem>? items;

  get iri => ShoppingList.getIrifromId(id);
  get formattedDateAdd => DateFormat('dd/MM/yyyy').format(dateAdd);

  ShoppingList({
    required this.id,
    required this.name,
    required this.dateAdd,
    required this.items,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    List<ShoppingListItem> items = [];
    if (json['items'] != null) {
      items = json['items']
          .map((shoppingListItemJson) =>
              ShoppingListItem.fromJson(shoppingListItemJson))
          .toList()
          .cast<ShoppingListItem>();
    }
    return ShoppingList(
        id: json['id'],
        name: json['name'],
        dateAdd: DateTime.parse(json['dateAdd']),
        items: items);
  }
}
