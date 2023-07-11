import 'package:flutter/material.dart';
import 'package:shopping_app/api/product_api.dart';
import 'package:shopping_app/model/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final Function(String, Product) handleProductAction;

  const ProductTile({
    Key? key,
    required this.product,
    required this.handleProductAction,
  }) : super(key: key);

  void _editProduct(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: product.name);
    nameController.text = product.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le produit'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Nom du produit'),
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

              final productApi = ProductAPI();
              Product editedProduct =
                  await productApi.updateProduct(product.id, {'name': name});

              handleProductAction('update', editedProduct);
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          product.name,
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
              onPressed: () async {
                final productApi = ProductAPI();
                bool response = await productApi.deleteProduct(product.id);
                if (response) {
                  handleProductAction('delete', product);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erreur lors de la suppression du produit'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
