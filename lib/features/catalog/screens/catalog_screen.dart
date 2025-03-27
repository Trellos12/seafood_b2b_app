import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/catalog/data/category_model.dart';
import 'package:seafood_b2b_app/features/catalog/data/category_provider.dart';
import 'package:seafood_b2b_app/features/catalog/data/product_provider.dart';
import 'package:seafood_b2b_app/features/product/screens/product_details_screen.dart';
import 'package:seafood_b2b_app/widgets/cart_button.dart';
import 'package:seafood_b2b_app/widgets/shimmer_box.dart';

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
        actions: const [CartButton()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Категории
          SizedBox(
            height: 100,
            child: categoriesAsync.when(
              loading: () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ShimmerBox(height: 60, width: 140),
                ),
              ),
              error: (e, _) => Center(child: Text('Ошибка категорий: $e')),
              data: (categories) {
                if (categories.isEmpty) {
                  return const Center(child: Text('Категории не найдены'));
                }

                if (selectedCategory == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(selectedCategoryProvider.notifier).state =
                        categories.first;
                  });
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory?.id == category.id;

                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Colors.blue[50] : Colors.white,
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              category.imageUrl,
                              width: 40,
                              height: 40,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.store),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Заголовок категории
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Выбрана категория: ${selectedCategory?.name ?? "..."}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // 🔹 Товары по выбранной категории
          Expanded(
            child: productsAsync.when(
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, __) => const ShimmerBox(
                  height: 160,
                  width: double.infinity,
                ),
              ),
              error: (e, _) => Center(child: Text('Ошибка загрузки: $e')),
              data: (products) {
                final filtered = selectedCategory == null
                    ? []
                    : products
                        .where(
                            (p) => p.categoryIds.contains(selectedCategory.id))
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Нет товаров в категории'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'product-image-${product.id}',
                              child: Image.network(
                                product.imageUrl,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${product.price.toStringAsFixed(2)} €'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
