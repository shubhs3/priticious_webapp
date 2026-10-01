import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        actions: [
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFC59B27),
              foregroundColor: Colors.white,
            ),
            onPressed: () => context.go('/admin/create-order'),
            icon: const Icon(Icons.add_call, size: 18),
            label: const Text('Book Phone Order'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4A3700),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_call),
        label: const Text('New Phone Order', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => context.go('/admin/create-order'),
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
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

    final isPhoneOrder = order.deliveryInstructions?.toLowerCase().contains('phone') ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(102),
            title: Row(
              children: [
                Text(
                  'ORDER ID: #${order.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (isPhoneOrder) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC59B27).withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC59B27)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.phone_in_talk, size: 12, color: Color(0xFF4A3700)),
                        SizedBox(width: 4),
                        Text('Phone Order', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4A3700))),
                      ],
                    ),
                  ),
                ],
              ],
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
                        Text('Subtotal: ${MoneyFormatter.format(order.subtotal)}'),
                        Text('Delivery: ${MoneyFormatter.format(order.deliveryCharge)}'),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${MoneyFormatter.format(order.total)}',
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
                if (order.deliveryInstructions != null && order.deliveryInstructions!.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6F0),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2D6BC)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.speaker_notes_outlined, size: 14, color: Color(0xFF7A5900)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order.deliveryInstructions!,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF4A3700), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
