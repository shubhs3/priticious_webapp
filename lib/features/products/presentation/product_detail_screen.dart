import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../features/cart/application/cart_controller.dart';
import '../../../features/home/application/catalog_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ProductWeightOption? selectedWeight;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productProvider(widget.productId));
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: product.when(
        data: (item) {
          if (item == null) {
            return const EmptyState(
              title: 'Product not found',
              message: 'This item is no longer available.',
            );
          }
          final weight = selectedWeight ?? item.weightOptions.first;
          return SingleChildScrollView(
            child: ResponsivePage(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 720;
                  final image = _ProductImage(product: item);
                  final details = _Details(
                    product: item,
                    weight: weight,
                    onWeightChanged: (value) {
                      setState(() => selectedWeight = value);
                    },
                  );
                  return wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: image),
                            const SizedBox(width: 24),
                            Expanded(child: details),
                          ],
                        )
                      : Column(
                          children: [
                            image,
                            const SizedBox(height: 18),
                            details,
                          ],
                        );
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Could not load product: $error')),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = product.imageUrls.isNotEmpty;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrls.first.startsWith('data:image/')
                    ? Image.memory(
                        base64Decode(product.imageUrls.first.split(';base64,').last),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          size: 48,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: product.imageUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.broken_image,
                          size: 48,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
              )
            : Icon(
                Icons.spa_outlined,
                size: 96,
                color: colorScheme.onPrimaryContainer,
              ),
      ),
    );
  }
}

class _Details extends ConsumerWidget {
  const _Details({
    required this.product,
    required this.weight,
    required this.onWeightChanged,
  });

  final ProductModel product;
  final ProductWeightOption weight;
  final ValueChanged<ProductWeightOption> onWeightChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartControllerProvider);
    final cartItemIndex = cartItems.indexWhere(
      (item) => item.productId == product.id && item.weightOption == weight,
    );
    final inCart = cartItemIndex != -1;
    final quantity = inCart ? cartItems[cartItemIndex].quantity : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(product.description),
        const SizedBox(height: 16),
        Text(
          MoneyFormatter.formatPaise(weight.discountPriceInPaise),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (final option in product.weightOptions)
              ChoiceChip(
                label: Text(option.label),
                selected: option == weight,
                onSelected: (_) => onWeightChanged(option),
              ),
          ],
        ),
        const SizedBox(height: 18),
        if (inCart)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  final cartItem = cartItems[cartItemIndex];
                  ref
                      .read(cartControllerProvider.notifier)
                      .updateQuantity(cartItem, cartItem.quantity - 1);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.remove),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$quantity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  ref
                      .read(cartControllerProvider.notifier)
                      .addProduct(product, weight);
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          )
        else
          FilledButton.icon(
            onPressed: () {
              ref
                  .read(cartControllerProvider.notifier)
                  .addProduct(product, weight);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} added to cart')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
          ),
        const SizedBox(height: 24),
        Text('Nutrition', style: Theme.of(context).textTheme.titleLarge),
        DataTable(
          columns: const [
            DataColumn(label: Text('Nutrient')),
            DataColumn(label: Text('Value')),
          ],
          rows: [
            for (final entry in product.nutrition.entries)
              DataRow(
                cells: [DataCell(Text(entry.key)), DataCell(Text(entry.value))],
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Ingredients: ${product.ingredients.join(', ')}'),
        const SizedBox(height: 8),
        Text('Storage: ${product.storageInstructions}'),
      ],
    );
  }
}
