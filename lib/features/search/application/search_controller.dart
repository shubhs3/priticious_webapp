import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product_model.dart';
import '../../home/application/catalog_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryFilterProvider = StateProvider<String?>((ref) => null);

final searchResultsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final products = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final categoryId = ref.watch(selectedCategoryFilterProvider);

  return products.whenData((items) {
    return items.where((product) {
      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.ingredients.any((item) => item.toLowerCase().contains(query));
      final matchesCategory =
          categoryId == null || product.categoryId == categoryId;
      return matchesQuery && matchesCategory;
    }).toList();
  });
});
