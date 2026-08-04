import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminSalesScreen extends ConsumerWidget {
  const AdminSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(salesStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(salesStatsProvider),
          ),
        ],
      ),
      body: ResponsivePage(
        maxWidth: 800,
        child: statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading stats: $error')),
          data: (stats) {
            final revenue = (stats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
            final productCount = stats['productCount'] as int? ?? 0;
            final lowStockCount = stats['lowStockCount'] as int? ?? 0;
            final totalOrders = stats['totalOrders'] as int? ?? 0;
            final pendingOrders = stats['pendingOrders'] as int? ?? 0;
            final deliveredOrders = stats['deliveredOrders'] as int? ?? 0;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _StatCard(
                      title: 'Total Revenue',
                      value: MoneyFormatter.format(revenue),
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                    _StatCard(
                      title: 'Total Orders',
                      value: totalOrders.toString(),
                      icon: Icons.receipt_long_outlined,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      title: 'Pending Orders',
                      value: pendingOrders.toString(),
                      icon: Icons.hourglass_empty,
                      color: Colors.orange,
                    ),
                    _StatCard(
                      title: 'Delivered Orders',
                      value: deliveredOrders.toString(),
                      icon: Icons.local_shipping_outlined,
                      color: Colors.teal,
                    ),
                    _StatCard(
                      title: 'Products in Catalog',
                      value: productCount.toString(),
                      icon: Icons.inventory_2_outlined,
                      color: Colors.indigo,
                    ),
                    _StatCard(
                      title: 'Low Stock Alerts',
                      value: lowStockCount.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
