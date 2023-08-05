import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/api/shopping_list_item_api.dart';
import 'package:shopping_app/model/shopping_list_item.dart';
import 'package:shopping_app/partial/component/dialog/delete_dialog.dart';
import 'package:shopping_app/provider/shopping_list_provider.dart';

class ShoppingListItemTile extends StatefulWidget {
  final ShoppingListItem item;
  final int listId;

  const ShoppingListItemTile(
      {super.key, required this.item, required this.listId});

  @override
  State<ShoppingListItemTile> createState() => _ShoppingListItemTileState();
}

class _ShoppingListItemTileState extends State<ShoppingListItemTile> {
  final ShoppingListItemApi api = ShoppingListItemApi();
  ShoppingListProvider get _shoppingListProvider =>
      context.read<ShoppingListProvider>();

  void _incrementQuantity() {
    setState(() {
      widget.item.quantity++;
    });
    api.updateShoppingListItem(
        widget.item.id, {'quantity': widget.item.quantity});
    _shoppingListProvider.updateShoppingListItem(widget.item, widget.listId);
  }

  void _decrementQuantity() {
    if (widget.item.quantity > 1) {
      setState(() {
        widget.item.quantity--;
      });
      api.updateShoppingListItem(
          widget.item.id, {'quantity': widget.item.quantity});
      _shoppingListProvider.updateShoppingListItem(widget.item, widget.listId);
    }
  }

  void _toggleCheck() {
    setState(() {
      widget.item.isCompleted = !widget.item.isCompleted;
    });
    api.updateShoppingListItem(
        widget.item.id, {'isCompleted': widget.item.isCompleted});
    _shoppingListProvider.updateShoppingListItem(widget.item, widget.listId);
  }

  bool _deleteItem(context) {
    showDeleteDialog(
        context: context,
        subtitle: 'Voulez-vous supprimer cet élément de la liste ?',
        handleOnDelete: () {
          api.deleteShoppingListItem(widget.item.id);
          _shoppingListProvider.deleteShoppingListItem(
              widget.item, widget.listId);
          return true;
        },
        handleOnCancel: () {
          return false;
        });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('shopping_list_item_${widget.item.id}'),
      confirmDismiss: (direction) async {
        return _deleteItem(context);
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      child: ListTile(
        leading: Checkbox(
          value: widget.item.isCompleted,
          onChanged: (value) => _toggleCheck(),
        ),
        title: Text(widget.item.name),
        subtitle: Text(
          '~${widget.item.price}€',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _decrementQuantity,
            ),
            Text('${widget.item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _incrementQuantity,
            ),
          ],
        ),
      ),
    );
  }
}
