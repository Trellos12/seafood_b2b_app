import 'package:flutter/material.dart';
import 'package:seafood_b2b_app/features/catalog/data/mock_data.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: ListView.builder(
        itemCount: mockCategories.length,
        itemBuilder: (context, index) {
          final category = mockCategories[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(category.imageUrl,
                  width: 60, height: 60, fit: BoxFit.cover),
              title: Text(category.name),
              onTap: () {
                // пока ничего
              },
            ),
          );
        },
      ),
    );
  }
}
