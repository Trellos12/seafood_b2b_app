import 'dart:async'; // 👈 обязательно для StreamSubscription
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';
import 'package:seafood_b2b_app/features/auth/login_screen.dart';
import 'package:seafood_b2b_app/features/home/home_screen.dart';
import 'package:seafood_b2b_app/features/catalog/screens/catalog_screen.dart';
import 'package:seafood_b2b_app/features/cart/screens/cart_screen.dart';
import 'package:seafood_b2b_app/features/cart/screens/order_confirmation_screen.dart';
import 'package:seafood_b2b_app/features/orders/screens/order_history_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  late final GoRouter config;

  AppRouter(WidgetRef ref) {
    config = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      refreshListenable:
          GoRouterRefreshStream(ref.watch(authProvider.notifier).stream),
      redirect: (context, state) {
        final container = ProviderScope.containerOf(context, listen: false);
        final auth = container.read(authProvider);

        final isLoggedIn = auth.isAuthenticated;
        final isLoggingIn = state.uri.path == '/';

        if (!isLoggedIn && !isLoggingIn) return '/';
        if (isLoggedIn && isLoggingIn) return '/home';

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
          path: '/order-history',
          builder: (context, state) => const OrderHistoryScreen(),
        ),
      ],
    );
  }
}

/// ✅ Обязательный класс для auto-refresh маршрутов
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
