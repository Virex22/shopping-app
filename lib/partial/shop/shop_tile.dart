import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/shop.dart';
import 'package:shopping_app/partial/component/dialog/shop_dialog.dart';

class ShopTile extends StatelessWidget {
  final Shop shop;
  final Function(String, Shop) handleShopAction;

  const ShopTile({Key? key, required this.shop, required this.handleShopAction})
      : super(key: key);

  void navigateOnShop(BuildContext context) {
    context.go('/shops/${shop.id}/products');
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
                final TextEditingController nameController =
                    TextEditingController(text: shop.name);
                nameController.text = shop.name;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Editer le magasin'),
                    content: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Nom du magasin'),
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
                          ShopAPI shopApi = ShopAPI();
                          ScaffoldMessengerState snackBar =
                              ScaffoldMessenger.of(context);
                          final String name = nameController.text.trim();
                          Navigator.of(context).pop();
                          Shop editedShop =
                              await shopApi.updateShop(shop.id, {'name': name});
                          handleShopAction('update', editedShop);
                          showSnackBar(
                              snackBar: snackBar,
                              message: editedShop.name == name
                                  ? 'Magasin modifié'
                                  : 'Erreur lors de la modification du magasin');
                        },
                        child: const Text('Modifier'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                showShopDeleteDialog(
                    context: context,
                    handleShopAction: handleShopAction,
                    shop: shop);
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
