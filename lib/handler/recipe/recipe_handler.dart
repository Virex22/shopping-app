import 'package:shopping_app/api/ingredient_api.dart';
import 'package:shopping_app/api/recipe_api.dart';
import 'package:shopping_app/api/step_api.dart';
import 'package:shopping_app/model/ingredient.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/model/step.dart' as step_model;

class RecipeHandler {
  static Future<Recipe> addRecipe({
    required String title,
    required int servingsCount,
    required List<Ingredient> ingredients,
    required List<step_model.Step> steps,
    required String time,
  }) async {
    int minutes = 20;
  DateTime epochTime = DateTime.fromMillisecondsSinceEpoch(0); // 1er janvier 1970
  DateTime formatedTime = epochTime.add(Duration(minutes: minutes));
    RecipeApi recipeApi = RecipeApi();
    Recipe recipe = await recipeApi.addRecipe({
      'title': title,
      'servings': servingsCount,
      'time': formatedTime.toIso8601String(),
    });
    for (Ingredient ingredient in ingredients) {
      IngredientAPI ingredientAPI = IngredientAPI();
      if (ingredient.customName != null) {
        ingredientAPI.addIngredient({
          'customName': ingredient.customName!,
          'customPrice': ingredient.customPrice!.toString(),
          'quantity': ingredient.quantity.toString(),
          'customQuantityType': ingredient.customQuantityType,
          'recipe': Recipe.getIrifromId(recipe.id),
        });
      } else {
        ingredientAPI.addIngredient({
          'product': Product.getIrifromId(ingredient.product!.id),
          'quantity': ingredient.quantity.toString(),
          'customQuantityType': ingredient.customQuantityType,
          'recipe': Recipe.getIrifromId(recipe.id),
        });
      }
    }
    for (step_model.Step step in steps) {
      StepAPI stepAPI = StepAPI();
      stepAPI.addStep({
        'instruction': step.instruction,
        'title': step.title,
        'position': step.position,
        'recipe': Recipe.getIrifromId(recipe.id),
      });
    }
    return recipe;
  }

  static void validateRecipe({
    required String title,
    required String servingsCount,
    required List<Ingredient> ingredients,
    required List<step_model.Step> steps,
    required String time,
  }) {
    if (title.isEmpty) {
      throw Exception('Le titre de la recette ne peut pas être vide.');
    }
    if (servingsCount.isEmpty) {
      throw Exception('Le nombre de personnes ne peut pas être vide.');
    }
    if (ingredients.isEmpty) {
      throw Exception('La liste des ingrédients ne peut pas être vide.');
    }
    if (steps.isEmpty) {
      throw Exception('La liste des étapes ne peut pas être vide.');
    }
    if (time.isEmpty) {
      throw Exception('Le temps de préparation ne peut pas être vide.');
    }
    if (int.tryParse(servingsCount) == null) {
      throw Exception('Le nombre de personnes doit être un nombre.');
    }
    if (int.tryParse(time) == null) {
      throw Exception('Le temps de préparation doit être un nombre.');
    }
    if (int.tryParse(servingsCount)! <= 0) {
      throw Exception('Le nombre de personnes doit être supérieur à 0.');
    }
    if (int.tryParse(time)! <= 0) {
      throw Exception('Le temps de préparation doit être supérieur à 0.');
    }
  }
}
