import 'package:shopping_app/helper/product_helper.dart';
import 'package:shopping_app/model/product.dart';

class ShoppingListItem {
  static String getIrifromId(int id) {
    return '/api/shopping_list_items/$id';
  }

  int id;
  bool isCompleted;
  Product? product;
  String? customName;
  double? customPrice;
  int quantity;

  get iri => ShoppingListItem.getIrifromId(id);
  get isCustom => product == null;

  double get price {
    if (product == null && customPrice != null) {
      return customPrice!;
    } else if (product != null) {
      return product!.price;
    } else {
      return 0;
    }
  }

  get name {
    if (product == null && customName != null) {
      return customName;
    } else if (product != null) {
      return ProductHelper.getTitle(product!);
    } else {
      return '';
    }
  }

  ShoppingListItem({
    required this.id,
    required this.isCompleted,
    required this.product,
    required this.quantity,
    this.customName,
    this.customPrice,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      isCompleted: json['isCompleted'],
      product:
          json['product'] == null ? null : Product.fromJson(json['product']),
      quantity: json['quantity'],
      customName: json['customName'],
      customPrice: json['customPrice'] == null
          ? null
          : double.parse(json['customPrice']),
    );
  }
}
