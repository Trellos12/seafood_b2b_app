import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_item_model.dart';

/// Провайдер корзины: управляет списком CartItem
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  /// Добавить товар в корзину
  void addToCart(CartItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id);

    if (index == -1) {
      state = [...state, item];
    } else {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            state[i].copyWith(quantity: state[i].quantity + item.quantity)
          else
            state[i]
      ];
    }
  }

  /// Удалить товар из корзины по ID
  void removeFromCart(String productId) {
    state = state.where((e) => e.product.id != productId).toList();
  }

  /// Изменить количество товара
  void updateQuantity(String productId, int quantity) {
    if (quantity < 1) return;

    final index = state.indexWhere((e) => e.product.id == productId);
    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) state[i].copyWith(quantity: quantity) else state[i]
      ];
    }
  }

  /// Очистить корзину
  void clearCart() {
    state = [];
  }
}
