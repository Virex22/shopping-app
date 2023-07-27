import 'package:flutter/material.dart';
import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/product.dart';
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

  void _editProduct(BuildContext context) {
    showProductFormDialog(
        context: context,
        title: 'Modifier le produit',
        validationText: 'Modifier',
        productModel: product,
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
    showDeleteDialog(
        context: context,
        subtitle: 'Êtes-vous sûr de vouloir supprimer ce produit ?',
        handleOnDelete: () async {
          final productApi = ProductAPI();
          ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
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

  String getTitle() {
    String title = product.name;
    if (product.quantity > 0 &&
        !(product.quantityType == "unit" && product.quantity == 1)) {
      if (product.quantityType != "unit") {
        title += ' (${product.quantityText})';
      } else {
        title += ' (x${product.quantity.toInt()})';
      }
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          getTitle(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '${product.price} €',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () {
                _editProduct(context);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteProduct(context);
              },
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
