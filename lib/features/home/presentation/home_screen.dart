import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/product_model.dart';
import '../../../features/cart/application/cart_controller.dart';
import '../../../shared/widgets/product_grid.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../../shared/widgets/section_header.dart';
import '../application/catalog_providers.dart';
import '../../search/application/search_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final banners = ref.watch(bannersProvider);
    final featured = ref.watch(featuredProductsProvider);
    final bestSellers = ref.watch(bestSellerProductsProvider);
    final newArrivals = ref.watch(newArrivalProductsProvider);
    final allProducts = ref.watch(productsProvider);
    final selectedCatId = ref.watch(selectedCategoryFilterProvider);

    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text(
                'PRITICIOUS DRY FRUITS',
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1,
                  color: const Color(0xFF4A3700),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: Color(0xFF4A3700)),
                  onPressed: () => context.go('/search'),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF4A3700)),
                  onPressed: () => context.go('/cart'),
                ),
              ],
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Edge-to-Edge 100% Full Width Hero Banner Carousel
            banners.when(
              data: (items) {
                if (items.isEmpty) return const SizedBox.shrink();
                final banner = items.first;
                return _DryFruitHeroSlider(
                  title: banner.title,
                  subtitle: banner.subtitle,
                  imageUrl: banner.imageUrl,
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text('Could not load banners: $error'),
            ),

            ResponsivePage(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Search Input Bar
                  SearchAnchor.bar(
                    barHintText: 'Search almonds, cashews, dates, gift boxes...',
                    barElevation: const WidgetStatePropertyAll(1),
                    onSubmitted: (query) {
                      ref.read(searchQueryProvider.notifier).state = query;
                      context.go('/search');
                    },
                    suggestionsBuilder: (context, controller) => const [],
                  ),
                  const SizedBox(height: 20),

                  // Dry Fruit House Circular Category Avatars Row
                  const SectionHeader(title: 'Explore Categories'),
                  categories.when(
                    data: (items) => SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length + 1,
                        separatorBuilder: (context, index) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _CircularCategoryAvatar(
                              title: 'All Products',
                              imageUrl: '',
                              isSelected: selectedCatId == null,
                              onTap: () {
                                ref.read(selectedCategoryFilterProvider.notifier).state = null;
                              },
                            );
                          }
                          final category = items[index - 1];
                          return _CircularCategoryAvatar(
                            title: category.name,
                            imageUrl: category.imageUrl,
                            isSelected: selectedCatId == category.id,
                            onTap: () {
                              ref.read(selectedCategoryFilterProvider.notifier).state = category.id;
                              context.go('/search');
                            },
                          );
                        },
                      ),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stack) => Text('Could not load categories: $error'),
                  ),

                  const SizedBox(height: 16),

                  // Promotional Feature Banners (Bulk Order & Gift Boxes)
                  const _PromoGridBanners(),

                  const SizedBox(height: 20),

                  // Product Sections
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
                  _ProductSection(
                    title: 'All Products',
                    products: allProducts,
                    onAdd: (product) => _addToCart(context, ref, product),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Dry Fruit House Burgundy Footer
            const _DryFruitHouseFooter(),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref, ProductModel product) {
    ref
      .read(cartControllerProvider.notifier)
      .addProduct(product, product.weightOptions.first);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

/// Circular Category Avatar item
class _CircularCategoryAvatar extends StatelessWidget {
  const _CircularCategoryAvatar({
    required this.title,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFFC59B27) : const Color(0xFFE5DCC6),
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC59B27).withAlpha(isSelected ? 40 : 15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: const Color(0xFFFFF9EE),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.spa_outlined,
                          color: Color(0xFFC59B27),
                          size: 28,
                        ),
                      )
                    : const Icon(
                        Icons.apps_rounded,
                        color: Color(0xFFC59B27),
                        size: 28,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 78,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.josefinSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? const Color(0xFF7A5900) : const Color(0xFF554422),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Multi-slide Hero Banner Slider using generated luxury images
class _DryFruitHeroSlider extends StatefulWidget {
  const _DryFruitHeroSlider({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String imageUrl;

  @override
  State<_DryFruitHeroSlider> createState() => _DryFruitHeroSliderState();
}

class _DryFruitHeroSliderState extends State<_DryFruitHeroSlider> {
  late final PageController _pageController;
  Timer? _autoTimer;
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Indulge in Nature’s Finery',
      'subtitle': 'Handpicked Artisan Selection of Nuts, Dates & Berries',
      'tag': 'ROYAL HARVEST ✨',
      'asset': 'assets/banners/banner1.png',
    },
    {
      'title': 'Luxury Gift Boxes & Hampers',
      'subtitle': 'Personalised Corporate & Festive Gifting Collections',
      'tag': 'FESTIVE SPECIAL 🎁',
      'asset': 'assets/banners/banner2.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoTimer();
  }

  void _startAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentIndex + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Container(
      width: double.infinity,
      height: isDesktop ? 360 : 220,
      color: const Color(0xFF2C1E00),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      slide['asset']!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF382A03)),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2C1E00).withAlpha(240),
                            const Color(0xFF2C1E00).withAlpha(140),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: isDesktop ? 48 : 20,
                        right: isDesktop ? 400 : 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC59B27),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              slide['tag']!,
                              style: GoogleFonts.josefinSans(
                                color: Colors.white,
                                fontSize: isDesktop ? 12 : 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide['title']!,
                            style: GoogleFonts.josefinSans(
                              color: Colors.white,
                              fontSize: isDesktop ? 34 : 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            slide['subtitle']!,
                            style: GoogleFonts.josefinSans(
                              color: Colors.white70,
                              fontSize: isDesktop ? 16 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => context.go('/products'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC59B27),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 26 : 18,
                                vertical: isDesktop ? 14 : 10,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text(
                              'SHOP NOW',
                              style: GoogleFonts.josefinSans(
                                fontSize: isDesktop ? 14 : 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Swiper Dot Indicators
          Positioned(
            bottom: 16,
            right: 32,
            child: Row(
              children: [
                for (int i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == i ? const Color(0xFFC59B27) : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
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

/// Promotional 2-column feature banners
class _PromoGridBanners extends StatelessWidget {
  const _PromoGridBanners();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PromoCard(
            title: 'Gift Boxes & Hampers',
            subtitle: 'Personalised Corporate & Festive Gifts',
            buttonText: 'EXPLORE GIFTS',
            backgroundColor: const Color(0xFF4A3700),
            onTap: () => context.go('/bulk-orders'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PromoCard(
            title: 'Wholesale & Bulk Orders',
            subtitle: 'Direct Farm-Fresh Bulk Supplies',
            buttonText: 'ORDER BULK',
            backgroundColor: const Color(0xFF332500),
            onTap: () => context.go('/bulk-orders'),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.backgroundColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC59B27).withAlpha(120)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  buttonText,
                  style: GoogleFonts.josefinSans(
                    color: const Color(0xFFE8B830),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFE8B830),
                  size: 16,
                ),
              ],
            ),
          ],
        ),
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
          const SizedBox(height: 16),
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

/// Rich Footer in Warm Golden Ivory (#FAF5E8) & Deep Bronze
class _DryFruitHouseFooter extends StatelessWidget {
  const _DryFruitHouseFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFAF5E8),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC59B27),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.spa_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'PRITICIOUS DRY FRUITS',
                  style: GoogleFonts.josefinSans(
                    color: const Color(0xFF4A3700),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Priticious Dry Fruits - Premium quality almonds, cashews, pistachios, dates, dried berries, spices, and luxury gift boxes delivered fresh to your doorstep.',
              style: GoogleFonts.josefinSans(
                color: const Color(0xFF5A481C),
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const Divider(color: Color(0xFFE2D6BC), height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact Us', style: TextStyle(color: Color(0xFF7A5900), fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('📞 +91-7483600212 / 9364896022', style: TextStyle(color: Color(0xFF5A481C), fontSize: 11)),
                    const Text('✉️ info@priticious.com', style: TextStyle(color: Color(0xFF5A481C), fontSize: 11)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Links', style: TextStyle(color: Color(0xFF7A5900), fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () => context.go('/bulk-orders'),
                      child: const Text('• Bulk Orders', style: TextStyle(color: Color(0xFF5A481C), fontSize: 11)),
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: () => context.go('/locations'),
                      child: const Text('• Store Locations', style: TextStyle(color: Color(0xFF5A481C), fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '© 2026 Priticious Dry Fruits. All Rights Reserved.',
                style: GoogleFonts.josefinSans(
                  color: const Color(0xFF8C7643),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


