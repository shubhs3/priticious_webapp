import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cartSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: summary.items.isEmpty
          ? const EmptyState(
              title: 'Your cart is empty',
              message: 'Add a few premium snacks and they will appear here.',
              icon: Icons.shopping_bag_outlined,
            )
          : ResponsivePage(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: summary.items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = summary.items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.spa_outlined),
                          ),
                          title: Text(item.name),
                          subtitle: Text(
                            '${item.weightOption.label} • ${MoneyFormatter.formatPaise(item.unitPriceInPaise)} x ${item.quantity} = ${MoneyFormatter.formatPaise(item.unitPriceInPaise * item.quantity)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton.filledTonal(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  ref
                                      .read(cartControllerProvider.notifier)
                                      .updateQuantity(item, item.quantity - 1);
                                },
                                icon: const Icon(Icons.remove, size: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '${item.quantity}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              IconButton.filled(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  ref
                                      .read(cartControllerProvider.notifier)
                                      .updateQuantity(item, item.quantity + 1);
                                },
                                icon: const Icon(Icons.add, size: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  _PriceBreakdown(summary: summary),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/checkout'),
                      child: const Text('Checkout with COD'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({required this.summary});

  final CartSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final totalItems = summary.items.fold<int>(0, (sum, i) => sum + i.quantity);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row('Subtotal ($totalItems items)', summary.subtotalInPaise),
            _row('Delivery', summary.deliveryChargeInPaise),
            if (AppConstants.enableDeliveryCharges) ...[
              if (summary.subtotalInPaise < AppConstants.freeDeliveryThresholdInPaise && summary.subtotalInPaise > 0) ...[
                const SizedBox(height: 8),
                Text(
                  'Add ${MoneyFormatter.formatPaise(AppConstants.freeDeliveryThresholdInPaise - summary.subtotalInPaise)} more for FREE delivery!',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ] else if (summary.subtotalInPaise >= AppConstants.freeDeliveryThresholdInPaise) ...[
                const SizedBox(height: 8),
                const Text(
                  '🎉 You qualify for FREE delivery!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ] else if (summary.subtotalInPaise > 0) ...[
              const SizedBox(height: 8),
              const Text(
                '🎉 Free delivery on all orders!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
            const Divider(height: 24),
            _row('Total', summary.totalInPaise, bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, int amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            MoneyFormatter.formatPaise(amount),
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
