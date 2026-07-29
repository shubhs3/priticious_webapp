import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/product_model.dart';
import '../../core/utils/money_formatter.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key, this.onAdd});

  final ProductModel product;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = product.imageUrls.isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: Colors.black.withAlpha(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.go('/products/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: colorScheme.surfaceContainerHighest.withAlpha(51),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: hasImage
                          ? (product.imageUrls.first.startsWith('data:image/')
                              ? Image.memory(
                                  base64Decode(product.imageUrls.first.split(';base64,').last),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported_outlined,
                                    color: colorScheme.outline,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: product.imageUrls.first,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.image_not_supported_outlined,
                                    color: colorScheme.outline,
                                  ),
                                ))
                          : Center(
                              child: Icon(
                                Icons.spa_outlined,
                                color: colorScheme.primary,
                                size: 48,
                              ),
                            ),
                    ),
                    if (product.discountPriceInPaise < product.priceInPaise)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'SALE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.weightOptions.first.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.discountPriceInPaise < product.priceInPaise)
                            Text(
                              MoneyFormatter.formatPaise(product.priceInPaise),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: colorScheme.outline,
                                fontSize: 11,
                              ),
                            ),
                          Text(
                            MoneyFormatter.formatPaise(product.discountPriceInPaise),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      IconButton.filled(
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        onPressed: onAdd,
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
