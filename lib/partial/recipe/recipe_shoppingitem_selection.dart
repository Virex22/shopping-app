import 'package:flutter/material.dart';
import 'package:shopping_app/model/shopping_list_item.dart';

class RecipeShoppingItemSelection extends StatefulWidget {
  final Function({List<ShoppingListItem> shoppingListItems}) onFormChange;
  final List<ShoppingListItem> shoppingListItems;

  const RecipeShoppingItemSelection(
      {Key? key, required this.onFormChange, required this.shoppingListItems})
      : super(key: key);

  @override
  RecipeShoppingItemSelectionState createState() =>
      RecipeShoppingItemSelectionState();
}

class RecipeShoppingItemSelectionState
    extends State<RecipeShoppingItemSelection> {
  List<ShoppingListItem> shoppingListItems = [];

  @override
  void initState() {
    super.initState();
    // make all isCompleted to true
    shoppingListItems = widget.shoppingListItems.map((e) {
      e.isCompleted = true;
      return e;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            child: ListView.builder(
              itemCount: widget.shoppingListItems.length,
              itemBuilder: (context, index) {
                ShoppingListItem item = widget.shoppingListItems[index];
                return ListTile(
                  leading: Checkbox(
                    value: item.isCompleted,
                    onChanged: (value) => setState(() {
                      item.isCompleted = value!;
                    }),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    '~${item.price}€',
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              item.quantity--;
                            });
                          }),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            item.quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onFormChange(shoppingListItems: shoppingListItems);
              },
              child: const Text('Valider et ajouter à la liste'),
            ),
          ),
        ],
      ),
    );
  }
}
