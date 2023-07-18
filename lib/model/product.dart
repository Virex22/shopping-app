import 'package:shopping_app/model/shop.dart';

class Product {
  int id;
  String name;
  double price;
  DateTime dateAdd;
  get iri => '/products/$id';
  Shop? shop;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.dateAdd,
      this.shop});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        dateAdd: DateTime.parse(json['dateAdd']));
  }
}
