import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/partial/component/dialog/product_dialog.dart';
import 'package:shopping_app/partial/product/product_tile.dart';
import 'package:shopping_app/provider/product_provider.dart';
import 'package:shopping_app/partial/component/search_bar.dart'
    as app_search_bar;

class ProductListPage extends StatefulWidget {
  final int shopId;

  const ProductListPage({Key? key, required this.shopId}) : super(key: key);

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  ProductProvider get _productProvider => context.read<ProductProvider>();
  String search = '';
  bool isSearching = false;

  List<Product>? getProductList() {
    if (_productProvider.shops == null) {
      return null;
    }
    final index = _productProvider.shops!
        .indexWhere((element) => element.id == widget.shopId);
    if (index != -1) {
      if (search.isNotEmpty && _productProvider.shops![index].product != null) {
        return _productProvider.shops![index].product!
            .where((element) =>
                element.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
      return _productProvider.shops![index].product;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _productProvider.updateShopProductsFromApi(widget.shopId);
  }

  void _handleAction(String action, Product product) {
    setState(() {
      if (action == 'delete') {
        _productProvider.deleteProduct(widget.shopId, product.id);
      } else if (action == 'update') {
        final index = _productProvider.shops!
            .indexWhere((element) => element.id == widget.shopId);
        if (index != -1) {
          _productProvider.shops![index].updateProduct(product);
        }
      }
    });

    final snackBar = ScaffoldMessenger.of(context);

    if (action == 'delete') {
      showSnackBar(snackBar: snackBar, message: 'Produit supprimé');
    } else if (action == 'update') {
      showSnackBar(snackBar: snackBar, message: 'Produit modifié');
    }
  }

  void _addProduct(BuildContext context) {
    showProductFormDialog(
        context: context,
        title: 'Ajouter un produit',
        validationText: 'Ajouter',
        validationAction: (name, price, quantity, quantityType) async {
          if (name.isEmpty || price <= 0) {
            return;
          }
          if (quantity <= 0) {
            quantity = 1;
          }

          final productApi = ProductAPI();
          final newProduct = await productApi.addProduct({
            'name': name,
            'price': price,
            'quantity': quantity.toStringAsFixed(3),
            'quantityType': quantityType,
            'shop': '/api/shops/${widget.shopId}',
          });

          _productProvider.addProduct(widget.shopId, newProduct);
        });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () async {
                  ScaffoldMessengerState snackBar =
                      ScaffoldMessenger.of(context);
                  await productProvider
                      .updateShopProductsFromApi(widget.shopId);
                  showSnackBar(
                      snackBar: snackBar,
                      message: 'Liste des produits mise à jour');
                },
                tooltip: 'Rafraîchir',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
      body: app_search_bar.SearchBar(
        showSearchBar: isSearching,
        onTextChanged: (changedText) {
          setState(() {
            search = changedText;
          });
        },
        content: getProductList() == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : getProductList()!.isEmpty
                ? Center(
                    child: Text(isSearching
                        ? 'Aucun produit ne correspond à votre recherche'
                        : 'Aucun produit n\'est enrégistré dans ce magasin'),
                  )
                : ListView.builder(
                    itemCount: getProductList()!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final product = getProductList()![index];
                      return ProductTile(
                        product: product,
                        handleProductAction: _handleAction,
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProduct(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
