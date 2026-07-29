import 'dart:async';

import '../data/seed_data.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'catalog_repository.dart';

class SampleCatalogRepository implements CatalogRepository {
  @override
  Stream<List<BannerModel>> watchBanners() => Stream.value(sampleBanners);

  @override
  Stream<List<CategoryModel>> watchCategories() =>
      Stream.value(sampleCategories);

  @override
  Stream<ProductModel?> watchProduct(String productId) {
    return Stream.value(
      sampleProducts.where((item) => item.id == productId).firstOrNull,
    );
  }

  @override
  Stream<List<ProductModel>> watchProducts() => Stream.value(sampleProducts);
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

