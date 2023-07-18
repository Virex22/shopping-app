import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/partial/product/product_tile.dart';
import 'package:shopping_app/provider/product_provider.dart';

class ProductListPage extends StatefulWidget {
  final int shopId;

  const ProductListPage({Key? key, required this.shopId}) : super(key: key);

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  ProductProvider get _productProvider => context.read<ProductProvider>();

  List<Product>? getProductList() {
    final index = _productProvider.shops
        .indexWhere((element) => element.id == widget.shopId);
    if (index != -1) {
      return _productProvider.shops[index].product;
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
        final index = _productProvider.shops
            .indexWhere((element) => element.id == widget.shopId);
        if (index != -1) {
          _productProvider.shops[index].updateProduct(product);
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

  Future<void> _fetchProducts() async {
    /*setState(() {
      _isLoading = true;
    });

    try {
      final productApi = ProductAPI();
      final List<Product> products =
          await productApi.getProductsByShopId(widget.shopId);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: Text(
              'Une erreur s\'est produite lors du chargement des produits. Erreur: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }*/
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
          IconButton(
            onPressed: () {
              _fetchProducts();
            },
            tooltip: 'Rafraîchir',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: (getProductList() == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: getProductList()!.length,
              itemBuilder: (context, index) {
                final product = getProductList()![index];
                return ProductTile(
                  product: product,
                  handleProductAction: _handleAction,
                );
              },
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
