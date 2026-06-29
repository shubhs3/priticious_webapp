import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/cart/application/cart_controller.dart';
import '../../../features/home/application/catalog_providers.dart';
import '../../../shared/widgets/product_grid.dart';
import '../../../shared/widgets/responsive_page.dart';

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('All Products')),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: products.when(
            data: (items) => ProductGrid(
              products: items,
              onAdd: (product) {
                ref
                    .read(cartControllerProvider.notifier)
                    .addProduct(product, product.weightOptions.first);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart')),
                );
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => Text('Could not load products: $error'),
          ),
        ),
      ),
    );
  }
}
