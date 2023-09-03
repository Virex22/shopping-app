import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/handler/recipe/recipe_handler.dart';
import 'package:shopping_app/model/ingredient.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/model/step.dart' as step_model;
import 'package:shopping_app/partial/component/dialog/recipe_dialog.dart';
import 'package:shopping_app/provider/recipe_provider.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? model;
  const RecipeForm({Key? key, this.model}) : super(key: key);

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final titleController = TextEditingController();
  final servingsController = TextEditingController();
  final timeController = TextEditingController();
  final List<Ingredient> ingredients = [];
  final List<step_model.Step> steps = [];

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      titleController.text = widget.model!.title;
      servingsController.text = widget.model!.servings.toString();
      timeController.text = widget.model!.time
          .difference(DateTime.fromMillisecondsSinceEpoch(0))
          .inMinutes
          .toString();
      ingredients.addAll(widget.model!.ingredients);
      steps.addAll(widget.model!.steps);
    }
  }

  @override
  Widget build(BuildContext globalContext) {
    RecipeProvider recipeProvider = context.read<RecipeProvider>();
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
          TextField(
            controller: timeController,
            decoration: const InputDecoration(
              labelText: 'Temps de préparation (en minutes)',
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
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: globalContext,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.delete_outline),
                                                    title:
                                                        const Text('Supprimer'),
                                                    textColor: Colors.red,
                                                    iconColor: Colors.red,
                                                    onTap: () {
                                                      setState(() {
                                                        ingredients
                                                            .removeAt(index);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
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
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: globalContext,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.edit_outlined),
                                                    title:
                                                        const Text('Modifier'),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      showAddStepDialog(
                                                        context: context,
                                                        handleOnAddStep:
                                                            (step) {
                                                          setState(() {
                                                            steps[index] = step;
                                                          });
                                                        },
                                                        position: index + 1,
                                                        model: steps[index],
                                                      );
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.delete_outline),
                                                    title:
                                                        const Text('Supprimer'),
                                                    textColor: Colors.red,
                                                    iconColor: Colors.red,
                                                    onTap: () {
                                                      setState(() {
                                                        steps.removeAt(index);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
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
              onPressed: () async {
                try {
                  RecipeHandler.validateRecipe(
                    title: titleController.text,
                    servingsCount: servingsController.text,
                    ingredients: ingredients,
                    steps: steps,
                    time: timeController.text,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                  return;
                }
                if (widget.model == null) {
                  NavigatorState navigator = Navigator.of(context);
                  Recipe recipe = await RecipeHandler.addRecipe(
                    title: titleController.text,
                    servingsCount: int.parse(servingsController.text),
                    ingredients: ingredients,
                    steps: steps,
                    time: timeController.text,
                  );
                  recipeProvider.addRecipe(recipe);
                  navigator.pop();
                } else {
                  NavigatorState navigator = Navigator.of(context);
                  Recipe recipe = await RecipeHandler.updateRecipe(
                    title: titleController.text,
                    servingsCount: int.parse(servingsController.text),
                    ingredients: ingredients,
                    steps: steps,
                    time: timeController.text,
                    initRecipe: widget.model!,
                  );
                  recipeProvider.updateRecipe(recipe);
                  navigator.pop();
                }
              },
              child: const Text('Sauvegarder'),
            ),
          ),
        ],
      ),
    );
  }
}
