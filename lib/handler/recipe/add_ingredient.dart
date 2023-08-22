import 'package:shopping_app/model/ingredient.dart';
import 'package:shopping_app/model/step.dart' as step_model;

class AddIngredientHandler {
  static void addIngredient({
    required String title,
    required String servingsCount,
    required List<Ingredient> ingredients,
    required List<step_model.Step> steps,
  }) {
    print('Add ingredient');
  }
}
