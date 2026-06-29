import 'package:freezed_annotation/freezed_annotation.dart';

import 'address_model.dart';
import 'cart_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus { pending, confirmed, packed, shipped, delivered, cancelled }

enum PaymentMethod { cashOnDelivery }

@freezed
abstract class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String customerId,
    required List<CartItemModel> items,
    required AddressModel shippingAddress,
    required int subtotalInPaise,
    required int deliveryChargeInPaise,
    required int totalInPaise,
    required OrderStatus status,
    @Default(PaymentMethod.cashOnDelivery) PaymentMethod paymentMethod,
    String? deliveryInstructions,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
