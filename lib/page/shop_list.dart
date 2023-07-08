import 'package:flutter/material.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/partial/shop/shop_tile.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({Key? key}) : super(key: key);

  @override
  ShopListPageState createState() => ShopListPageState();
}

class ShopListPageState extends State<ShopListPage> {
  List<Shop> _shops = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchShops();
  }

  handleShopDeleted(Shop shop) {
    setState(() {
      _shops.remove(shop);
    });
  }

  Future<void> _fetchShops() async {
    setState(() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des magasins'),
        actions: [
          IconButton(
            onPressed: () {
              _fetchShops();
            },
            tooltip: 'Rafraîchir',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _shops.length,
              itemBuilder: (context, index) {
                final shop = _shops[index];
                return ShopTile(
                  shop: shop,
                  handleShopDeleted: handleShopDeleted,
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
                      _shops.add(newShop);
                    });
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
