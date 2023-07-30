import 'package:shopping_app/model/product.dart';

class ShoppingListItem {
  int id;
  String name;
  bool isCompleted;
  Product product;

  get iri => '/shopping_list_items/$id';

  ShoppingListItem({
    required this.id,
    required this.name,
    required this.isCompleted,
    required this.product,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      name: json['name'],
      isCompleted: json['isCompleted'],
      product: Product.fromJson(json['product']),
    );
  }
}
