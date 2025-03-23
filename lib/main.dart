import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: _Root(),
    ),
  );
}

class _Root extends ConsumerWidget {
  const _Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MyApp();
  }
}
