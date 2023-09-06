import 'package:shopping_app/helper/quantity_helper.dart';
import 'package:shopping_app/model/ingredient.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/model/shopping_list_item.dart';

class RecipeHelper {
  static List<ShoppingListItem> getShoppingListItemsFromRecipe(Recipe recipe) {
    List<Ingredient> ingredients = recipe.ingredients;
    List<ShoppingListItem> shoppingListItemsFromRecipe = [];
    for (Ingredient ingredient in ingredients) {
      shoppingListItemsFromRecipe
          .add(_getShoppingListItemFromIngredient(ingredient));
    }
    return shoppingListItemsFromRecipe;
  }

  static ShoppingListItem _getShoppingListItemFromIngredient(
      Ingredient ingredient) {
    if (ingredient.isCustom) {
      return ShoppingListItem(
        id: -1,
        isCompleted: false,
        product: null,
        customName:
            "${ingredient.name} (${QuantityHelper.getQuantityValue(ingredient.customQuantityType!, ingredient.quantity)}${ingredient.quantityVariation})",
        customPrice: ingredient.price,
        quantity: 1,
      );
    } else {
      Product product = ingredient.product!;
      int productCount = (ingredient.quantity / product.quantity).ceil();
      return ShoppingListItem(
        id: -1,
        isCompleted: false,
        product: product,
        quantity: productCount,
      );
    }
  }
}
