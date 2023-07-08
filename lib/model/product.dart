class Product {
  final int id;
  final String name;
  final double price;
  final DateTime dateAdd;
  final DateTime dateUpdate;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.dateAdd,
    required this.dateUpdate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      dateAdd: DateTime.parse(json['dateAdd']),
      dateUpdate: DateTime.parse(json['date_update']),
    );
  }
}
