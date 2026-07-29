import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/models/order_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
      ),
      body: ResponsivePage(
        maxWidth: 840,
        child: ordersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading orders: $error')),
          data: (orders) {
            if (orders.isEmpty) {
              return const EmptyState(
                title: 'No orders found',
                message: 'Customer purchases will appear here.',
                icon: Icons.receipt_long_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _AdminOrderCard(order: order);
              },
            );
          },
        ),
      ),
    );
  }
}

class _AdminOrderCard extends ConsumerWidget {
  const _AdminOrderCard({required this.order});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final formattedDate = order.placedAt != null ? dateFormat.format(order.placedAt!) : 'Date N/A';
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
            title: Text(
              'ORDER ID: #${order.id.substring(0, 8).toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(formattedDate),
            trailing: PopupMenuButton<OrderStatus>(
              initialValue: order.status,
              onSelected: (status) async {
                await ref.read(adminRepositoryProvider).updateOrderStatus(order.id, status);
              },
              itemBuilder: (context) => OrderStatus.values.map((status) {
                return PopupMenuItem<OrderStatus>(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(status.name.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.name.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Items Ordered:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('- ${item.quantity} × ${item.name} (${item.weightOption.label})'),
                    )),
                const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Shipping Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(order.shippingAddress.fullName),
                          Text('Phone: ${order.shippingAddress.phoneNumber}'),
                          Text(order.shippingAddress.line1),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Subtotal: ${MoneyFormatter.formatPaise(order.subtotalInPaise)}'),
                        Text('Delivery: ${MoneyFormatter.formatPaise(order.deliveryChargeInPaise)}'),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${MoneyFormatter.formatPaise(order.totalInPaise)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
