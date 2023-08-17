import 'package:dio/dio.dart';
import 'package:shopping_app/api/abstract_api.dart';
import 'package:shopping_app/model/step.dart';

class StepAPI extends AbstractAPI {
  Future<List<Step>> getAllSteps() async {
    final response = await get('/steps');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> stepList = data['hydra:member'];
    return stepList.map((stepJson) => Step.fromJson(stepJson)).toList();
  }

  Future<Step> getStep(int id) async {
    final response = await get('/steps/$id');
    final data = response.data as Map<String, dynamic>;
    return Step.fromJson(data);
  }

  Future<List<Step>> getStepsByRecipeId(int recipeId) async {
    final response = await get('/steps?recipe=$recipeId');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> stepList = data['hydra:member'];
    return stepList.map((stepJson) => Step.fromJson(stepJson)).toList();
  }

  Future<Step> addStep(Map<String, dynamic> stepData) async {
    final response = await post('/steps', stepData);
    final data = response.data as Map<String, dynamic>;
    return Step.fromJson(data);
  }

  Future<bool> deleteStep(int id) async {
    final Response<dynamic> response = await delete('/steps/$id');
    return response.statusCode == 204;
  }

  Future<Step> updateStep(int id, Map<String, dynamic> updatedData) async {
    final response = await put('/steps/$id', updatedData);
    final data = response.data as Map<String, dynamic>;
    return Step.fromJson(data);
  }
}
