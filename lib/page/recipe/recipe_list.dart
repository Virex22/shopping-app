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
        actions: [
          IconButton(
            onPressed: () {
              recipeProvider.refreshRecipeListFromApi();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
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
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading:
                                                const Icon(Icons.edit_outlined),
                                            title: const Text('Modifier'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              context.go(
                                                  '/recipes/edit/${recipeProvider.recipes![index].id}');
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.delete_outline),
                                            title: const Text('Supprimer'),
                                            textColor: Colors.red,
                                            iconColor: Colors.red,
                                            onTap: () {
                                              Navigator.pop(context);
                                              recipeProvider.deleteRecipe(
                                                  recipeProvider
                                                      .recipes![index].id);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.more_vert),
                                tooltip: 'Voir la recette'),
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
