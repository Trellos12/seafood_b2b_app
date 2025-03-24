import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/catalog/data/category_model.dart';
import 'package:seafood_b2b_app/features/catalog/data/category_repository.dart';

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  final repo = CategoryRepository();
  return repo.fetchCategories();
});
