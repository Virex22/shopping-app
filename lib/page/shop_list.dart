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

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des magasins'),
        actions: [
          IconButton(
            onPressed: () async {
              ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
              await productProvider.refreshShopListFromApi();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Liste des magasins mise à jour'),
                  duration: Duration(seconds: 2),
                ),
              );
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
