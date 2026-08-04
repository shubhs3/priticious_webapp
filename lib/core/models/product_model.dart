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
