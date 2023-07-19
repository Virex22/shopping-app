import 'package:flutter/foundation.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/shop.dart';

class ProductProvider with ChangeNotifier {
  List<Shop>? _shops;

  List<Shop>? get shops => _shops == null ? null : List.unmodifiable(_shops!);

  updateShopProductsFromApi(int shopId) async {
    if (_shops == null) {
      await refreshShopListFromApi();
      if (_shops!.where((element) => element.id == shopId).isEmpty) {
        throw Exception('Shop not found');
      }
    }
    final Shop shop = _shops!.firstWhere((element) => element.id == shopId);
    await shop.updateProductFromApi();
    notifyListeners();
  }

  addShop(Shop shop) {
    _shops!.add(shop);
    notifyListeners();
  }

  removeShop(int shopId) {
    _shops!.removeWhere((element) => element.id == shopId);
    notifyListeners();
  }

  updateShop(Shop shop) {
    int index = _shops!.indexWhere((element) => element.id == shop.id);
    _shops![index] = shop;
    notifyListeners();
  }

  refreshShopListFromApi() async {
    ShopAPI api = ShopAPI();
    List<Shop> shops = await api.getAllShops();
    _shops ??= [];
    _shops!.clear();
    _shops!.addAll(shops);
    notifyListeners();
  }

  deleteProduct(int shopId, int productId) {
    Shop shop = _shops!.firstWhere((element) => element.id == shopId);
    shop.removeProduct(productId);
    shop.productsCount--;
    notifyListeners();
  }

  addProduct(int shopId, Product product) {
    Shop shop = _shops!.firstWhere((element) => element.id == shopId);
    shop.addProduct(product);
    shop.productsCount++;
    notifyListeners();
  }

  updateProduct(int shopId, Product product) {
    Shop shop = _shops!.firstWhere((element) => element.id == shopId);
    shop.updateProduct(product);
    notifyListeners();
  }
}
