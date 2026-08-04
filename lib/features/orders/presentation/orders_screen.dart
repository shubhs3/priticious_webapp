import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/order_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../home/application/catalog_providers.dart';
import '../application/order_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerId = ref.watch(currentCustomerIdProvider);
    final ordersAsync = ref.watch(customerOrdersProvider);
    final isGuest = customerId == guestCustomerId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ResponsivePage(
        maxWidth: 720,
        child: isGuest
            ? EmptyState(
                title: 'Sign in to view orders',
                message: 'Your order history and live tracking details will appear once you log in.',
                icon: Icons.receipt_long_outlined,
                action: FilledButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Login / Sign Up'),
                ),
              )
            : ordersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Failed to load orders: $error')),
                data: (orders) {
                  if (orders.isEmpty) {
                    return const EmptyState(
                      title: 'No orders yet',
                      message: 'Your COD order history and tracking timeline will appear here.',
                      icon: Icons.receipt_long_outlined,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _OrderCard(order: order);
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  Color _getStatusColor(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => Colors.orange,
      OrderStatus.confirmed => Colors.blue,
      OrderStatus.packed => Colors.purple,
      OrderStatus.shipped => Colors.indigo,
      OrderStatus.delivered => Colors.green,
      OrderStatus.cancelled => Colors.red,
    };
  }

  String _getStatusText(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => 'Pending Approval',
      OrderStatus.confirmed => 'Confirmed',
      OrderStatus.packed => 'Packed',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.cancelled => 'Cancelled',
    };
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final formattedDate = order.placedAt != null ? dateFormat.format(order.placedAt!) : 'Date N/A';
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER ID: #${order.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(38),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Items
                const Text(
                  'Items ordered',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity} × ${item.name} (${item.weightOption.label})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          MoneyFormatter.format(item.unitPrice * item.quantity),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),
                // Address & Cost Summary
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Details',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.shippingAddress.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          Text(
                            'Phone: ${order.shippingAddress.phoneNumber}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            order.shippingAddress.line1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          if (order.deliveryInstructions != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Note: ${order.deliveryInstructions}',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Subtotal: ${MoneyFormatter.format(order.subtotal)}', style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            'Delivery: ${order.deliveryCharge == 0.0 ? "FREE" : MoneyFormatter.format(order.deliveryCharge)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: order.deliveryCharge == 0.0 ? Colors.green : null,
                              fontWeight: order.deliveryCharge == 0.0 ? FontWeight.bold : null,
                            ),
                          ),
                          const Divider(height: 12),
                          Text(
                            MoneyFormatter.format(order.total),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                // Tracking Timeline Progress Indicator
                _OrderTrackingTimeline(status: order.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTrackingTimeline extends StatelessWidget {
  const _OrderTrackingTimeline({required this.status});

  final OrderStatus status;

  int _getStatusStep() {
    return switch (status) {
      OrderStatus.pending => 0,
      OrderStatus.confirmed => 1,
      OrderStatus.packed => 2,
      OrderStatus.shipped => 3,
      OrderStatus.delivered => 4,
      OrderStatus.cancelled => -1,
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getStatusStep();

    if (currentStep == -1) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withAlpha(76)),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
            SizedBox(width: 10),
            Text(
              'This order was cancelled.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final steps = ['Placed', 'Confirmed', 'Packed', 'Shipped', 'Delivered'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isActive = index <= currentStep;
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        final stepColor = isActive
            ? (isCurrent ? Theme.of(context).colorScheme.primary : Colors.green)
            : Theme.of(context).colorScheme.outlineVariant;

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index == 0
                          ? Colors.transparent
                          : (index <= currentStep ? Colors.green : Theme.of(context).colorScheme.outlineVariant),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Theme.of(context).colorScheme.primaryContainer
                          : (isActive ? Colors.green.withAlpha(38) : Colors.transparent),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: stepColor,
                        width: isCurrent ? 2 : 2.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 13, color: Colors.green)
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 3,
                      color: index == steps.length - 1
                          ? Colors.transparent
                          : (index < currentStep ? Colors.green : Theme.of(context).colorScheme.outlineVariant),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.green : Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
