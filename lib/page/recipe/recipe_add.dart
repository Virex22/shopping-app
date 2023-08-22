import 'package:flutter/material.dart';
import 'package:shopping_app/partial/recipe/recipe_form.dart';

class RecipeAddPage extends StatefulWidget {
  const RecipeAddPage({Key? key}) : super(key: key);

  @override
  RecipeAddPageState createState() => RecipeAddPageState();
}

class RecipeAddPageState extends State<RecipeAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une recette'),
      ),
      body: const RecipeForm(),
    );
  }
}
