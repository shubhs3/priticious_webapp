import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../../../shared/widgets/responsive_page.dart';
import 'admin_seed_panel.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  static const _modules = [
    ('Product Management', Icons.inventory_2_outlined, '/admin/products'),
    ('Category Management', Icons.category_outlined, '/admin/categories'),
    ('Banner Management', Icons.view_carousel_outlined, '/admin/banners'),
    ('Inventory', Icons.warehouse_outlined, '/admin/inventory'),
    ('Orders', Icons.receipt_long_outlined, '/admin/orders'),
    ('Customers', Icons.people_outline, '/admin/customers'),
    ('Notification Sender', Icons.notifications_active_outlined, '/admin/notifications'),
    ('Sales Dashboard', Icons.analytics_outlined, '/admin/sales'),
  ];

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
        title: const Text('Admin Dashboard'),
        actions: [
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
                SizedBox(height: 16),
                AdminSeedPanel(),
              ],
            );
          }

          return ResponsivePage(
            child: ListView(
              children: [
                const AdminSeedPanel(),
                const SizedBox(height: 24),
                Text(
                  'Modules',
                  style: Theme.of(context).textTheme.titleLarge,
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
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.8,
                      children: [
                        for (final module in _modules)
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => context.go(module.$3),
                              child: Center(
                                child: ListTile(
                                  leading: Icon(module.$2),
                                  title: Text(
                                    module.$1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: const Text('Manage in Firebase'),
                                  trailing: const Icon(Icons.chevron_right),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
