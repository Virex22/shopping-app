import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/shopping_list_api.dart';
import 'package:shopping_app/helper/global_helper.dart';
import 'package:shopping_app/model/shopping_list.dart';
import 'package:shopping_app/partial/component/dialog/delete_dialog.dart';
import 'package:shopping_app/partial/component/dialog/shopping_list_dialog.dart';
import 'package:shopping_app/provider/shopping_list_provider.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;
  final Function onTap;

  const ShoppingListTile({
    Key? key,
    required this.shoppingList,
    required this.onTap,
  }) : super(key: key);

  void _deleteShoppingList(BuildContext context, ShoppingList shoppingList) {
    showDeleteDialog(
      context: context,
      subtitle: 'Êtes-vous sûr de vouloir supprimer cette liste de courses ?',
      handleOnDelete: () {
        ScaffoldMessengerState snackBar = ScaffoldMessenger.of(context);
        ShoppingListAPI api = ShoppingListAPI();
        api.deleteShoppingList(shoppingList.id).then((value) {
          ShoppingListProvider shoppingListProvider =
              context.read<ShoppingListProvider>();
          shoppingListProvider.removeShoppingList(shoppingList);
          showSnackBar(
              snackBar: snackBar,
              message: 'Liste de courses supprimée avec succès');
        });
      },
    );
  }

  void _editShoppingList(BuildContext context, ShoppingList shoppingList) {
    showShoppingListFormDialog(
        context: context,
        title: 'Modifier une liste de courses',
        validationText: 'Modifier',
        validationAction: (String name) async {
          if (name.isEmpty) {
            return;
          }
          ShoppingListProvider shoppingListProvider =
              context.read<ShoppingListProvider>();
          ShoppingListAPI api = ShoppingListAPI();
          final newShoppingList =
              await api.updateShoppingList(shoppingList.id, {'name': name});
          shoppingListProvider.updateShoppingList(newShoppingList);
        },
        shoppingListModel: shoppingList);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(shoppingList),
      title: Text(shoppingList.name),
      subtitle: Text('Créé le ${shoppingList.formattedDateAdd}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _deleteShoppingList(context, shoppingList);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
          IconButton(
            onPressed: () {
              _editShoppingList(context, shoppingList);
            },
            icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
          ),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}
