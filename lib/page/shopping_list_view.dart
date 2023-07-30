import 'package:flutter/material.dart';

class ShoppingListView extends StatefulWidget {
  final int id;

  const ShoppingListView({Key? key, required this.id}) : super(key: key);

  @override
  ShoppingListViewState createState() => ShoppingListViewState();
}

class ShoppingListViewState extends State<ShoppingListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Center(
        child: Text('Shopping List ${widget.id}'),
      ),
    );
  }
}
