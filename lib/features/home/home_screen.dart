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
    _showRestoreCartSnackbarOnce();
  }

  Future<void> _showRestoreCartSnackbarOnce() async {
    if (_restored) return; // Показываем только один раз
    _restored = true;

    final prefs = await SharedPreferences.getInstance();
    final hasCart = prefs.getString('cart_items') != null;

    if (hasCart) {
      final snackBar = SnackBar(
        content: const Text('Обнаружена сохранённая корзина'),
        action: SnackBarAction(
          label: 'Очистить',
          onPressed: () {
            ref.read(cartProvider.notifier).clearCart();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
                ],
              ),
      ),
    );
  }
}
