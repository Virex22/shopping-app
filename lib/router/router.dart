import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/page/error.dart';
import 'package:shopping_app/page/home.dart';
import 'package:shopping_app/page/product_list.dart';
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
            GoRoute(
              path: 'products/:shopId',
              builder: (context, routeurState) => ProductListPage(
                  shopId: int.parse(routeurState.pathParameters['shopId']!)),
            ),
          ]),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
    observers: [NavigatorObserver()]);
