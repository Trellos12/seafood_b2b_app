import 'package:dio/dio.dart';
import 'package:seafood_b2b_app/core/config/app_config.dart';

class WooCommerceApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.baseUrl}/wp-json/wc/v3/',
      headers: {
        'Accept': 'application/json',
      },
      queryParameters: {
        'consumer_key': AppConfig.consumerKey,
        'consumer_secret': AppConfig.consumerSecret,
      },
    ),
  );

  /// 📦 Получение списка товаров
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await _dio.get('products');
      return response.data;
    } catch (e) {
      throw Exception('Ошибка загрузки товаров: $e');
    }
  }

  /// 🧾 Создание заказа
  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> orderData) async {
    try {
      final response = await _dio.post('orders', data: orderData);
      return response.data;
    } catch (e) {
      throw Exception('Ошибка оформления заказа: $e');
    }
  }
}
