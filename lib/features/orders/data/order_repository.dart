import 'package:seafood_b2b_app/api/woocommerce_api.dart';
import 'package:seafood_b2b_app/features/cart/data/cart_item_model.dart';

class OrderRepository {
  final WooCommerceApi _api = WooCommerceApi();

  Future<Map<String, dynamic>> createOrder(
    List<CartItem> cart, {
    required Map<String, dynamic> billing,
  }) async {
    final lineItems = cart
        .map((item) => {
              'product_id': item.product.id,
              'quantity': item.quantity,
            })
        .toList();

    final orderData = {
      'payment_method': 'bacs',
      'payment_method_title': 'Direct Bank Transfer',
      'set_paid': true,
      'billing': billing, // 👈 теперь это подставляется
      'line_items': lineItems,
    };

    return await _api.createOrder(orderData);
  }
}
