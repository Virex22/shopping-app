import 'package:flutter/material.dart';
import 'package:shopping_app/model/shop.dart';

void showShopFormDialog({
  required BuildContext context,
  required String title,
  required String validationText,
  required Function(String name) validationAction,
  String annulationText = 'Annuler',
  Shop? shopModel,
}) {
  final TextEditingController nameController =
      TextEditingController(text: shopModel?.name);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        decoration: const InputDecoration(labelText: 'Nom du magasin'),
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
