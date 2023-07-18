import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/model/product.dart';

class Shop {
  int id;
  String name;
  DateTime dateAdd;
  int productsCount;
  get iri => '/shops/$id';

  List<Product>? product;

  Shop({
    required this.id,
    required this.name,
    required this.dateAdd,
    required this.productsCount,
    this.product,
  });

  updateProductFromApi() async {
    ProductAPI api = ProductAPI();
    product = await api.getProductsByShopId(id);
  }

  removeProduct(int productId) {
    product!.removeWhere((element) => element.id == productId);
  }

  addProduct(Product product) {
    this.product!.add(product);
  }

  updateProduct(Product product) {
    int index = this.product!.indexWhere((element) => element.id == product.id);
    this.product![index] = product;
  }

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      dateAdd: DateTime.parse(json['dateAdd']),
      productsCount: json['productsCount'],
    );
  }
}
