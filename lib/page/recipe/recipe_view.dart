import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/handler/recipe/recipe_handler.dart';
import 'package:shopping_app/helper/recipe_helper.dart';
import 'package:shopping_app/model/recipe.dart';
import 'package:shopping_app/model/shopping_list_item.dart';
import 'package:shopping_app/model/step.dart' as step_model;
import 'package:shopping_app/partial/component/dialog/recipe_dialog.dart';
import 'package:shopping_app/provider/recipe_provider.dart';

class RecipeView extends StatefulWidget {
  final int id;
  const RecipeView({Key? key, required this.id}) : super(key: key);

  @override
  RecipeViewState createState() => RecipeViewState();
}

class RecipeViewState extends State<RecipeView> {
  String calculatePreparationTime(DateTime preparationTime) {
    final difference =
        preparationTime.difference(DateTime.fromMillisecondsSinceEpoch(0));
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    if (hours == 0) {
      return '$minutes min';
    }
    return '$hours h $minutes min';
  }

  double getMaxCardHeight(List<step_model.Step> steps) {
    double maxHeight = 0.0;
    for (final step in steps) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: step.instruction,
          style: const TextStyle(fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
      final stepHeight = textPainter.height;
      if (stepHeight > maxHeight) {
        maxHeight = stepHeight;
      }
    }
    return maxHeight // for instruction
        +
        193 // for title and step number
        +
        16 // for padding
        +
        16; // for margin
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = context.watch<RecipeProvider>();
    if (recipeProvider.recipes == null) {
      recipeProvider.refreshRecipeListFromApi();
      return const Center(child: CircularProgressIndicator());
    }
    Recipe? recipe = recipeProvider.recipes
        ?.firstWhere((element) => element.id == widget.id);
    if (recipe == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('La recette n\'existe pas'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retour'),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header de la recette
            SizedBox(
              height: 150,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Carte pour le nombre de personnes
                    _buildInfoCard(
                      icon: Icons.people,
                      label: 'Personnes',
                      value: recipe.servings.toString(),
                    ),
                    // Carte pour le temps de préparation
                    _buildInfoCard(
                      icon: Icons.access_time,
                      label: 'Préparation',
                      value: calculatePreparationTime(recipe.time),
                      bigger: true,
                    ),
                    // Carte pour le coût par personne
                    _buildInfoCard(
                      icon: Icons.attach_money,
                      label: 'Coût/personne',
                      value: '${recipe.pricePerServing.toStringAsFixed(2)} €',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            // Liste des ingrédients de la recette
            SizedBox(
              width:
                  double.infinity, // Pour occuper toute la largeur de l'écran
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title
                    const Text(
                      'Ingrédients',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8), // Espacement entre les éléments
                    for (final ingredient in recipe.ingredients)
                      ListTile(
                        title: Text(
                          " • ${ingredient.name}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${ingredient.price.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        trailing: Text(
                          "${ingredient.quantityValue} ${ingredient.quantityVariation == "unit" ? "" : ingredient.quantityVariation} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Étapes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Taille de la police
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    // Slider pour sélectionner chaque étape
                    CarouselSlider.builder(
                      itemCount: recipe.steps.length,
                      itemBuilder: (context, index, realIndex) {
                        final step = recipe.steps[index];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Étape ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Center(
                                child: Text(
                                  step.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                step.instruction,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: getMaxCardHeight(recipe.steps),
                        enableInfiniteScroll: false,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Retour'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showRecipeAddDialog(
                      context: context,
                      handleOnAddToList: (shoppingList) {
                        showRecipeShoppingListAddDialog(
                          context: context,
                          shoppingListItems:
                              RecipeHelper.getShoppingListItemsFromRecipe(
                            recipe,
                          ),
                          handleOnAddToList: (List<ShoppingListItem> items) {
                            RecipeHandler.persistRecipeShoppingListItem(
                                items, shoppingList);
                          },
                        );
                      },
                    );
                  },
                  child: const Text('Ajouter les ingrédients à une liste'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    bool bigger = false,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: bigger ? 100 : 80,
          height: bigger ? 100 : 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
