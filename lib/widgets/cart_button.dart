import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {
        // ❌ Убедись, что здесь нет вызова clearStorage()
        context.go('/cart'); // ✅ просто переходим на экран корзины
      },
    );
  }
}
