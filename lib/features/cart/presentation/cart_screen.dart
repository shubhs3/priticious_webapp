import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                            '${item.weightOption.label} • ${MoneyFormatter.formatPaise(item.unitPriceInPaise)}',
                          ),
                          trailing: SegmentedButton<int>(
                            segments: const [
                              ButtonSegment(
                                value: -1,
                                icon: Icon(Icons.remove),
                              ),
                              ButtonSegment(value: 1, icon: Icon(Icons.add)),
                            ],
                            selected: const {},
                            emptySelectionAllowed: true,
                            onSelectionChanged: (selection) {
                              final delta = selection.firstOrNull ?? 0;
                              ref
                                  .read(cartControllerProvider.notifier)
                                  .updateQuantity(item, item.quantity + delta);
                            },
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

  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row('Subtotal', summary.subtotalInPaise),
            _row('Delivery', summary.deliveryChargeInPaise),
            const Divider(),
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

extension _FirstOrNull<T> on Set<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
