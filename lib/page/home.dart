import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              title: Text('Base de données',
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: const Text('Accéder à la base de données'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.dashboard_customize_sharp,
                      size: 30, color: Theme.of(context).primaryColor),
                  Container(width: 10),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                context.go('/shops');
              },
            ),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              title: Text('Liste de courses',
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: const Text('Accéder à la liste de courses'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart,
                      size: 30, color: Theme.of(context).primaryColor),
                  Container(width: 10),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                context.go('/shopping_list');
              },
            ),
          ),
          Card(
            elevation: 2,
            child: ListTile(
              title: Text('Recettes',
                  style: Theme.of(context).textTheme.titleLarge),
              subtitle: const Text('Accéder aux recettes'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.restaurant_menu,
                      size: 30, color: Theme.of(context).primaryColor),
                  Container(width: 10),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                context.go('/recipes');
              },
            ),
          ),
        ],
      ),
    );
  }
}
