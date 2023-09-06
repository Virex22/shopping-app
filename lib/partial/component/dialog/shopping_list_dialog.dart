import 'package:flutter/material.dart';
import 'package:shopping_app/model/shopping_list.dart';

void showShoppingListFormDialog({
  required BuildContext context,
  required String title,
  required String validationText,
  required Function(String name) validationAction,
  String annulationText = 'Annuler',
  ShoppingList? shoppingListModel,
}) {
  final TextEditingController nameController =
      TextEditingController(text: shoppingListModel?.name);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        decoration: const InputDecoration(labelText: 'Nom de la liste'),
        controller: nameController,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(annulationText),
        ),
        TextButton(
          onPressed: () async {
            final String name = nameController.text.trim();
            Navigator.of(context).pop();
            validationAction(name);
          },
          child: Text(validationText),
        ),
      ],
    ),
  );
}

void showAddItemOnShoppingListDialog({
  required BuildContext context,
  required Function() addCustomItem,
  required Function() addExistingItem,
  required Function() addRecipeItem,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Ajouter un produit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              addCustomItem();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Ajouter un produit personnalisé'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              addExistingItem();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Ajouter un produit existant'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              addRecipeItem();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Ajouter à partir d\'une recette'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
      ],
    ),
  );
}

void showCustomShoppingListItemFormDialog(
    {required BuildContext context,
    required String title,
    required String validationText,
    required Function(String name, String price) validationAction,
    String annulationText = 'Annuler'}) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Nom du produit'),
            controller: nameController,
          ),
          TextField(
            decoration:
                const InputDecoration(labelText: 'Prix éstimé du produit'),
            controller: priceController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(annulationText),
        ),
        TextButton(
          onPressed: () async {
            final String name = nameController.text.trim();
            final String price = priceController.text.trim();
            Navigator.of(context).pop();
            validationAction(name, price);
          },
          child: Text(validationText),
        ),
      ],
    ),
  );
}
