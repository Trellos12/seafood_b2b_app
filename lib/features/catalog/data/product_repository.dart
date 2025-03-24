import 'package:seafood_b2b_app/features/catalog/data/product_model.dart';
import 'package:seafood_b2b_app/features/catalog/data/woocommerce_api.dart';

class ProductRepository {
  final WooCommerceApi _api = WooCommerceApi();

  Future<List<Product>> getProducts() async {
    final data = await _api.fetchProducts();
    return data.map<Product>((json) => Product.fromWooJson(json)).toList();
  }
}
