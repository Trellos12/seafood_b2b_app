import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    required List<String> categoryIds, // ✅ заменили categoryId → categoryIds
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// 🛒 Создание из WooCommerce JSON
  factory Product.fromWooJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? 'Без названия',
      imageUrl:
          (json['images'] as List).isNotEmpty ? json['images'][0]['src'] : '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      categoryIds: (json['categories'] as List)
          .map((cat) => cat['id'].toString())
          .toList(),
    );
  }
}
