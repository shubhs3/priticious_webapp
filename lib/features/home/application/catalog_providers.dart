import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/banner_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/repositories/catalog_repository.dart';
import '../../../core/repositories/sample_catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => SampleCatalogRepository(),
);

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
