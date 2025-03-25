import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/core/router/app_router.dart'; // ✅ правильный путь

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter(ref).config;

    return MaterialApp.router(
      title: 'Seafood B2B',
      routerConfig: router,
    );
  }
}
