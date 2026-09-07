import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../services/notification_service.dart';
import '../../features/home/application/catalog_providers.dart';

import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/products/presentation/product_detail_screen.dart';
import '../../features/products/presentation/product_listing_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/info/presentation/about_us_screen.dart';
import '../../features/info/presentation/bulk_order_screen.dart';
import '../../features/info/presentation/locations_screen.dart';
import '../../features/info/presentation/contact_us_screen.dart';


import '../../features/admin/presentation/admin_products_screen.dart';
import '../../features/admin/presentation/admin_categories_screen.dart';
import '../../features/admin/presentation/admin_banners_screen.dart';
import '../../features/admin/presentation/admin_orders_screen.dart';
import '../../features/admin/presentation/admin_sales_screen.dart';
import '../../features/admin/presentation/admin_customers_screen.dart';
import '../../features/admin/presentation/admin_notifications_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => CustomerShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductListingScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    ProductDetailScreen(productId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/about-us',
            builder: (context, state) => const AboutUsScreen(),
          ),
          GoRoute(
            path: '/bulk-order',
            builder: (context, state) => const BulkOrderScreen(),
          ),
          GoRoute(
            path: '/locations',
            builder: (context, state) => const LocationsScreen(),
          ),
          GoRoute(
            path: '/contact-us',
            builder: (context, state) => const ContactUsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'products',
            builder: (context, state) => const AdminProductsScreen(),
          ),
          GoRoute(
            path: 'categories',
            builder: (context, state) => const AdminCategoriesScreen(),
          ),
          GoRoute(
            path: 'banners',
            builder: (context, state) => const AdminBannersScreen(),
          ),
          GoRoute(
            path: 'inventory',
            builder: (context, state) => const AdminProductsScreen(), // share products screen for inventory
          ),
          GoRoute(
            path: 'orders',
            builder: (context, state) => const AdminOrdersScreen(),
          ),
          GoRoute(
            path: 'customers',
            builder: (context, state) => const AdminCustomersScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const AdminNotificationsScreen(),
          ),
          GoRoute(
            path: 'sales',
            builder: (context, state) => const AdminSalesScreen(),
          ),
        ],
      ),
    ],
  );
});

class CustomerShell extends ConsumerWidget {
  const CustomerShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerId = ref.watch(currentCustomerIdProvider);
    if (customerId != guestCustomerId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(notificationServiceProvider).initNotifications(customerId, context);
      });
    }

    final location = GoRouterState.of(context).uri.path;
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: Column(
        children: [
          if (isDesktop) _TopWebHeader(location: location),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _indexFor(location),
              onDestinationSelected: (index) => context.go(_routeFor(index)),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: 'Cart',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Orders',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }

  int _indexFor(String location) {
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/orders')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  String _routeFor(int index) {
    return switch (index) {
      0 => '/',
      1 => '/search',
      2 => '/cart',
      3 => '/orders',
      _ => '/profile',
    };
  }
}

/// Full Desktop Web Navigation Bar (Dry Fruit House Style)
class _TopWebHeader extends StatelessWidget {
  const _TopWebHeader({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Topbar Announcement Bar (Royal Gold)
          Container(
            color: const Color(0xFFC59B27),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Priticious Dry Fruits - Eat Healthy (Nuts & Dry Fruits, Seeds, Dates, Berries and more!)',
                  style: TextStyle(color: Color(0xFF2C1E00), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Icon(Icons.phone, size: 14, color: Color(0xFF4A3700)),
                    SizedBox(width: 6),
                    Text('+91-7483600212 / 9364896022', style: TextStyle(color: Color(0xFF2C1E00), fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 20),
                    Icon(Icons.email_outlined, size: 14, color: Color(0xFF4A3700)),
                    SizedBox(width: 6),
                    Text('info@priticious.com', style: TextStyle(color: Color(0xFF2C1E00), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),

          // Main Header Nav Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                // Brand Logo
                InkWell(
                  onTap: () => context.go('/'),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC59B27),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.spa_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'PRITICIOUS',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Color(0xFF4A3700),
                            ),
                          ),
                          Text(
                            'PREMIUM DRY FRUITS & SPICES',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Color(0xFFC59B27),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Center Navigation Items
                _navButton(context, 'HOME', '/', location == '/'),
                _navButton(context, 'ABOUT US', '/about-us', location == '/about-us'),
                _navButton(context, 'SHOP', '/products', location.startsWith('/products')),
                _navButton(context, 'BULK ORDER', '/bulk-order', location == '/bulk-order'),
                _navButton(context, 'LOCATIONS', '/locations', location == '/locations'),
                _navButton(context, 'CONTACT US', '/contact-us', location == '/contact-us'),

                const Spacer(),

                // Action Icons
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF4A3700)),
                  onPressed: () => context.go('/search'),
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Color(0xFF4A3700)),
                  onPressed: () => context.go('/profile'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC59B27),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text('CART', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, String path, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () => context.go(path),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFFC59B27) : const Color(0xFF4A3700),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
            decoration: isActive ? TextDecoration.underline : TextDecoration.none,
            decorationColor: const Color(0xFFC59B27),
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}

