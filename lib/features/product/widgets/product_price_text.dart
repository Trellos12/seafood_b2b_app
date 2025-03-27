import 'package:flutter/material.dart';

class ProductPriceText extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const ProductPriceText({
    super.key,
    required this.price,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleMedium;

    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: style ?? defaultStyle,
    );
  }
}
