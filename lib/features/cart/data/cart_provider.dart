import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  static const _storageKey = 'cart_items';

  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List decoded = jsonDecode(jsonString);
        state = decoded.map((item) => CartItem.fromJson(item)).toList();
      } catch (e) {
        debugPrint('❌ Ошибка загрузки корзины: $e');
        state = [];
        await prefs.remove(_storageKey);
      }
    }
  }

  /// 🔄 Вызывается вручную из HomeScreen
  Future<void> restoreFromStorage() async {
    await _loadCartFromStorage();
    await _saveCartToStorage(); // ⬅️ сохраняем восстановленную корзину
  }

  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = [];
  }

  void addToCart(CartItem item) {
    debugPrint('🛒 Добавляем товар: ${item.product.name}');

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
    _saveCartToStorage();
  }

  void increaseQuantity(String productId) {
    final updated = [...state];
    final index = updated.indexWhere((e) => e.product.id == productId);
    if (index != -1) {
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = updated;
      _saveCartToStorage();
    }
  }

  void decreaseQuantity(String productId) {
    final updated = [...state];
    final index = updated.indexWhere((e) => e.product.id == productId);
    if (index != -1 && updated[index].quantity > 1) {
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity - 1);
      state = updated;
      _saveCartToStorage();
    } else {
      removeFromCart(productId);
    }
  }

  void removeFromCart(String productId) {
    state = state.where((e) => e.product.id != productId).toList();
    _saveCartToStorage();
  }

  void clearCart() {
    state = [];
    _saveCartToStorage();
  }
}
