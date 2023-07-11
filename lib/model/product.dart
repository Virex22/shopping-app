class Product {
  final int id;
  final String name;
  final double price;
  final DateTime dateAdd;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.dateAdd});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        dateAdd: DateTime.parse(json['dateAdd']));
  }
}
