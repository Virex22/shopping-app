import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/shop.dart';

class Product {
  int id;
  String name;
  double price;
  DateTime dateAdd;
  String quantityType;
  double quantity;

  get iri => '/api/products/$id';
  get quantityText => QuantityHelper.getQuantity(this);
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
