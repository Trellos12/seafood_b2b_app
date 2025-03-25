import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';
import 'package:seafood_b2b_app/features/auth/login_screen.dart';
import 'package:seafood_b2b_app/features/home/home_screen.dart';
import 'package:seafood_b2b_app/features/catalog/screens/catalog_screen.dart';
import 'package:seafood_b2b_app/features/cart/screens/cart_screen.dart';
import 'package:seafood_b2b_app/features/cart/screens/order_confirmation_screen.dart';
import 'package:seafood_b2b_app/features/orders/screens/order_history_screen.dart'; // ✅ не забудь

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final GoRouter config;

  AppRouter(WidgetRef ref) {
    config = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) {
        final container = ProviderScope.containerOf(context, listen: false);
        final user = container.read(userProvider);

        final isLoggedIn = user != null;
        final goingToLogin = state.uri.path == '/';

        if (!isLoggedIn && !goingToLogin) {
          return '/';
        }

        if (isLoggedIn && goingToLogin) {
          return '/home';
        }

        return null;
      },
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
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/order-confirmation',
          builder: (context, state) => const OrderConfirmationScreen(),
        ),
        GoRoute(
          path: '/order-history', // ✅ исправлено с /orders на /order-history
          builder: (context, state) => const OrderHistoryScreen(),
        ),
      ],
    );
  }
}
