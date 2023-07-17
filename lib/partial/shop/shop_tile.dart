import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/api/shop_api.dart';
import 'package:shopping_app/model/shop.dart';

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
        title: Text(
          shop.name,
          style: Theme.of(context).textTheme.titleLarge,
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
                          if (editedShop.name == name) {
                            snackBar.showSnackBar(
                              const SnackBar(
                                content: Text('Magasin modifié'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            snackBar.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Erreur lors de la modification du magasin'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Supprimer le magasin'),
                    content: const Text(
                        'Êtes-vous sûr de vouloir supprimer ce magasin ?'),
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
                          Navigator.of(context).pop();
                          ScaffoldMessengerState snackBar =
                              ScaffoldMessenger.of(context);
                          bool response = await shopApi.deleteShop(shop.id);
                          if (response) {
                            snackBar.showSnackBar(
                              const SnackBar(
                                content: Text('Magasin supprimé'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            handleShopAction('delete', shop);
                          } else {
                            snackBar.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Erreur lors de la suppression du magasin'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: const Text('Supprimer',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
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
