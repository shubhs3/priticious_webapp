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
    required double unitPrice,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}

@freezed
abstract class CartSummaryModel with _$CartSummaryModel {
  const factory CartSummaryModel({
    required List<CartItemModel> items,
    required double subtotal,
    required double discount,
    required double deliveryCharge,
    required double total,
  }) = _CartSummaryModel;

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryModelFromJson(json);
}
