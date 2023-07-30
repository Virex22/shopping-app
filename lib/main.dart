import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/product_provider.dart';
import 'package:shopping_app/provider/shopping_list_provider.dart';
import 'package:shopping_app/router/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.local");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(primarySwatch: Colors.blue));
  }
}
