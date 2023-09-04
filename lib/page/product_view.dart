import 'package:flutter/material.dart';

class ProductViewPage extends StatefulWidget {
  final int shopId;
  final int productId;

  const ProductViewPage(
      {Key? key, required this.shopId, required this.productId})
      : super(key: key);

  @override
  ProductViewPageState createState() => ProductViewPageState();
}

class ProductViewPageState extends State<ProductViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produit'),
      ),
      body: Center(
        child: Text('Produit'),
      ),
    );
  }
}
