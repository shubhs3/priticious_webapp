import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/banner_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/admin_repository.dart';
import '../../../core/services/firebase_providers.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(firestoreProvider));
});

final adminProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllProducts();
});

final adminCategoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllCategories();
});

final adminBannersProvider = StreamProvider<List<BannerModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllBanners();
});

final adminOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllOrders();
});

final adminUsersProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllUsers();
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
