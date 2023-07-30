import 'package:flutter/material.dart';
import 'package:shopping_app/model/shopping_list.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;
  final Function onTap;

  const ShoppingListTile({
    Key? key,
    required this.shoppingList,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(shoppingList),
      title: Text(shoppingList.name),
      subtitle: Text('Créé le ${shoppingList.formattedDateAdd}'),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}
