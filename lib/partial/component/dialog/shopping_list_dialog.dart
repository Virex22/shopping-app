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
