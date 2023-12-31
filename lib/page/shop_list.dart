import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/partial/component/dialog/shop_dialog.dart';
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
              ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
              await productProvider.refreshShopListFromApi();
              showSnackBar(
                  snackBar: snackBar,
                  message: 'Liste des magasins mise à jour');
            },
            tooltip: 'Rafraîchir',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: productProvider.shops == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : productProvider.shops!.isEmpty
              ? const Center(
                  child: Text('Aucun magasin n\'est enrégistré'),
                )
              : ListView.builder(
                  itemCount: _productProvider.shops!.length,
                  itemBuilder: (context, index) {
                    final shop = _productProvider.shops![index];
                    return ShopTile(
                      shop: shop,
                      handleShopAction: handleAction,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showShopFormDialog(
            context: context,
            title: 'Ajouter un magasin',
            validationText: 'Ajouter',
            validationAction: (name) async {
              final shopApi = ShopAPI();
              Shop newShop = await shopApi.addShop({'name': name});
              setState(() {
                _productProvider.addShop(newShop);
              });
            },
          );
        },
        child:
            Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}
