import 'package:flutter/material.dart';

void showProductFormDialog({
  required BuildContext context,
  required String title,
  required String validationText,
  required Function(String name, double price) validationAction,
  String annulationText = 'Annuler',
}) {
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
            decoration: const InputDecoration(labelText: 'Prix du produit'),
            controller: priceController,
            keyboardType: TextInputType.number,
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
            final double price = double.tryParse(priceController.text) ?? 0.0;
            Navigator.of(context).pop();
            validationAction(name, price);
          },
          child: Text(validationText),
        ),
      ],
    ),
  );
}
