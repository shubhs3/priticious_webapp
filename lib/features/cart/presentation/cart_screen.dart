import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../home/application/catalog_providers.dart';
import '../application/cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cartSummaryProvider);
    final totalItemsCount = summary.items.fold<int>(0, (sum, i) => sum + i.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          summary.items.isEmpty ? 'Cart' : 'Cart ($totalItemsCount)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (summary.items.isNotEmpty)
            IconButton(
              tooltip: 'Clear Cart',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Shopping Cart?'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: () {
                          ref.read(cartControllerProvider.notifier).clear();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: summary.items.isEmpty
          ? EmptyState(
              title: 'Your cart is empty',
              message: 'Explore our premium dry fruits, nuts & spices and add them to your cart.',
              icon: Icons.shopping_bag_outlined,
              action: FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.storefront_outlined),
                label: const Text('Browse Products'),
              ),
            )
          : ResponsivePage(
              maxWidth: 850,
              child: Column(
                children: [
                  // Free Shipping Progress Header
                  if (AppConstants.enableDeliveryCharges)
                    _FreeDeliveryProgressBar(subtotal: summary.subtotal),

                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: summary.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = summary.items[index];
                        return _ModernCartItemCard(item: item);
                      },
                    ),
                  ),

                  // Bottom Summary Card
                  _PriceBreakdownCard(summary: summary),
                ],
              ),
            ),
    );
  }
}

/// Header widget showing progress towards Free Delivery
class _FreeDeliveryProgressBar extends StatelessWidget {
  const _FreeDeliveryProgressBar({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    final threshold = AppConstants.freeDeliveryThreshold;
    final isFree = subtotal >= threshold;
    final remaining = (threshold - subtotal).clamp(0.0, threshold);
    final progress = (subtotal / threshold).clamp(0.0, 1.0);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isFree
            ? Colors.green.withAlpha(20)
            : colorScheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFree
              ? Colors.green.withAlpha(80)
              : colorScheme.primary.withAlpha(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFree ? Icons.stars_rounded : Icons.local_shipping_outlined,
                color: isFree ? Colors.green[700] : colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isFree
                      ? '🎉 You unlocked FREE Delivery!'
                      : 'Add ${MoneyFormatter.format(remaining)} more for FREE Delivery!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isFree ? Colors.green[800] : colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isFree
                  ? Colors.green.withAlpha(40)
                  : colorScheme.primary.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(
                isFree ? Colors.green : colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern Card displaying a single Cart Item with Small Thumbnail
class _ModernCartItemCard extends ConsumerWidget {
  const _ModernCartItemCard({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemTotal = item.unitPrice * item.quantity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(100),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Small Product Image Thumbnail
          _CartItemImageThumbnail(imageUrl: item.imageUrl),
          const SizedBox(width: 14),

          // Details: Title, Weight Badge, Unit & Total Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Weight Pill Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withAlpha(80),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.weightOption.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${MoneyFormatter.format(item.unitPrice)} each',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  MoneyFormatter.format(itemTotal),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Quantity Stepper Controls (- / +)
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () {
                    ref
                        .read(cartControllerProvider.notifier)
                        .updateQuantity(item, item.quantity - 1);
                  },
                  icon: Icon(
                    item.quantity == 1
                        ? Icons.delete_outline_rounded
                        : Icons.remove_rounded,
                    size: 18,
                    color: item.quantity == 1 ? Colors.red : colorScheme.onSurface,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () {
                    ref
                        .read(cartControllerProvider.notifier)
                        .updateQuantity(item, item.quantity + 1);
                  },
                  icon: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: colorScheme.onSurface,
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

/// Small rounded product thumbnail helper widget
class _CartItemImageThumbnail extends StatelessWidget {
  const _CartItemImageThumbnail({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(60),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: imageUrl.isEmpty
            ? Center(
                child: Icon(
                  Icons.spa_outlined,
                  color: colorScheme.primary,
                  size: 32,
                ),
              )
            : (imageUrl.startsWith('data:image/')
                ? Image.memory(
                    base64Decode(imageUrl.split(';base64,').last),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.outline,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.outline,
                      size: 24,
                    ),
                  )),
      ),
    );
  }
}

/// Bottom price breakdown card with checkout button
class _PriceBreakdownCard extends ConsumerWidget {
  const _PriceBreakdownCard({required this.summary});

  final CartSummaryModel summary;

  void _handleCheckout(BuildContext context, WidgetRef ref) {
    final isGuest = ref.read(currentCustomerIdProvider) == guestCustomerId;
    if (isGuest) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF6DF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFC59B27),
                  size: 26,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Login Required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3700),
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'You must log in to place an order and track your delivery status. Please log in or create an account to proceed to checkout.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC59B27),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go('/login');
              },
              child: const Text('Log In / Register'),
            ),
          ],
        ),
      );
    } else {
      context.go('/checkout');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = summary.items.fold<int>(0, (sum, i) => sum + i.quantity);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row(context, 'Subtotal ($totalItems items)', summary.subtotal),
            const SizedBox(height: 6),
            _row(
              context,
              'Delivery Charge',
              summary.deliveryCharge,
              isDelivery: true,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      MoneyFormatter.format(summary.total),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _handleCheckout(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  label: const Icon(Icons.arrow_forward_rounded, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, double amount, {bool isDelivery = false}) {
    final isFree = isDelivery && amount == 0.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Text(
          isFree ? 'FREE' : MoneyFormatter.format(amount),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isFree ? Colors.green[700] : null,
          ),
        ),
      ],
    );
  }
}

