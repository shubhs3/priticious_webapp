// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      productId: json['productId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      weightOption: ProductWeightOption.fromJson(
        json['weightOption'] as Map<String, dynamic>,
      ),
      unitPriceInPaise: (json['unitPriceInPaise'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'weightOption': instance.weightOption,
      'unitPriceInPaise': instance.unitPriceInPaise,
      'quantity': instance.quantity,
    };

_CartSummaryModel _$CartSummaryModelFromJson(Map<String, dynamic> json) =>
    _CartSummaryModel(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotalInPaise: (json['subtotalInPaise'] as num).toInt(),
      discountInPaise: (json['discountInPaise'] as num).toInt(),
      deliveryChargeInPaise: (json['deliveryChargeInPaise'] as num).toInt(),
      totalInPaise: (json['totalInPaise'] as num).toInt(),
    );

Map<String, dynamic> _$CartSummaryModelToJson(_CartSummaryModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'subtotalInPaise': instance.subtotalInPaise,
      'discountInPaise': instance.discountInPaise,
      'deliveryChargeInPaise': instance.deliveryChargeInPaise,
      'totalInPaise': instance.totalInPaise,
    };
