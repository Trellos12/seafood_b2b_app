import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    required String status,
    @JsonKey(fromJson: _toString) required String total, // ✅ required добавлено
    @JsonKey(name: 'date_created') DateTime? dateCreated,
    @Default([]) @JsonKey(name: 'line_items') List<LineItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class LineItem with _$LineItem {
  const factory LineItem({
    @JsonKey(name: 'product_id') required int productId,
    required String name,
    required int quantity,
    @JsonKey(fromJson: _toString) required String total, // ✅ required добавлено
    @JsonKey(fromJson: _toString) required String price, // ✅ required добавлено
  }) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

// 🔧 Универсальный конвертер
String _toString(dynamic value) => value?.toString() ?? '0.0';
