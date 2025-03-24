import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/catalog/data/product_model.dart';
import 'package:seafood_b2b_app/features/catalog/data/product_repository.dart';

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ProductRepository();
  return repository.getProducts();
});
