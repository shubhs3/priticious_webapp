import 'package:flutter/material.dart';

import '../../core/models/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({required this.products, super.key, this.onAdd});

  final List<ProductModel> products;
  final void Function(ProductModel product)? onAdd;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1000
            ? 4
            : width >= 680
            ? 3
            : 2;
        return GridView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: width < 420 ? 0.66 : 0.74,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onAdd: onAdd == null ? null : () => onAdd!(product),
            );
          },
        );
      },
    );
  }
}
