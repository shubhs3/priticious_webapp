import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/banner_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/admin_repository.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../../../core/services/firebase_providers.dart';
import '../../home/application/catalog_providers.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(firestoreProvider));
});

final adminProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return ref.watch(adminRepositoryProvider).watchAllProducts();
  }
  return ref.watch(catalogRepositoryProvider).watchProducts();
});

final adminCategoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return ref.watch(adminRepositoryProvider).watchAllCategories();
  }
  return ref.watch(catalogRepositoryProvider).watchCategories();
});

final adminBannersProvider = StreamProvider<List<BannerModel>>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return ref.watch(adminRepositoryProvider).watchAllBanners();
  }
  return ref.watch(catalogRepositoryProvider).watchBanners();
});

final adminOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return ref.watch(adminRepositoryProvider).watchAllOrders();
  }
  return ref.watch(orderRepositoryProvider).watchAllOrders();
});

final _sampleUsers = [
  UserModel(
    id: 'user_sample_1',
    phoneNumber: '+919999909122',
    displayName: 'Priticious Premium Member',
    email: 'priticiousdryfruits@gmail.com',
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
  ),
  UserModel(
    id: 'user_sample_2',
    phoneNumber: '+919876543210',
    displayName: 'Rajesh Kumar',
    email: 'rajesh.k@example.com',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  ),
  UserModel(
    id: 'user_sample_3',
    phoneNumber: '+919812345678',
    displayName: 'Pooja Sharma',
    email: 'pooja.sharma@example.com',
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
  ),
];

final adminUsersProvider = StreamProvider<List<UserModel>>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return ref.watch(adminRepositoryProvider).watchAllUsers();
  }
  return Stream.value(_sampleUsers);
});

final adminNotificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllNotifications();
});

final adminSettingsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(adminRepositoryProvider).watchSettings();
});

final salesStatsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.watch(adminRepositoryProvider).fetchSalesStats();
});
