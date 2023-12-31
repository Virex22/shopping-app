import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/partial/component/dialog/delete_dialog.dart';
import 'package:shopping_app/partial/component/dialog/shop_dialog.dart';

class ShopTile extends StatelessWidget {
  final Shop shop;
  final Function(String, Shop) handleShopAction;

  const ShopTile({Key? key, required this.shop, required this.handleShopAction})
      : super(key: key);

  void navigateOnShop(BuildContext context) {
    context.go('/shops/${shop.id}/products');
  }

  void _editShop(BuildContext context) {
    showShopFormDialog(
        context: context,
        title: 'Modifier le magasin',
        validationText: 'Modifier',
        shopModel: shop,
        validationAction: (String name) async {
          if (name.isEmpty) {
            return;
          }
          final shopApi = ShopAPI();
          Shop editedShop = await shopApi.updateShop(shop.id, {'name': name});
          handleShopAction('update', editedShop);
        });
  }

  void _deleteShop(BuildContext context) {
    showDeleteDialog(
        context: context,
        handleOnDelete: () async {
          ShopAPI shopApi = ShopAPI();
          ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
          bool response = await shopApi.deleteShop(shop.id);
          showSnackBar(
              snackBar: snackBar,
              message: response
                  ? 'Magasin supprimé'
                  : 'Erreur lors de la suppression du magasin');
          if (response) handleShopAction('delete', shop);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge,
                  children: [
                    TextSpan(text: shop.name.toUpperCase()),
                    TextSpan(
                      text:
                          ' (${shop.productsCount} produit${shop.productsCount > 1 ? 's' : ''})',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          'ID: ${shop.id}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                _editShop(context);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteShop(context);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
              ),
              onPressed: () {
                navigateOnShop(context);
              },
            ),
          ],
        ),
        onTap: () {
          navigateOnShop(context);
        },
      ),
    );
  }
}
