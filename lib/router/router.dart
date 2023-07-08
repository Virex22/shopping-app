import 'package:go_router/go_router.dart';
import 'package:shopping_app/page/error.dart';
import 'package:shopping_app/page/home.dart';
import 'package:shopping_app/page/shop_list.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, routeurState) => const HomePage(),
        routes: [
          GoRoute(
            path: 'shops',
            builder: (context, routeurState) => const ShopListPage(),
          ),
        ]),
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);
