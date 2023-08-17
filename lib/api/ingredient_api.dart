import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/ingredient.dart';

class IngredientAPI extends AbstractAPI {
  Future<List<Ingredient>> getAllIngredients() async {
    final response = await get('/ingredients');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> ingredientList = data['hydra:member'];
    return ingredientList
        .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
        .toList();
  }

  Future<Ingredient> getIngredient(int id) async {
    final response = await get('/ingredients/$id');
    final data = response.data as Map<String, dynamic>;
    return Ingredient.fromJson(data);
  }

  Future<List<Ingredient>> getIngredientsByRecipeId(int recipeId) async {
    final response = await get('/ingredients?recipe=$recipeId');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> ingredientList = data['hydra:member'];
    return ingredientList
        .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
        .toList();
  }

  Future<Ingredient> addIngredient(Map<String, dynamic> ingredientData) async {
    final response = await post('/ingredients', ingredientData);
    final data = response.data as Map<String, dynamic>;
    return Ingredient.fromJson(data);
  }

  Future<bool> deleteIngredient(int id) async {
    final Response<dynamic> response = await delete('/ingredients/$id');
    return response.statusCode == 204;
  }

  Future<Ingredient> updateIngredient(
      int id, Map<String, dynamic> updatedData) async {
    final response = await put('/ingredients/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return Ingredient.fromJson(data);
  }
}
