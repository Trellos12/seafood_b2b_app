import 'package:dio/dio.dart';
import 'package:seafood_b2b_app/core/config/app_config.dart';
import 'package:seafood_b2b_app/features/catalog/data/category_model.dart';

class CategoryRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.baseUrl}/wp-json/wc/v3/',
      queryParameters: {
        'consumer_key': AppConfig.consumerKey,
        'consumer_secret': AppConfig.consumerSecret,
      },
    ),
  );

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('products/categories');
      final data = response.data as List;
      return data.map((json) => Category.fromWooJson(json)).toList();
    } catch (e) {
      throw Exception('Ошибка при загрузке категорий: $e');
    }
  }
}
