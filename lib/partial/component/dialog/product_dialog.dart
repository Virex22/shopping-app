import 'package:flutter/material.dart';
import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/product.dart';

void showProductFormDialog({
  required BuildContext context,
  required String title,
  required String validationText,
  required Function(
          String name, double price, double quantity, String quantityType)
      validationAction,
  String annulationText = 'Annuler',
  Product? productModel,
}) {
  List<String> quantityTypes = ['unit', 'ml', 'L', 'mg', 'g', 'kg'];
  late String selectedQuantityType;
  final TextEditingController nameController =
      TextEditingController(text: productModel?.name);
  final TextEditingController priceController =
      TextEditingController(text: productModel?.price.toString());
  final TextEditingController quantityController = TextEditingController();
  if (productModel != null) {
    quantityController.text =
        QuantityHelper.getQuantityValue(productModel).toString();
    selectedQuantityType = QuantityHelper.getQuantityVariation(productModel);
    if (selectedQuantityType == 'l') selectedQuantityType = 'L';
  } else {
    selectedQuantityType = 'unit';
  }
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
          TextField(
            decoration: const InputDecoration(labelText: 'Quantité du produit'),
            controller: quantityController,
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            value: selectedQuantityType,
            decoration: const InputDecoration(labelText: 'Type de quantité'),
            onChanged: (String? newValue) {
              selectedQuantityType = newValue ?? 'unit';
            },
            items: quantityTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
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
            final double quantity =
                double.tryParse(quantityController.text) ?? 1.0;
            Navigator.of(context).pop();
            validationAction(
                name,
                price,
                QuantityHelper.pharseQuantity(quantity, selectedQuantityType),
                QuantityHelper.getQuantityType(selectedQuantityType));
          },
          child: Text(validationText),
        ),
      ],
    ),
  );
}
