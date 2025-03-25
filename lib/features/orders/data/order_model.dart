import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    required String status,
    required String total,
    @JsonKey(name: 'date_created') DateTime? dateCreated, // 👈 Делаем nullable
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
