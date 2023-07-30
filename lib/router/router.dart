import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/page/error.dart';
import 'package:shopping_app/page/home.dart';
import 'package:shopping_app/page/product_list.dart';
import 'package:shopping_app/page/shop_list.dart';
import 'package:shopping_app/page/shopping_list.dart';
import 'package:shopping_app/page/shopping_list_view.dart';

final router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, routeurState) => const HomePage(),
          routes: [
            GoRoute(
                path: 'shops',
                builder: (context, routeurState) => const ShopListPage(),
                routes: [
                  GoRoute(
                    path: ':shopId/products',
                    builder: (context, routeurState) => ProductListPage(
                        shopId:
                            int.parse(routeurState.pathParameters['shopId']!)),
                  ),
                ]),
            GoRoute(
                path: 'shopping_list',
                builder: (context, routeurState) => const ShoppingListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, routeurState) => ShoppingListView(
                        id: int.parse(routeurState.pathParameters['id']!)),
                  ),
                ]),
          ]),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
    observers: [NavigatorObserver()]);
