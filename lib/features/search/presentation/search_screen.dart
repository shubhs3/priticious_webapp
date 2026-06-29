import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/cart/application/cart_controller.dart';
import '../../../features/home/application/catalog_providers.dart';
import '../../../shared/widgets/product_grid.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final results = ref.watch(searchResultsProvider);
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search almonds, dates, seeds...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
              const SizedBox(height: 12),
              categories.when(
                data: (items) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: selectedCategory == null,
                      onSelected: (_) =>
                          ref
                                  .read(selectedCategoryFilterProvider.notifier)
                                  .state =
                              null,
                    ),
                    for (final category in items)
                      FilterChip(
                        label: Text(category.name),
                        selected: selectedCategory == category.id,
                        onSelected: (_) =>
                            ref
                                .read(selectedCategoryFilterProvider.notifier)
                                .state = category
                                .id,
                      ),
                  ],
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text('Could not load filters: $error'),
              ),
              const SizedBox(height: 18),
              results.when(
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
                error: (error, stack) => Text('Search failed: $error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
