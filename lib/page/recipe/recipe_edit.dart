import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/partial/recipe/recipe_form.dart';
import 'package:shopping_app/provider/recipe_provider.dart';

class RecipeEditPage extends StatefulWidget {
  final int id;
  const RecipeEditPage({Key? key, required this.id}) : super(key: key);

  @override
  RecipeEditPageState createState() => RecipeEditPageState();
}

class RecipeEditPageState extends State<RecipeEditPage> {
  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = context.watch<RecipeProvider>();
    if (recipeProvider.recipes == null) {
      recipeProvider.refreshRecipeListFromApi();
      return const Center(child: CircularProgressIndicator());
    }
    Recipe? recipe = recipeProvider.recipes
        ?.firstWhere((element) => element.id == widget.id);
    if (recipe == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('La recette n\'existe pas'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retour')),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier une recette'),
      ),
      body: RecipeForm(
        model: recipe,
      ),
    );
  }
}
