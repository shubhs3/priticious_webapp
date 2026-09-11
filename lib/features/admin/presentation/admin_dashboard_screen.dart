import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/order_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';
import 'admin_seed_panel.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  Widget _buildStepRow(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: Colors.amber.shade800,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!FirebaseBootstrap.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              tooltip: 'Back to store',
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.storefront_outlined),
            ),
          ],
        ),
        body: ResponsivePage(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.amber.shade300, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.amber.shade800,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Firebase is not attached or initialized.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.amber.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This project is currently running in local Mockup Mode. '
                      'To enable the Firebase database, authentication, and admin seeding tools, '
                      'you need to create a project in the Firebase Console and configure it for this Flutter app.',
                      style: TextStyle(fontSize: 14, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Follow these steps to connect Firebase properly:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStepRow(
                      '1',
                      'Install the Firebase CLI on your system if you haven\'t already: npm install -g firebase-tools',
                    ),
                    _buildStepRow(
                      '2',
                      'Log in to Firebase using your Google account: firebase login',
                    ),
                    _buildStepRow(
                      '3',
                      'Activate the FlutterFire CLI: dart pub global activate flutterfire_cli',
                    ),
                    _buildStepRow(
                      '4',
                      'Configure your Flutter apps (iOS, Android, Web) automatically by running:\nflutterfire configure --project=priticious-51a56',
                    ),
                    _buildStepRow(
                      '5',
                      'Restart the Flutter app so it initializes the active Firebase options!',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final authState = ref.watch(authStateProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: Color(0xFFC59B27), size: 24),
            SizedBox(width: 8),
            Text('Admin Portal'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Dashboard',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(salesStatsProvider);
              ref.invalidate(adminProductsProvider);
              ref.invalidate(adminOrdersProvider);
            },
          ),
          if (isAdmin)
            IconButton(
              tooltip: 'Sign out',
              onPressed: () => ref.read(adminAuthServiceProvider).signOut(),
              icon: const Icon(Icons.logout),
            ),
          IconButton(
            tooltip: 'Back to store',
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.storefront_outlined),
          ),
        ],
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Auth error: $error')),
        data: (user) {
          if (user == null || !isAdmin) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                AdminLoginPanel(),
              ],
            );
          }

          final statsAsync = ref.watch(salesStatsProvider);
          final productsAsync = ref.watch(adminProductsProvider);
          final ordersAsync = ref.watch(adminOrdersProvider);
          final categoriesAsync = ref.watch(adminCategoriesProvider);
          final usersAsync = ref.watch(adminUsersProvider);

          final products = productsAsync.valueOrNull ?? [];
          final orders = ordersAsync.valueOrNull ?? [];
          final categories = categoriesAsync.valueOrNull ?? [];
          final users = usersAsync.valueOrNull ?? [];

          final lowStockProducts = products.where((p) => p.stock <= 10).toList();
          final pendingOrdersCount = orders.where((o) => o.status == OrderStatus.pending).length;

          final stats = statsAsync.valueOrNull;
          final totalRevenue = (stats?['totalRevenue'] as num?)?.toDouble() ??
              orders.fold<double>(0.0, (sum, o) => sum + o.total);
          final totalOrdersCount = stats?['totalOrders'] as int? ?? orders.length;
          final totalProductsCount = stats?['productCount'] as int? ?? products.length;
          final totalCustomersCount = users.length;

          final todayDate = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

          return ResponsivePage(
            maxWidth: 1100,
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(salesStatsProvider);
                ref.invalidate(adminProductsProvider);
                ref.invalidate(adminOrdersProvider);
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  // 1. Luxury Welcome Hero Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2B2213), Color(0xFF4A3700)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC59B27).withAlpha(50),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC59B27).withAlpha(50),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFC59B27), width: 1),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.workspace_premium, color: Color(0xFFFFD54F), size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'EXECUTIVE DASHBOARD',
                                    style: TextStyle(
                                      color: Color(0xFFFFE082),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              todayDate,
                              style: const TextStyle(
                                color: Color(0xFFD7CCC8),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Priticious Dry Fruits & Nuts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Welcome back, ${user.email ?? "Admin"}! Here is your business overview and operations hub.',
                          style: TextStyle(
                            color: Colors.white.withAlpha(210),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFC59B27),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: () => context.go('/admin/products'),
                              icon: const Icon(Icons.add_circle_outline, size: 18),
                              label: const Text('Add Product'),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Color(0xFFFFD54F), width: 1.2),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: () => context.go('/admin/orders'),
                              icon: const Icon(Icons.receipt_long, size: 18),
                              label: Text('Orders (${orders.length})'),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: BorderSide(color: Colors.white.withAlpha(80)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                              onPressed: () => context.go('/'),
                              icon: const Icon(Icons.storefront, size: 18),
                              label: const Text('View Storefront'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. High-Impact KPI Metric Cards
                  Text(
                    'Business Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 800
                          ? 4
                          : constraints.maxWidth > 480
                              ? 2
                              : 1;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: crossAxisCount == 4 ? 1.5 : 1.7,
                        children: [
                          _KpiStatCard(
                            title: 'Total Revenue',
                            value: MoneyFormatter.format(totalRevenue),
                            subtitle: 'All-time sales',
                            icon: Icons.currency_rupee,
                            iconColor: Colors.green.shade700,
                            bgColor: Colors.green.shade50,
                            accentColor: Colors.green,
                          ),
                          _KpiStatCard(
                            title: 'Total Orders',
                            value: totalOrdersCount.toString(),
                            subtitle: pendingOrdersCount > 0
                                ? '$pendingOrdersCount pending action'
                                : 'All orders fulfilled',
                            icon: Icons.local_mall_outlined,
                            iconColor: Colors.blue.shade700,
                            bgColor: Colors.blue.shade50,
                            accentColor: Colors.blue,
                            badgeText: pendingOrdersCount > 0 ? '$pendingOrdersCount Pending' : null,
                            badgeColor: Colors.orange,
                          ),
                          _KpiStatCard(
                            title: 'Catalog Size',
                            value: totalProductsCount.toString(),
                            subtitle: '${categories.length} Categories active',
                            icon: Icons.inventory_2_outlined,
                            iconColor: const Color(0xFFC59B27),
                            bgColor: const Color(0xFFFFF8E1),
                            accentColor: const Color(0xFFC59B27),
                            badgeText: lowStockProducts.isNotEmpty
                                ? '${lowStockProducts.length} Low Stock'
                                : 'In Stock',
                            badgeColor: lowStockProducts.isNotEmpty ? Colors.amber.shade900 : Colors.teal,
                          ),
                          _KpiStatCard(
                            title: 'Customers',
                            value: totalCustomersCount.toString(),
                            subtitle: 'Registered accounts',
                            icon: Icons.people_alt_outlined,
                            iconColor: Colors.purple.shade700,
                            bgColor: Colors.purple.shade50,
                            accentColor: Colors.purple,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 3. Low Stock Attention Banner (if any item is low stock)
                  if (lowStockProducts.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.amber.shade400, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Inventory Attention: ${lowStockProducts.length} Product(s) Need Restocking',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Items such as "${lowStockProducts.first.name}" have 10 or fewer units left in inventory.',
                                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900.withAlpha(200)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.amber.shade200,
                              foregroundColor: Colors.amber.shade900,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            onPressed: () => context.go('/admin/products'),
                            child: const Text('Manage Stock', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 4. Management Modules Grid
                  Text(
                    'Management Modules',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth > 900
                          ? 4
                          : constraints.maxWidth > 560
                              ? 2
                              : 1;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: columns,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.7,
                        children: [
                          _ModuleCard(
                            title: 'Product Management',
                            subtitle: '${products.length} Products in Catalog',
                            icon: Icons.inventory_2_outlined,
                            route: '/admin/products',
                            badge: '${products.length}',
                            color: const Color(0xFFC59B27),
                          ),
                          _ModuleCard(
                            title: 'Category Management',
                            subtitle: '${categories.length} Active Categories',
                            icon: Icons.category_outlined,
                            route: '/admin/categories',
                            badge: '${categories.length}',
                            color: const Color(0xFF7A5900),
                          ),
                          _ModuleCard(
                            title: 'Order Management',
                            subtitle: '${orders.length} Total Orders',
                            icon: Icons.receipt_long_outlined,
                            route: '/admin/orders',
                            badge: pendingOrdersCount > 0 ? '$pendingOrdersCount Pending' : null,
                            color: Colors.blue.shade700,
                          ),
                          _ModuleCard(
                            title: 'Inventory & Stock',
                            subtitle: '${lowStockProducts.length} Items need attention',
                            icon: Icons.warehouse_outlined,
                            route: '/admin/inventory',
                            badge: lowStockProducts.isNotEmpty ? '${lowStockProducts.length} Alert' : null,
                            color: Colors.deepOrange,
                          ),
                          _ModuleCard(
                            title: 'Customer Directory',
                            subtitle: '${users.length} Registered Accounts',
                            icon: Icons.people_outline,
                            route: '/admin/customers',
                            badge: '${users.length}',
                            color: Colors.teal.shade700,
                          ),
                          _ModuleCard(
                            title: 'Sales & Analytics',
                            subtitle: 'Revenue, orders & trends',
                            icon: Icons.analytics_outlined,
                            route: '/admin/sales',
                            color: Colors.indigo.shade600,
                          ),
                          _ModuleCard(
                            title: 'Banner Management',
                            subtitle: 'Homepage banners & offers',
                            icon: Icons.view_carousel_outlined,
                            route: '/admin/banners',
                            color: Colors.amber.shade800,
                          ),
                          _ModuleCard(
                            title: 'Notification Sender',
                            subtitle: 'Broadcast alerts to app users',
                            icon: Icons.notifications_active_outlined,
                            route: '/admin/notifications',
                            color: Colors.pink.shade700,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // 5. Recent Orders Snapshot Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.go('/admin/orders'),
                        icon: const Text('View All'),
                        label: const Icon(Icons.arrow_forward, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (orders.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            const Text(
                              'No customer orders received yet.',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Incoming customer purchases will be highlighted here in real time.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length > 5 ? 5 : orders.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final dateStr = order.placedAt != null
                              ? DateFormat('dd MMM, hh:mm a').format(order.placedAt!)
                              : 'Recent';
                          final statusInfo = _getOrderStatusInfo(order.status);

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: statusInfo.color.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(statusInfo.icon, color: statusInfo.color, size: 22),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusInfo.color.withAlpha(25),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: statusInfo.color.withAlpha(100), width: 0.8),
                                  ),
                                  child: Text(
                                    order.status.name.toUpperCase(),
                                    style: TextStyle(
                                      color: statusInfo.color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${order.items.length} item(s) • $dateStr • ${order.shippingAddress.city}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            trailing: Text(
                              MoneyFormatter.format(order.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF4A3700),
                              ),
                            ),
                            onTap: () => context.go('/admin/orders'),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static ({Color color, IconData icon}) _getOrderStatusInfo(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => (color: Colors.orange.shade800, icon: Icons.hourglass_empty),
      OrderStatus.confirmed => (color: Colors.blue.shade700, icon: Icons.check_circle_outline),
      OrderStatus.packed => (color: Colors.purple.shade700, icon: Icons.inventory),
      OrderStatus.shipped => (color: Colors.indigo.shade700, icon: Icons.local_shipping_outlined),
      OrderStatus.delivered => (color: Colors.green.shade700, icon: Icons.done_all),
      OrderStatus.cancelled => (color: Colors.red.shade700, icon: Icons.cancel_outlined),
    };
  }
}

class _KpiStatCard extends StatelessWidget {
  const _KpiStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.accentColor,
    this.badgeText,
    this.badgeColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color accentColor;
  final String? badgeText;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accentColor.withAlpha(40), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? accentColor).withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: (badgeColor ?? accentColor).withAlpha(120), width: 0.8),
                    ),
                    child: Text(
                      badgeText!,
                      style: TextStyle(
                        color: badgeColor ?? accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
    this.badge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withAlpha(60), width: 1),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
