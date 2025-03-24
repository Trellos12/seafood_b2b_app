import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: _Root()));
}

class _Root extends ConsumerWidget {
  const _Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter(ref).config;

    return MaterialApp.router(
      routerConfig: router,
      title: 'Seafood B2B App',
      debugShowCheckedModeBanner: false,
    );
  }
}
