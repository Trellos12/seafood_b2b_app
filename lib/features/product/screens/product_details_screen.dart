import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/catalog/data/product_model.dart';
import '../../../widgets/cart_button.dart';
import '../widgets/product_image.dart';
import '../widgets/product_price_text.dart';
import '../widgets/product_buy_section.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: const [CartButton()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product-image-${product.id}',
                child: ProductImage(imageUrl: product.imageUrl),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              ProductPriceText(price: product.price),
              const SizedBox(height: 16),
              ProductBuySection(product: product),
              const SizedBox(height: 24),
              Text(
                'Описание',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                (product.description ?? 'Описание недоступно').trim(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
