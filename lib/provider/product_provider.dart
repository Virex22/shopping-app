import 'package:flutter/foundation.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/model/shop.dart';

class ProductProvider with ChangeNotifier {
  final List<Shop> _shops = [];

  List<Shop> get shops => _shops;

  updateShopProductsFromApi(int shopId) {
    Shop shop = _shops.firstWhere((element) => element.id == shopId);
    shop.updateProductFromApi();
    notifyListeners();
  }

  addShop(Shop shop) {
    _shops.add(shop);
    notifyListeners();
  }

  removeShop(int shopId) {
    _shops.removeWhere((element) => element.id == shopId);
    notifyListeners();
  }

  updateShop(Shop shop) {
    int index = _shops.indexWhere((element) => element.id == shop.id);
    _shops[index] = shop;
    notifyListeners();
  }

  refreshShopListFromApi() {
    ShopAPI api = ShopAPI();
    api.getAllShops().then((value) {
      _shops.clear();
      _shops.addAll(value);
      notifyListeners();
    });
  }
}
