class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  /// 🔁 Создание из WooCommerce JSON
  factory Category.fromWooJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? 'Без названия',
      imageUrl: json['image'] != null ? json['image']['src'] ?? '' : '',
    );
  }
}
