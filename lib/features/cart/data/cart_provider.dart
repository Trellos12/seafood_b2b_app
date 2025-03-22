import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_item_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(CartItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id);

    if (index == -1) {
      state = [...state, item];
    } else {
      final updated = [...state];
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + 1,
      );
      state = updated;
    }
  }

  void removeFromCart(String productId) {
    state = state.where((e) => e.product.id != productId).toList();
  }

  void clearCart() {
    state = [];
  }
}
