import 'package:flutter/material.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/model/shop.dart';

class ShopTile extends StatelessWidget {
  final Shop shop;
  final Function(Shop) handleShopDeleted;

  const ShopTile(
      {Key? key, required this.shop, required this.handleShopDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          shop.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            ShopAPI shopApi = ShopAPI();
            ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
            bool response = await shopApi.deleteShop(shop.id);
            if (response) {
              snackBar.showSnackBar(
                const SnackBar(
                  content: Text('Magasin supprimé'),
                ),
              );
              handleShopDeleted(shop);
            } else {
              snackBar.showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors de la suppression du magasin'),
                ),
              );
            }
          },
        ),
        onTap: () {
          // Navigator.of(context).pushNamed('/shops/${shop.id}');
        },
      ),
    );
  }
}
