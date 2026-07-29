import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/product_model.dart';
import '../../../features/cart/application/cart_controller.dart';
import '../../../shared/widgets/product_grid.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../../shared/widgets/section_header.dart';
import '../application/catalog_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final banners = ref.watch(bannersProvider);
    final featured = ref.watch(featuredProductsProvider);
    final bestSellers = ref.watch(bestSellerProductsProvider);
    final newArrivals = ref.watch(newArrivalProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Priticious'),
      ),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchAnchor.bar(
                barHintText: 'Search nuts, seeds, dates...',
                onSubmitted: (query) => context.go('/search'),
                suggestionsBuilder: (context, controller) => const [],
              ),
              const SizedBox(height: 18),
              banners.when(
                data: (items) {
                  if (items.isEmpty) return const SizedBox.shrink();
                  final banner = items.first;
                  return _HeroBanner(
                    title: banner.title,
                    subtitle: banner.subtitle,
                    imageUrl: banner.imageUrl,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text('Could not load banners: $error'),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Shop by category'),
              categories.when(
                data: (items) => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final category in items)
                      ActionChip(
                        avatar: const Icon(Icons.spa_outlined, size: 18),
                        label: Text(category.name),
                        onPressed: () => context.go('/search'),
                      ),
                  ],
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) =>
                    Text('Could not load categories: $error'),
              ),
              const SizedBox(height: 24),
              _ProductSection(
                title: 'Featured Products',
                products: featured,
                onAdd: (product) => _addToCart(context, ref, product),
              ),
              _ProductSection(
                title: 'Best Sellers',
                products: bestSellers,
                onAdd: (product) => _addToCart(context, ref, product),
              ),
              _ProductSection(
                title: 'New Arrivals',
                products: newArrivals,
                onAdd: (product) => _addToCart(context, ref, product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref, ProductModel product) {
    ref
      .read(cartControllerProvider.notifier)
      .addProduct(product, product.weightOptions.first);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: colorScheme.primaryContainer,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.primary,
                    ),
                  )
                : Container(color: colorScheme.primary),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(179),
                    Colors.black.withAlpha(51),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({
    required this.title,
    required this.products,
    required this.onAdd,
  });

  final String title;
  final AsyncValue<List<ProductModel>> products;
  final void Function(ProductModel product) onAdd;

  @override
  Widget build(BuildContext context) {
    return products.when(
      data: (items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          SectionHeader(
            title: title,
            actionLabel: 'View all',
            onAction: () => context.go('/products'),
          ),
          ProductGrid(products: items, onAdd: onAdd),
        ],
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: LinearProgressIndicator(),
      ),
      error: (error, stack) => Text('Could not load $title: $error'),
    );
  }
}
