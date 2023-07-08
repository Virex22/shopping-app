import 'package:flutter/material.dart';

class ShopListPage extends StatelessWidget {
  const ShopListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des magasins'),
      ),
      body: const Center(
        child: Text('Contenu de la page liste des magasins'),
      ),
    );
  }
}
