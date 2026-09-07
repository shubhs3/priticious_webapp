import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/product_model.dart';
import '../../core/utils/money_formatter.dart';
import '../../features/cart/application/cart_controller.dart';

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({required this.product, super.key, this.onAdd});

  final ProductModel product;
  final VoidCallback? onAdd;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  late ProductWeightOption _selectedWeight;

  @override
  void initState() {
    super.initState();
    _selectedWeight = widget.product.weightOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = product.imageUrls.isNotEmpty;

    final cartItems = ref.watch(cartControllerProvider);
    final cartItemIndex = cartItems.indexWhere(
      (item) => item.productId == product.id && item.weightOption == _selectedWeight,
    );
    final inCart = cartItemIndex != -1;
    final quantity = inCart ? cartItems[cartItemIndex].quantity : 0;

    final unitPrice = _selectedWeight.price;
    final unitDiscountPrice = _selectedWeight.discountPrice;
    final hasDiscount = unitDiscountPrice < unitPrice;
    final discountPercent = hasDiscount
        ? (((unitPrice - unitDiscountPrice) / unitPrice) * 100).round()
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEBE5DF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => context.go('/products/${product.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Container with Badge
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFFF9F6F0),
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
                                  size: 40,
                                ),
                              ),
                      ),
                    ),

                    // Dry Fruit House Maroon Sale Badge
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC59B27), // Royal Amber Gold
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discountPercent% OFF',
                            style: GoogleFonts.josefinSans(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                    // Best Seller Badge
                    if (product.isBestSeller)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37), // Gold
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'BESTSELLER',
                            style: GoogleFonts.josefinSans(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product Info & Controls
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.josefinSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Weight Option Selector Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final option in product.weightOptions)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: InkWell(
                                onTap: () => setState(() => _selectedWeight = option),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _selectedWeight == option
                                        ? const Color(0xFFC59B27)
                                        : const Color(0xFFFAF5EC),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _selectedWeight == option
                                          ? const Color(0xFFC59B27)
                                          : const Color(0xFFE5DCC6),
                                    ),
                                  ),
                                  child: Text(
                                    option.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedWeight == option
                                          ? Colors.white
                                          : const Color(0xFF4A3700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Price display
                    Row(
                      children: [
                        Text(
                          MoneyFormatter.format(unitDiscountPrice),
                          style: GoogleFonts.josefinSans(
                            color: const Color(0xFF7A5900), // Deep Golden Bronze
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            MoneyFormatter.format(unitPrice),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Full-Width Add To Cart Button
                    if (inCart)
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC59B27),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                quantity == 1 ? Icons.delete_outline_rounded : Icons.remove,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                final cartItem = cartItems[cartItemIndex];
                                ref
                                    .read(cartControllerProvider.notifier)
                                    .updateQuantity(cartItem, cartItem.quantity - 1);
                              },
                            ),
                            Text(
                              '$quantity in Cart',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                              onPressed: () {
                                ref
                                    .read(cartControllerProvider.notifier)
                                    .addProduct(product, _selectedWeight);
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC59B27),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(cartControllerProvider.notifier)
                                .addProduct(product, _selectedWeight);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} (${_selectedWeight.label}) added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Text(
                            'ADD TO CART',
                            style: GoogleFonts.josefinSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


