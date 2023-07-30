import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/shopping_list_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/partial/component/dialog/shopping_list_dialog.dart';
import 'package:shopping_app/partial/shopping_list/shopping_list_tile.dart';
import 'package:shopping_app/provider/shopping_list_provider.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  ShoppingListProvider get _shoppingListProvider =>
      context.read<ShoppingListProvider>();

  void _addShoppingList(BuildContext context) {
    showShoppingListFormDialog(
        context: context,
        title: 'Ajouter une liste de courses',
        validationText: 'Ajouter',
        validationAction: (String name) async {
          if (name.isEmpty) {
            return;
          }
          ShoppingListAPI api = ShoppingListAPI();
          final newShoppingList = await api.addShoppingList({'name': name});
          _shoppingListProvider.addShoppingList(newShoppingList);
        });
  }

  @override
  void initState() {
    super.initState();
    _shoppingListProvider.refreshSoppingListFromApi();
  }

  @override
  Widget build(BuildContext context) {
    ShoppingListProvider shoppingListProvider =
        context.watch<ShoppingListProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de courses'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  ScaffoldMessengerState snackBar =
                      ScaffoldMessenger.of(context);
                  shoppingListProvider.refreshSoppingListFromApi();
                  showSnackBar(
                      snackBar: snackBar,
                      message: 'Liste des courses mise à jour');
                },
                tooltip: 'Rafraîchir',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
      body: shoppingListProvider.shoppingList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : shoppingListProvider.shoppingList!.isEmpty
              ? const Center(
                  child:
                      Text('Aucune liste de courses, veuillez en ajouter une'))
              : ListView.builder(
                  itemCount: shoppingListProvider.shoppingList!.length,
                  itemBuilder: (context, index) {
                    return ShoppingListTile(
                      shoppingList: shoppingListProvider.shoppingList![index],
                      onTap: (shoppingList) {
                        context.go('/shoppingList/${shoppingList.id}');
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addShoppingList(context);
        },
        tooltip: 'Ajouter un produit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
