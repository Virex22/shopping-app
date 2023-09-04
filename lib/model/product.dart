import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/shop.dart';

class Product {
  static String getIrifromId(int id) {
    return '/api/products/$id';
  }

  int id;
  String name;
  double price;
  DateTime dateAdd;
  String quantityType;
  double quantity;

  get iri => Product.getIrifromId(id);
  get quantityText => QuantityHelper.getQuantity(quantityType, quantity);
  Shop? shop;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.dateAdd,
      required this.quantity,
      this.quantityType = 'unit',
      this.shop});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: double.parse(json['price'].toString()),
        quantity: double.parse(json['quantity']),
        quantityType: json['quantityType'] ?? 'unit',
        dateAdd: DateTime.parse(json['dateAdd']));
  }
}
