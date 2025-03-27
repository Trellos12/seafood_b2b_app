import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:seafood_b2b_app/core/config/app_config.dart';
import 'package:seafood_b2b_app/features/orders/data/order_model.dart';

final orderListProvider =
    FutureProvider.family<List<Order>, String>((ref, email) async {
  final url = Uri.parse(
    '${AppConfig.baseUrl}/wp-json/wc/v3/orders?consumer_key=${AppConfig.consumerKey}&consumer_secret=${AppConfig.consumerSecret}&billing_email=$email',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => Order.fromJson(e)).toList();
  } else {
    throw Exception('Ошибка загрузки заказов: ${response.body}');
  }
});
