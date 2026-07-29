import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/address_model.dart';
import '../../../core/models/banner_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/repositories/address_repository.dart';
import '../../../core/repositories/catalog_repository.dart';
import '../../../core/repositories/firestore_address_repository.dart';
import '../../../core/repositories/firestore_catalog_repository.dart';
import '../../../core/repositories/firestore_order_repository.dart';
import '../../../core/repositories/order_repository.dart';
import '../../../core/repositories/sample_catalog_repository.dart';
import '../../../core/repositories/sample_order_repository.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../../../core/services/firebase_providers.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return FirestoreCatalogRepository(ref.watch(firestoreProvider));
  }
  return SampleCatalogRepository();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return FirestoreOrderRepository(ref.watch(firestoreProvider));
  }
  return SampleOrderRepository();
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  if (FirebaseBootstrap.isInitialized) {
    return FirestoreAddressRepository(ref.watch(firestoreProvider));
  }
  throw UnimplementedError('Address repository only works with Firebase initialized');
});

const guestCustomerId = 'guest';

final currentCustomerIdProvider = Provider<String>((ref) {
  final authUser = ref.watch(firebaseAuthProvider).currentUser;
  return authUser?.uid ?? guestCustomerId;
});

final userAddressesProvider = StreamProvider<List<AddressModel>>((ref) {
  final customerId = ref.watch(currentCustomerIdProvider);
  if (customerId == guestCustomerId) return Stream.value(const []);
  return ref.watch(addressRepositoryProvider).watchAddressesForUser(customerId);
});

final categoriesProvider = StreamProvider<List<CategoryModel>>(
  (ref) => ref.watch(catalogRepositoryProvider).watchCategories(),
);

final bannersProvider = StreamProvider<List<BannerModel>>(
  (ref) => ref.watch(catalogRepositoryProvider).watchBanners(),
);

final productsProvider = StreamProvider<List<ProductModel>>(
  (ref) => ref.watch(catalogRepositoryProvider).watchProducts(),
);

final productProvider = StreamProvider.family<ProductModel?, String>(
  (ref, id) => ref.watch(catalogRepositoryProvider).watchProduct(id),
);

final featuredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((
  ref,
) {
  final products = ref.watch(productsProvider);
  return products.whenData(
    (items) => items.where((item) => item.isFeatured).toList(),
  );
});

final bestSellerProductsProvider = Provider<AsyncValue<List<ProductModel>>>((
  ref,
) {
  final products = ref.watch(productsProvider);
  return products.whenData(
    (items) => items.where((item) => item.isBestSeller).toList(),
  );
});

final newArrivalProductsProvider = Provider<AsyncValue<List<ProductModel>>>((
  ref,
) {
  final products = ref.watch(productsProvider);
  return products.whenData(
    (items) => items.where((item) => item.isNewArrival).toList(),
  );
});

