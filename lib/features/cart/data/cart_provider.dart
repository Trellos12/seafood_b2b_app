import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final notifier = CartNotifier();
  notifier.init(); // автоматическая загрузка корзины при старте
  return notifier;
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  static const _storageKey = 'cart_items';

  /// 📦 Инициализация при старте
  Future<void> init() async {
    debugPrint('🛒 Загрузка корзины из памяти...');
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List decoded = jsonDecode(jsonString);
        state = decoded.map((item) => CartItem.fromJson(item)).toList();
        debugPrint('✅ Корзина восстановлена: ${state.length} товаров');
      } catch (e) {
        debugPrint('❌ Ошибка загрузки корзины: $e');
        state = [];
        await prefs.remove(_storageKey);
      }
    }
  }

  /// 💾 Сохранение в память
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  /// ➕ Добавить товар
  void addToCart(CartItem item) {
    final index = state.indexWhere((e) => e.product.id == item.product.id);
    if (index == -1) {
      state = [...state, item];
    } else {
      final updated = [...state];
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = updated;
    }
    _persist();
  }

  /// ➖ Уменьшить количество
  void decreaseQuantity(String productId) {
    final updated = [...state];
    final index = updated.indexWhere((e) => e.product.id == productId);
    if (index != -1 && updated[index].quantity > 1) {
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity - 1);
      state = updated;
    } else {
      removeFromCart(productId);
    }
    _persist();
  }

  /// ➕ Увеличить количество
  void increaseQuantity(String productId) {
    final updated = [...state];
    final index = updated.indexWhere((e) => e.product.id == productId);
    if (index != -1) {
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + 1);
      state = updated;
    }
    _persist();
  }

  /// ❌ Удалить товар
  void removeFromCart(String productId) {
    state = state.where((e) => e.product.id != productId).toList();
    _persist();
  }

  /// 🗑 Очистить корзину
  void clearCart() {
    state = [];
    _persist();
  }

  /// 💰 Сумма заказа
  double get totalAmount {
    return state.fold(
        0, (sum, item) => sum + item.quantity * item.product.price);
  }
}
