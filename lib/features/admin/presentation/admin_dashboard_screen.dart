import 'package:flutter/material.dart';

import '../../../shared/widgets/responsive_page.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const _modules = [
    ('Product Management', Icons.inventory_2_outlined),
    ('Category Management', Icons.category_outlined),
    ('Banner Management', Icons.view_carousel_outlined),
    ('Inventory', Icons.warehouse_outlined),
    ('Orders', Icons.receipt_long_outlined),
    ('Customers', Icons.people_outline),
    ('Notification Sender', Icons.notifications_active_outlined),
    ('Sales Dashboard', Icons.analytics_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ResponsivePage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 560
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                for (final module in _modules)
                  Card(
                    child: Center(
                      child: ListTile(
                        leading: Icon(module.$2),
                        title: Text(
                          module.$1,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: const Text('Firebase-backed admin workflow'),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
