import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/catalog/data/mock_data.dart';
import 'package:seafood_b2b_app/features/catalog/data/category_model.dart';
import 'package:seafood_b2b_app/features/catalog/screens/product_details_screen.dart'; // 👈 добавлен импорт

final selectedCategoryProvider =
    StateProvider<Category>((ref) => mockCategories.first);

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts =
        mockProducts.where((p) => p.categoryId == selectedCategory.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Горизонтальная карусель категорий (2.5 карточки в ширину)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                final isSelected = category.id == selectedCategory.id;

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state =
                        category;
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                        Image.network(category.imageUrl, width: 40, height: 40),
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
            ),
          ),

          // Название категории и описание
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Выбрана категория: ${selectedCategory.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Сетка товаров 2xN с переходом по нажатию
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
                          Image.network(
                            product.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
