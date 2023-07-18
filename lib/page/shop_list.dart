import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/partial/shop/shop_tile.dart';
import 'package:shopping_app/provider/product_provider.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({Key? key}) : super(key: key);

  @override
  ShopListPageState createState() => ShopListPageState();
}

class ShopListPageState extends State<ShopListPage> {
  ProductProvider get _productProvider => context.read<ProductProvider>();

  @override
  void initState() {
    super.initState();
    _productProvider.refreshShopListFromApi();
  }

  handleAction(String action, Shop shop) {
    setState(() {
      if (action == 'delete') {
        _productProvider.removeShop(shop.id);
      } else if (action == 'update') {
        _productProvider.updateShop(shop);
      } else if (action == 'refresh') {
        _productProvider.refreshShopListFromApi();
      }
    });
  }

  Future<void> _fetchShops() async {
    /*setState(() {
      _isLoading = true;
    });

    try {
      final shopApi = ShopAPI();
      final List<Shop> shops = await shopApi.getAllShops();
      setState(() {
        _shops = shops;
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
              'Une erreur s\'est produite lors du chargement des magasins. Erreur: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des magasins'),
        actions: [
          IconButton(
            onPressed: () {
              productProvider.refreshShopListFromApi();
            },
            tooltip: 'Rafraîchir',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: productProvider.shops.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _productProvider.shops.length,
              itemBuilder: (context, index) {
                final shop = _productProvider.shops[index];
                return ShopTile(
                  shop: shop,
                  handleShopAction: handleAction,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final TextEditingController nameController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ajouter un magasin'),
              content: TextField(
                decoration: const InputDecoration(labelText: 'Nom du magasin'),
                controller: nameController,
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
                    Navigator.of(context).pop();
                    if (name.isEmpty) {
                      return;
                    }
                    final shopApi = ShopAPI();
                    Shop newShop = await shopApi.addShop({'name': name});
                    setState(() {
                      _productProvider.addShop(newShop);
                    });
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          );
        },
        child:
            Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}
