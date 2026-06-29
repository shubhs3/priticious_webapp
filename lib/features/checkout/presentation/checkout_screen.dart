import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/money_formatter.dart';
import '../../../features/cart/application/cart_controller.dart';
import '../../../shared/widgets/responsive_page.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cartSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ResponsivePage(
        maxWidth: 760,
        child: ListView(
          children: [
            Text(
              'Delivery Address',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(labelText: 'Full name'),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(labelText: 'Phone number'),
            ),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 2,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 18),
            const TextField(
              maxLines: 2,
              decoration: InputDecoration(labelText: 'Delivery instructions'),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    for (final item in summary.items)
                      Text(
                        '${item.quantity} × ${item.name} (${item.weightOption.label})',
                      ),
                    const Divider(),
                    Text(
                      'Cash on Delivery: ${MoneyFormatter.formatPaise(summary.totalInPaise)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: summary.items.isEmpty
                  ? null
                  : () {
                      ref.read(cartControllerProvider.notifier).clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully'),
                        ),
                      );
                      context.go('/orders');
                    },
              child: const Text('Place COD Order'),
            ),
          ],
        ),
      ),
    );
  }
}
