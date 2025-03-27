import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/features/catalog/data/product_model.dart';
import 'package:seafood_b2b_app/features/cart/data/cart_provider.dart';
import 'package:seafood_b2b_app/features/cart/data/cart_item_model.dart';
import 'package:seafood_b2b_app/features/cart/screens/cart_screen.dart';

class ProductBuySection extends ConsumerStatefulWidget {
  final Product product;

  const ProductBuySection({super.key, required this.product});

  @override
  ConsumerState<ProductBuySection> createState() => _ProductBuySectionState();
}

class _ProductBuySectionState extends ConsumerState<ProductBuySection> {
  int localQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final existingItem = cart.firstWhere(
      (item) => item.product.id == widget.product.id,
      orElse: () => CartItem(product: widget.product, quantity: 0),
    );

    final inCart = existingItem.quantity > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            // Кол-во +/-
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (localQuantity > 1) localQuantity--;
                });
              },
            ),
            Text('$localQuantity', style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  localQuantity++;
                });
              },
            ),
            const SizedBox(width: 12),

            // Добавить в корзину
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Добавить'),
                onPressed: () {
                  cartNotifier.addToCart(
                    CartItem(product: widget.product, quantity: localQuantity),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Товар добавлен в корзину')),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Переход в корзину
            if (inCart)
              IconButton(
                icon: const Icon(Icons.shopping_cart_checkout),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
