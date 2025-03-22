import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seafood_b2b_app/features/auth/login_screen.dart';
import 'package:seafood_b2b_app/features/home/home_screen.dart';
import 'package:seafood_b2b_app/features/catalog/screens/catalog_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter get config => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
        ],
      );
}
