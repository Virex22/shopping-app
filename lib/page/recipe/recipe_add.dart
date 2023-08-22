import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/recipe_api.dart';
import 'package:shopping_app/partial/recipe/recipe_form.dart';
import 'package:shopping_app/provider/recipe_provider.dart';

class RecipeAddPage extends StatefulWidget {
  const RecipeAddPage({Key? key}) : super(key: key);

  @override
  RecipeAddPageState createState() => RecipeAddPageState();
}

class RecipeAddPageState extends State<RecipeAddPage> {
  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = context.watch<RecipeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une recette'),
      ),
      body: const RecipeForm(),
    );
  }
}
