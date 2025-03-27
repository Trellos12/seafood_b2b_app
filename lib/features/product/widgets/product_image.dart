import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  final String? heroTag;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 1.5,
    this.heroTag, // 🔹 необязательный параметр
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: heroTag != null ? Hero(tag: heroTag!, child: image) : image,
    );
  }
}
