// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  shippingAddress: AddressModel.fromJson(
    json['shippingAddress'] as Map<String, dynamic>,
  ),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryCharge: (json['deliveryCharge'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  paymentMethod:
      $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']) ??
      PaymentMethod.cashOnDelivery,
  deliveryInstructions: json['deliveryInstructions'] as String?,
  placedAt: json['placedAt'] == null
      ? null
      : DateTime.parse(json['placedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'items': instance.items,
      'shippingAddress': instance.shippingAddress,
      'subtotal': instance.subtotal,
      'deliveryCharge': instance.deliveryCharge,
      'total': instance.total,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'deliveryInstructions': instance.deliveryInstructions,
      'placedAt': instance.placedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.packed: 'packed',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

const _$PaymentMethodEnumMap = {PaymentMethod.cashOnDelivery: 'cashOnDelivery'};
