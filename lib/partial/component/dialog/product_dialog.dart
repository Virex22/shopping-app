import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/shopping_list.dart';
import 'package:shopping_app/provider/shopping_list_provider.dart';

void showProductFormDialog({
  required BuildContext context,
  required String title,
  required String validationText,
  required Function(
          String name, double price, double quantity, String quantityType)
      validationAction,
  String annulationText = 'Annuler',
  bool onlyPrice = false,
  Product? productModel,
}) {
  List<String> quantityTypes = ['unit', 'ml', 'L', 'cl', 'mg', 'g', 'kg'];
  late String selectedQuantityType;
  final TextEditingController nameController =
      TextEditingController(text: productModel?.name);
  final TextEditingController priceController =
      TextEditingController(text: productModel?.price.toString());
  final TextEditingController quantityController = TextEditingController();

  if (productModel != null) {
    quantityController.text = QuantityHelper.getQuantityValue(
            productModel.quantityType, productModel.quantity)
        .toString();
    selectedQuantityType = QuantityHelper.getQuantityVariation(
        productModel.quantityType, productModel.quantity);
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
          Visibility(
            visible: !onlyPrice,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Nom du produit'),
              controller: nameController,
            ),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Prix du produit'),
            controller: priceController,
            autofocus: onlyPrice,
            keyboardType: TextInputType.number,
          ),
          Visibility(
            visible: !onlyPrice,
            child: TextField(
              decoration:
                  const InputDecoration(labelText: 'Quantité du produit'),
              controller: quantityController,
              keyboardType: TextInputType.number,
            ),
          ),
          Visibility(
            visible: !onlyPrice,
            child: DropdownButtonFormField<String>(
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

void showProductAddToListDialog({
  required BuildContext context,
  required Product product,
  required Function(int listId) handleOnAddToList,
}) async {
  ShoppingListProvider shoppingListProvider =
      Provider.of<ShoppingListProvider>(context, listen: false);
  List<ShoppingList>? shoppingLists = shoppingListProvider.shoppingList;
  if (shoppingLists == null || shoppingLists.isEmpty) {
    shoppingListProvider.fetchAllShoppingListFromApi().then((value) {
      _showProductAddDialogPart(
        context: context,
        product: product,
        handleOnAddToList: handleOnAddToList,
        shoppingLists: value,
      );
    });
  } else {
    _showProductAddDialogPart(
      context: context,
      product: product,
      handleOnAddToList: handleOnAddToList,
      shoppingLists: shoppingLists,
    );
  }
}

void _showProductAddDialogPart({
  required BuildContext context,
  required Product product,
  required Function(int listId) handleOnAddToList,
  required List<ShoppingList> shoppingLists,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ajouter à une liste'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: shoppingLists.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(shoppingLists[index].name),
              onTap: () {
                Navigator.of(context).pop();
                handleOnAddToList(shoppingLists[index].id);
              },
            );
          },
        ),
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
