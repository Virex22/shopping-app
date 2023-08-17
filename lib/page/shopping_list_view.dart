import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/shopping_list_api.dart';
import 'package:shopping_app/api/shopping_list_item_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/shopping_list.dart';
import 'package:shopping_app/partial/component/dialog/delete_dialog.dart';
import 'package:shopping_app/partial/component/dialog/shopping_list_dialog.dart';
import 'package:shopping_app/partial/shopping_list/shopping_list_item_tile.dart';
import 'package:shopping_app/provider/shopping_list_provider.dart';

class ShoppingListView extends StatefulWidget {
  final int id;

  const ShoppingListView({Key? key, required this.id}) : super(key: key);

  @override
  ShoppingListViewState createState() => ShoppingListViewState();
}

class ShoppingListViewState extends State<ShoppingListView> {
  ShoppingListProvider get _shoppingListProvider =>
      context.read<ShoppingListProvider>();

  ShoppingList? get shoppingList => getShoppingList(null);
  double get total {
    if (shoppingList == null ||
        shoppingList!.items == null ||
        shoppingList!.items!.isEmpty) {
      return 0;
    }

    final totalPrices =
        shoppingList!.items!.map((e) => e.price * e.quantity).toList();
    return totalPrices.reduce((value, element) => value + element);
  }

  double get totalUnselected {
    if (shoppingList == null ||
        shoppingList!.items == null ||
        shoppingList!.items!.isEmpty) {
      return 0;
    }

    final uncompletedItems =
        shoppingList!.items!.where((element) => !element.isCompleted);
    if (uncompletedItems.isEmpty) {
      return 0;
    }

    final unselectedPrices = uncompletedItems.map((e) => e.price * e.quantity);
    return unselectedPrices.reduce((value, element) => value + element);
  }

  ShoppingList? getShoppingList(ShoppingListProvider? provider) {
    ShoppingListProvider usedProvider = provider ?? _shoppingListProvider;
    if (usedProvider.shoppingList == null) {
      return null;
    } else if (usedProvider.shoppingList!
        .where((element) => element.id == widget.id)
        .isEmpty) {
      return null;
    } else {
      return usedProvider.shoppingList!
          .firstWhere((element) => element.id == widget.id);
    }
  }

  void _refreshList() {
    ShoppingListAPI api = ShoppingListAPI();
    api.getShoppingList(widget.id).then((value) {
      _shoppingListProvider.updateShoppingList(value);
      showSnackBar(
          snackBar: ScaffoldMessenger.of(context),
          message: 'Liste de courses mise à jour avec succès');
    });
  }

  void _addItem() {
    showAddItemOnShoppingListDialog(
        context: context,
        addCustomItem: () {
          showCustomShoppingListItemFormDialog(
            context: context,
            title: 'Ajouter un produit personnalisé',
            validationText: 'Ajouter',
            validationAction: (name, price) {
              ShoppingListItemApi api = ShoppingListItemApi();
              api.addShoppingListItem({
                'customName': name,
                'customPrice': price,
                'quantity': 1,
                'isCompleted': false,
                'shoppingList': ShoppingList.getIrifromId(widget.id),
              }).then((value) {
                ShoppingListProvider shoppingListProvider =
                    context.read<ShoppingListProvider>();
                shoppingListProvider.addShoppingListItem(value, widget.id);
                showSnackBar(
                    snackBar: ScaffoldMessenger.of(context),
                    message: 'Produit ajouté avec succès');
              });
            },
          );
        },
        addExistingItem: () {
          context.go('/shops');
        });
  }

  void _deleteList() {
    if (shoppingList == null) {
      return;
    }
    showDeleteDialog(
      context: context,
      subtitle: 'Êtes-vous sûr de vouloir supprimer cette liste de courses ?',
      handleOnDelete: () {
        ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
        ShoppingListAPI api = ShoppingListAPI();
        api.deleteShoppingList(shoppingList!.id).then((value) {
          ShoppingListProvider shoppingListProvider =
              context.read<ShoppingListProvider>();
          shoppingListProvider.removeShoppingList(shoppingList!);
          showSnackBar(
              snackBar: snackBar,
              message: 'Liste de courses supprimée avec succès');
          Navigator.of(context).pop();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ShoppingListProvider shoppingListProvider =
        context.watch<ShoppingListProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            shoppingList == null ? 'Liste de courses' : shoppingList!.name),
        actions: [
          IconButton(
            onPressed: _refreshList,
            tooltip: 'Rafraîchir',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(top: 15, right: 5, bottom: 0, left: 5),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: shoppingList == null ||
                      shoppingList!.items == null ||
                      shoppingList!.items!.isEmpty
                  ? const Center(
                      child: Text('Aucun élément dans la liste'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          getShoppingList(shoppingListProvider)!.items!.length,
                      itemBuilder: (context, index) {
                        return ShoppingListItemTile(
                          item: getShoppingList(shoppingListProvider)!
                              .items![index],
                          listId: widget.id,
                        );
                      },
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Total : ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${total.toStringAsFixed(2)}€',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Total non sélectionné : ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${totalUnselected.toStringAsFixed(2)}€',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addItem();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.all(20),
                    minimumSize: const Size(120, 0),
                  ),
                  child: const Text('Ajouter un produit'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _deleteList();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.all(20),
                    minimumSize: const Size(150, 0),
                  ),
                  child: const Text('Supprimer la liste'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
