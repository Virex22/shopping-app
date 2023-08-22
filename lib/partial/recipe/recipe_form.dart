import 'package:flutter/material.dart';
import 'package:shopping_app/model/ingredient.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/model/step.dart' as step_model;
import 'package:shopping_app/partial/component/dialog/recipe_dialog.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? model;
  const RecipeForm({Key? key, this.model}) : super(key: key);

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final titleController = TextEditingController();
  final servingsController = TextEditingController();
  final List<Ingredient> ingredients = [];
  final List<step_model.Step> steps = [];

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      titleController.text = widget.model!.title;
      servingsController.text = widget.model!.servings.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
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
          const SizedBox(height: 20),
          const Text(
            'Liste des ingrédients de la recette :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        constraints: const BoxConstraints(minHeight: 210),
                        child: ingredients.isEmpty
                            ? const Center(child: Text('Aucun ingrédient'))
                            : ListView.builder(
                                itemCount: ingredients.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(ingredients[index].name),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showAddIngredientDialog(
                        context: context,
                        handleOnAddIngredient: (ingredient) {
                          setState(() {
                            ingredients.add(ingredient);
                          });
                        });
                  },
                  child: const Text('Ajouter un ingrédient'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Liste des étapes de la recette :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        constraints: const BoxConstraints(minHeight: 210),
                        child: steps.isEmpty
                            ? const Center(child: Text('Aucune étape'))
                            : ListView.builder(
                                itemCount: steps.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(steps[index].title),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showAddStepDialog(
                      context: context,
                      handleOnAddStep: (step) {
                        setState(() {
                          steps.add(step);
                        });
                      },
                      position: steps.length + 1,
                    );
                  },
                  child: const Text('Ajouter une étape'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Sauvegarder'),
            ),
          ),
        ],
      ),
    );
  }
}
