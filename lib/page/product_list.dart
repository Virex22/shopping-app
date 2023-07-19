import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/partial/product/product_tile.dart';
import 'package:shopping_app/provider/product_provider.dart';
import 'package:shopping_app/partial/component/search_bar.dart' as AppSearchBar;

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

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (action == 'delete') {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Produit supprimé'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (action == 'update') {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Produit mis à jour'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _addProduct(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un produit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nom du produit'),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Prix du produit'),
              controller: priceController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final String name = nameController.text.trim();
              final double price = double.tryParse(priceController.text) ?? 0.0;

              if (name.isEmpty || price <= 0) {
                return;
              }

              NavigatorState navigatorState = Navigator.of(context);

              final productApi = ProductAPI();
              final newProduct = await productApi.addProduct({
                'name': name,
                'price': price,
                'shop': '/api/shops/${widget.shopId}',
              });

              setState(() {
                _productProvider.addProduct(widget.shopId, newProduct);
              });

              navigatorState.pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
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
                  ScaffoldMessengerState messenger =
                      ScaffoldMessenger.of(context);
                  await productProvider
                      .updateShopProductsFromApi(widget.shopId);
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Liste des produits mise à jour'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Rafraîchir',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
      body: AppSearchBar.SearchBar(
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
                ? const Center(
                    child:
                        Text('Aucun produit n\'est enrégistré dans ce magasin'),
                  )
                : ListView.builder(
                    itemCount: getProductList()!.length,
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
