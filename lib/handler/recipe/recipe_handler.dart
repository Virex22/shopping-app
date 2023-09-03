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
    int minutes = int.parse(time);
    DateTime epochTime = DateTime.fromMillisecondsSinceEpoch(0);
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
    recipe.ingredients = ingredients;
    recipe.steps = steps;
    return recipe;
  }

  static Future<Recipe> updateRecipe(
      {required String title,
      required int servingsCount,
      required List<Ingredient> ingredients,
      required List<step_model.Step> steps,
      required String time,
      required Recipe initRecipe}) async {
    int minutes = int.parse(time);
    DateTime epochTime = DateTime.fromMillisecondsSinceEpoch(0);
    DateTime formatedTime = epochTime.add(Duration(minutes: minutes));
    RecipeApi recipeApi = RecipeApi();
    Recipe recipe = await recipeApi.updateRecipe(initRecipe.id, {
      'title': title,
      'servings': servingsCount,
      'time': formatedTime.toIso8601String(),
    });
    deleteIngredientIfIsDeleted(initRecipe.ingredients, ingredients);
    deleteStepIfIsDeleted(initRecipe.steps, steps);
    for (Ingredient ingredient in ingredients) {
      IngredientAPI ingredientAPI = IngredientAPI();
      if (ingredient.customName != null) {
        if (ingredient.id > 0) {
          ingredientAPI.updateIngredient(ingredient.id, {
            'customName': ingredient.customName!,
            'customPrice': ingredient.customPrice!.toString(),
            'quantity': ingredient.quantity.toString(),
            'customQuantityType': ingredient.customQuantityType,
            'recipe': Recipe.getIrifromId(recipe.id),
          });
        } else {
          ingredientAPI.addIngredient({
            'customName': ingredient.customName!,
            'customPrice': ingredient.customPrice!.toString(),
            'quantity': ingredient.quantity.toString(),
            'customQuantityType': ingredient.customQuantityType,
            'recipe': Recipe.getIrifromId(recipe.id),
          });
        }
      } else {
        if (ingredient.id > 0) {
          ingredientAPI.updateIngredient(ingredient.id, {
            'product': Product.getIrifromId(ingredient.product!.id),
            'quantity': ingredient.quantity.toString(),
            'recipe': Recipe.getIrifromId(recipe.id),
          });
        } else {
          ingredientAPI.addIngredient({
            'product': Product.getIrifromId(ingredient.product!.id),
            'quantity': ingredient.quantity.toString(),
            'recipe': Recipe.getIrifromId(recipe.id),
          });
        }
      }
    }
    for (step_model.Step step in steps) {
      StepAPI stepAPI = StepAPI();
      if (step.id > 0) {
        stepAPI.updateStep(step.id, {
          'instruction': step.instruction,
          'title': step.title,
          'position': step.position,
          'recipe': Recipe.getIrifromId(recipe.id),
        });
      } else {
        stepAPI.addStep({
          'instruction': step.instruction,
          'title': step.title,
          'position': step.position,
          'recipe': Recipe.getIrifromId(recipe.id),
        });
      }
    }
    recipe.ingredients = ingredients;
    recipe.steps = steps;
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

  static void deleteIngredientIfIsDeleted(
      List<Ingredient> initIngredients, List<Ingredient> ingredients) {
    for (Ingredient initIngredient in initIngredients) {
      if (!ingredients.any((element) => element.id == initIngredient.id)) {
        IngredientAPI ingredientAPI = IngredientAPI();
        ingredientAPI.deleteIngredient(initIngredient.id);
      }
    }
  }

  static void deleteStepIfIsDeleted(
      List<step_model.Step> initSteps, List<step_model.Step> steps) {
    for (step_model.Step initStep in initSteps) {
      if (!steps.any((element) => element.id == initStep.id)) {
        StepAPI stepAPI = StepAPI();
        stepAPI.deleteStep(initStep.id);
      }
    }
  }
}
