import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/cart/data/cart_item_model.dart';
import 'package:seafood_b2b_app/secrets.dart';
import 'package:seafood_b2b_app/features/orders/data/order_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

class OrderRepository {
  Future<int> createOrder({
    required List<CartItem> items,
    required String email,
  }) async {
    final url = Uri.parse(
      '${Secrets.baseUrl}/wp-json/wc/v3/orders?consumer_key=${Secrets.consumerKey}&consumer_secret=${Secrets.consumerSecret}',
    );

    final body = {
      'payment_method': 'cod',
      'payment_method_title': 'Оплата при получении',
      'set_paid': true,
      'billing': {
        'first_name': 'Имя',
        'last_name': 'Фамилия',
        'email': email,
      },
      'line_items': items
          .map((item) => {
                'product_id': int.parse(item.product.id),
                'quantity': item.quantity,
              })
          .toList(),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'] as int;
    } else {
      throw Exception('Ошибка WooCommerce: ${response.body}');
    }
  }

  /// 📦 Получить список заказов по email
  Future<List<Order>> fetchOrdersByEmail(String email) async {
    final url = Uri.parse(
      '${Secrets.baseUrl}/wp-json/wc/v3/orders?consumer_key=${Secrets.consumerKey}&consumer_secret=${Secrets.consumerSecret}&email=$email',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка получения заказов: ${response.body}');
    }
  }
}
