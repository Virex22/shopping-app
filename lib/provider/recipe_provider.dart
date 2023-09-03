import 'package:flutter/material.dart';
import 'package:shopping_app/api/recipe_api.dart';
import 'package:shopping_app/model/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe>? _recipes;

  List<Recipe>? get recipes =>
      _recipes == null ? null : List.unmodifiable(_recipes!);

  addRecipe(Recipe recipe) {
    _recipes!.add(recipe);
    notifyListeners();
  }

  removeRecipe(int recipeId) {
    _recipes!.removeWhere((element) => element.id == recipeId);
    notifyListeners();
  }

  updateRecipe(Recipe recipe) {
    int index = _recipes!.indexWhere((element) => element.id == recipe.id);
    _recipes![index] = recipe;
    notifyListeners();
  }

  refreshRecipeListFromApi() async {
    RecipeApi api = RecipeApi();
    List<Recipe> recipes = await api.getAllRecipes();
    _recipes ??= [];
    _recipes!.clear();
    _recipes!.addAll(recipes);
    notifyListeners();
  }

  deleteRecipe(int recipeId) async {
    RecipeApi api = RecipeApi();
    await api.deleteRecipe(recipeId);
    removeRecipe(recipeId);
  }
}
