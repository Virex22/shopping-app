import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/recipe_provider.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  RecipeListPageState createState() => RecipeListPageState();
}

class RecipeListPageState extends State<RecipeListPage> {
  late RecipeProvider _recipeProvider;

  @override
  void initState() {
    super.initState();
    _recipeProvider = context.read<RecipeProvider>();
    _recipeProvider.refreshRecipeListFromApi();
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = context.watch<RecipeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recettes'),
      ),
      body: recipeProvider.recipes == null
          ? const Center(child: CircularProgressIndicator())
          : recipeProvider.recipes!.isEmpty
              ? const Center(child: Text('Vous n\'avez créé aucune recette'))
              : ListView.builder(
                  itemCount: recipeProvider.recipes!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(recipeProvider.recipes![index].title,
                            style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Text(
                            'Nombre de personnes : ${recipeProvider.recipes![index].servings}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restaurant,
                                size: 30,
                                color: Theme.of(context).primaryColor),
                            Container(width: 10),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        onTap: () {
                          context.go(
                              '/recipe/${recipeProvider.recipes![index].id}');
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/recipes/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
