import 'package:flutter/material.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/ingredient.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/model/step.dart' as step_model;
import 'package:shopping_app/partial/recipe/ingredient_product_selection.dart';

void showAddIngredientDialog({
  required BuildContext context,
  required Function(Ingredient ingredient) handleOnAddIngredient,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ajouter un ingrédient'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Choisissez le type d\'ingrédient à ajouter :'),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showAddCustomIngredientDialog(
                    context: context,
                    handleOnAddIngredient: handleOnAddIngredient,
                  );
                },
                child: const Text('Ingrédient personnalisé'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showAddProductIngredientDialog(
                    context: context,
                    handleOnAddIngredient: handleOnAddIngredient,
                  );
                },
                child: const Text('Ingrédient basé sur un produit'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void showAddCustomIngredientDialog({
  required BuildContext context,
  required Function(Ingredient ingredient) handleOnAddIngredient,
}) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String selectedQuantityType = 'unit';
  List<String> quantityTypes = ['unit', 'ml', 'L', 'cl', 'mg', 'g', 'kg'];
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ajouter un ingrédient personnalisé'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nom de l\'ingrédient',
            ),
          ),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantité de l\'ingrédient',
            ),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField(
            value: selectedQuantityType,
            onChanged: (value) {
              selectedQuantityType = value.toString();
            },
            items: quantityTypes
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
          TextField(
            controller: priceController,
            decoration: const InputDecoration(
              labelText: 'Prix de l\'ingrédient',
            ),
            keyboardType: TextInputType.number,
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
        TextButton(
          onPressed: () {
            final ingredient = Ingredient(
              id: -1,
              recipeURI: '',
              customName: nameController.text,
              quantity: double.parse(quantityController.text),
              customQuantityType: selectedQuantityType,
              customPrice: double.parse(priceController.text),
            );
            handleOnAddIngredient(ingredient);
            Navigator.of(context).pop();
          },
          child: const Text('Ajouter'),
        ),
      ],
    ),
  );
}

void showAddProductIngredientDialog({
  required BuildContext context,
  required Function(Ingredient ingredient) handleOnAddIngredient,
}) {
  Product? selectedProduct;
  double? selectedQuantity;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Ajouter un ingrédient basé sur un produit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IngredientProductSelection(
                onFormChange: ({Product? product, double? quantity}) {
              if (product != null) {
                selectedProduct = product;
              }
              if (quantity != null) {
                selectedQuantity = quantity;
              }
            })
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedProduct == null || selectedQuantity == null) {
                    final snackBar = ScaffoldMessenger.of(context);
                    showSnackBar(
                        snackBar: snackBar,
                        message:
                            'Veuillez sélectionner un produit et une quantité');
                    return;
                  }
                  final ingredient = Ingredient(
                      id: -1,
                      recipeURI: '',
                      product: selectedProduct,
                      quantity: selectedQuantity!);
                  handleOnAddIngredient(ingredient);
                  Navigator.of(context).pop();
                },
                child: const Text('Ajouter'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showAddRecipeDialog({
  required BuildContext context,
  required Function(String title, String servings) handleOnAddRecipe,
}) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ajouter une recette'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Titre de la recette',
            ),
          ),
          TextField(
            controller: servingsController,
            decoration: const InputDecoration(
              labelText: 'Nombre de personnes',
            ),
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
        TextButton(
          onPressed: () {
            final title = titleController.text;
            final servings = servingsController.text;
            handleOnAddRecipe(title, servings);
            Navigator.of(context).pop();
          },
          child: const Text('Ajouter'),
        ),
      ],
    ),
  );
}

void showAddStepDialog(
    {required BuildContext context,
    required Function(step_model.Step step) handleOnAddStep,
    required int position,
    int recipeId = -1,
    step_model.Step? model}) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  if (model != null) {
    titleController.text = model.title;
    instructionController.text = model.instruction;
  }
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ajouter une étape'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de l\'étape',
              ),
            ),
            TextField(
              controller: instructionController,
              decoration: const InputDecoration(
                labelText: 'Instruction de l\'étape',
              ),
              maxLines: null,
              minLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            final title = titleController.text;
            final instruction = instructionController.text;
            final step = step_model.Step(
              id: -1,
              title: title,
              instruction: instruction,
              position: position,
              recipeURI: Recipe.getIrifromId(recipeId),
            );
            handleOnAddStep(step);
            Navigator.of(context).pop();
          },
          child: const Text('Ajouter'),
        ),
      ],
    ),
  );
}
