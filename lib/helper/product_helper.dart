import 'package:shopping_app/model/product.dart';

class ProductHelper {
  static String getTitle(Product product) {
    String title = product.name;
    if (product.quantity > 0 &&
        !(product.quantityType == "unit" && product.quantity == 1)) {
      if (product.quantityType != "unit") {
        title += ' (${product.quantityText})';
      } else {
        title += ' (x${product.quantity.toInt()})';
      }
    }
    return title;
  }
}
