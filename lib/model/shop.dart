class Shop {
  final int id;
  final String name;
  final DateTime dateAdd;
  get iri => '/shops/$id';

  Shop({
    required this.id,
    required this.name,
    required this.dateAdd,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      dateAdd: DateTime.parse(json['dateAdd']),
    );
  }
}
