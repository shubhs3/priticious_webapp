import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String productId,
    required String name,
    required String imageUrl,
    required ProductWeightOption weightOption,
    required int unitPriceInPaise,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}

@freezed
abstract class CartSummaryModel with _$CartSummaryModel {
  const factory CartSummaryModel({
    required List<CartItemModel> items,
    required int subtotalInPaise,
    required int discountInPaise,
    required int deliveryChargeInPaise,
    required int totalInPaise,
  }) = _CartSummaryModel;

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);
}
