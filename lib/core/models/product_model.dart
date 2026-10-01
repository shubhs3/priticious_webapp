import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String categoryId,
    required String name,
    required String description,
    required List<String> imageUrls,
    required double price,
    required double discountPrice,
    required List<ProductWeightOption> weightOptions,
    required int stock,
    required Map<String, String> nutrition,
    required List<String> ingredients,
    required String storageInstructions,
    @Default(false) bool isFeatured,
    @Default(false) bool isBestSeller,
    @Default(false) bool isNewArrival,
    @Default(false) bool isRecentlyAdded,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
abstract class ProductWeightOption with _$ProductWeightOption {
  const factory ProductWeightOption({
    required String label,
    required int grams,
    required double price,
    required double discountPrice,
  }) = _ProductWeightOption;

  factory ProductWeightOption.fromJson(Map<String, dynamic> json) =>
      _$ProductWeightOptionFromJson(json);
}

extension ProductModelExtension on ProductModel {
  List<ProductWeightOption> get standardWeightOptions {
    final baseP = price > 0 ? price : 399.0;
    final baseDp = discountPrice > 0 ? discountPrice : 349.0;

    if (weightOptions.isNotEmpty) {
      final opt250 = weightOptions.where((w) => w.grams == 250 || w.label.contains('250')).firstOrNull;
      final opt500 = weightOptions.where((w) => w.grams == 500 || w.label.contains('500')).firstOrNull;
      final opt1k = weightOptions.where((w) => w.grams == 1000 || w.label.contains('1')).firstOrNull;

      // If the 250g option's discountPrice does not match the product's discountPrice,
      // the weightOptions array in Firestore is out of sync with product.discountPrice (e.g. stale seed data).
      final isOutOfSync = opt250 != null && (opt250.discountPrice != baseDp);

      if (!isOutOfSync && opt250 != null && opt500 != null && opt1k != null) {
        return [opt250, opt500, opt1k];
      }

      // Re-align weight options with this product's actual price and discountPrice
      final p250 = (isOutOfSync || opt250 == null) ? baseP : opt250.price;
      final dp250 = (isOutOfSync || opt250 == null) ? baseDp : opt250.discountPrice;
      final p500 = (isOutOfSync || opt500 == null || opt500.discountPrice <= dp250)
          ? (p250 * 1.9).roundToDouble()
          : opt500.price;
      final dp500 = (isOutOfSync || opt500 == null || opt500.discountPrice <= dp250)
          ? (dp250 * 1.9).roundToDouble()
          : opt500.discountPrice;
      final p1k = (isOutOfSync || opt1k == null || opt1k.discountPrice <= dp500)
          ? (p250 * 3.6).roundToDouble()
          : opt1k.price;
      final dp1k = (isOutOfSync || opt1k == null || opt1k.discountPrice <= dp500)
          ? (dp250 * 3.6).roundToDouble()
          : opt1k.discountPrice;

      return [
        ProductWeightOption(label: '250 g', grams: 250, price: p250, discountPrice: dp250),
        ProductWeightOption(label: '500 g', grams: 500, price: p500, discountPrice: dp500),
        ProductWeightOption(label: '1 kg', grams: 1000, price: p1k, discountPrice: dp1k),
      ];
    }

    return [
      ProductWeightOption(
        label: '250 g',
        grams: 250,
        price: baseP,
        discountPrice: baseDp,
      ),
      ProductWeightOption(
        label: '500 g',
        grams: 500,
        price: (baseP * 1.9).roundToDouble(),
        discountPrice: (baseDp * 1.9).roundToDouble(),
      ),
      ProductWeightOption(
        label: '1 kg',
        grams: 1000,
        price: (baseP * 3.6).roundToDouble(),
        discountPrice: (baseDp * 3.6).roundToDouble(),
      ),
    ];
  }

  ProductWeightOption get defaultWeightOption {
    return standardWeightOptions.first;
  }
}
