/*
[
  {
    "id": 0,
    "product": "string",
    "price": "string",
    "dateUpdate": "2023-08-17T09:27:45.211Z"
  }
]
*/

class PriceHistory {
  static String getIrifromId(int id) {
    return '/api/price_histories/$id';
  }

  int id;
  String productURI;
  double price;
  DateTime dateUpdate;

  get iri => PriceHistory.getIrifromId(id);

  PriceHistory({
    required this.id,
    required this.productURI,
    required this.price,
    required this.dateUpdate,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      id: json['id'],
      productURI: json['product'],
      price: json['price'] is String
          ? double.parse(json['price'])
          : json['price'].toDouble(),
      dateUpdate: DateTime.parse(json['dateUpdate']),
    );
  }
}
