import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/recipe.dart';

class RecipeApi extends AbstractAPI {
  Future<List<Recipe>> getAllRecipes() async {
    final response = await get('/recipes');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> recipeList = data['hydra:member'];
    return recipeList.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
  }

  Future<Recipe> getRecipe(int id) async {
    final response = await get('/recipes/$id');
    final data = response.data as Map<String, dynamic>;
    return Recipe.fromJson(data);
  }

  Future<List<Recipe>> getRecipesByShopId(int shopId) async {
    final response = await get('/recipes?shop=$shopId');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> recipeList = data['hydra:member'];
    return recipeList.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
  }

  Future<Recipe> addRecipe(Map<String, dynamic> recipeData) async {
    final response = await post('/recipes', recipeData);
    final data = response.data as Map<String, dynamic>;
    return Recipe.fromJson(data);
  }

  Future<bool> deleteRecipe(int id) async {
    final Response<dynamic> response = await delete('/recipes/$id');
    return response.statusCode == 204;
  }

  Future<Recipe> updateRecipe(int id, Map<String, dynamic> updatedData) async {
    final response = await put('/recipes/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return Recipe.fromJson(data);
  }
}
