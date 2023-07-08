import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, routeurState) => const Home(),
        routes: [
          GoRoute(
            path: 'favorites',
            builder: (context, routeurState) => const BachelorFavorites(),
          ),
        ]),
  ],
  errorPageBuilder: (context, state) => const ErrorPage(),
);
