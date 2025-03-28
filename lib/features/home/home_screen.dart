import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';
import 'package:seafood_b2b_app/widgets/cart_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Профиль',
            onPressed: () => context.push('/profile'),
          ),
          const CartButton(),
        ],
      ),
      body: Center(
        child: !auth.isAuthenticated
            ? const Text('Пользователь не авторизован')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Добро пожаловать!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ваш email:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    auth.email ?? '-',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/catalog');
                    },
                    child: const Text('Перейти в каталог'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/order-history');
                    },
                    child: const Text('История заказов'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      context.go('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Выйти'),
                  ),
                ],
              ),
      ),
    );
  }
}
