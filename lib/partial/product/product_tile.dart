import 'package:flutter/material.dart';
import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/api/shopping_list_item_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/helper/product_helper.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/shopping_list.dart';
import 'package:shopping_app/partial/component/dialog/delete_dialog.dart';
import 'package:shopping_app/partial/component/dialog/product_dialog.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final Function(String, Product) handleProductAction;

  const ProductTile({
    Key? key,
    required this.product,
    required this.handleProductAction,
  }) : super(key: key);

  void _editProduct(BuildContext context, {bool onlyPrice = false}) {
    showProductFormDialog(
        context: context,
        title: 'Modifier le produit',
        validationText: 'Modifier',
        productModel: product,
        onlyPrice: onlyPrice,
        validationAction: (String name, double price, double quantity,
            String quantityType) async {
          if (name.isEmpty || price <= 0) {
            return;
          }
          if (quantity <= 0) {
            quantity = 1;
          }
          final productApi = ProductAPI();
          Product editedProduct = await productApi.updateProduct(product.id, {
            'name': name,
            'price': price,
            'quantity': quantity.toStringAsFixed(3),
            'quantityType': quantityType,
          });
          handleProductAction('update', editedProduct);
        });
  }

  void _deleteProduct(BuildContext context) {
    ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
    showDeleteDialog(
        context: context,
        subtitle: 'Êtes-vous sûr de vouloir supprimer ce produit ?',
        handleOnDelete: () async {
          final productApi = ProductAPI();
          bool response = await productApi.deleteProduct(product.id);
          if (response) {
            handleProductAction('delete', product);
          } else {
            showSnackBar(
                snackBar: snackBar,
                message: 'Erreur lors de la suppression du produit');
          }
        });
  }

  void _addProductToShoppingList(BuildContext context) {
    ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
    showProductAddToListDialog(
      context: context,
      product: product,
      handleOnAddToList: (int listId) async {
        final ShoppingListItemApi shoppingListItemApi = ShoppingListItemApi();
        shoppingListItemApi.addShoppingListItem({
          'product': Product.getIrifromId(product.id),
          'shoppingList': ShoppingList.getIrifromId(listId),
          'quantity': 1
        }).then((value) {
          showSnackBar(
              snackBar: snackBar,
              message: 'Produit ajouté à la liste de courses');
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          ProductHelper.getTitle(product),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              _editProduct(context, onlyPrice: true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${product.price} €',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.blue,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add_shopping_cart),
                      title: const Text('Ajouter dans une liste de courses'),
                      onTap: () {
                        Navigator.pop(context);
                        _addProductToShoppingList(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Modifier'),
                      onTap: () {
                        Navigator.pop(context);
                        _editProduct(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Supprimer'),
                      onTap: () {
                        Navigator.pop(context);
                        _deleteProduct(context);
                      },
                      textColor: Colors.red,
                      iconColor: Colors.red,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
