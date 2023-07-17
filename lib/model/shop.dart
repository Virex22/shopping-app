class Shop {
  final int id;
  final String name;
  final DateTime dateAdd;
  final int productsCount;
  get iri => '/shops/$id';

  Shop({
    required this.id,
    required this.name,
    required this.dateAdd,
    required this.productsCount,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      dateAdd: DateTime.parse(json['dateAdd']),
      productsCount: json['productsCount'],
    );
  }
}
