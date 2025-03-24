import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';
import 'package:seafood_b2b_app/features/cart/data/cart_provider.dart';
import 'package:seafood_b2b_app/widgets/cart_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _restored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showRestoreCartDialogOnce();
  }

  Future<void> _showRestoreCartDialogOnce() async {
    if (_restored) return;
    _restored = true;

    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart_items');
    final hasCart = cartJson != null && cartJson != '[]';

    if (!mounted || !hasCart) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Сохранённая корзина'),
        content: const Text('Хотите восстановить или очистить корзину?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(cartProvider.notifier).restoreFromStorage();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Корзина восстановлена')),
              );
            },
            child: const Text('Восстановить'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              prefs.remove('cart_items');
              ref.read(cartProvider.notifier).clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Корзина очищена')),
              );
            },
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: const [
          CartButton(),
        ],
      ),
      body: Center(
        child: user == null
            ? const Text('Пользователь не найден')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Добро пожаловать!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Роль: ${user.role.name.toUpperCase()}',
                    style: const TextStyle(fontSize: 18),
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
                      ref.read(userProvider.notifier).state = null;
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
