// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      weightOptions: (json['weightOptions'] as List<dynamic>)
          .map((e) => ProductWeightOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      stock: (json['stock'] as num).toInt(),
      nutrition: Map<String, String>.from(json['nutrition'] as Map),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      storageInstructions: json['storageInstructions'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      isNewArrival: json['isNewArrival'] as bool? ?? false,
      isRecentlyAdded: json['isRecentlyAdded'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'imageUrls': instance.imageUrls,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'weightOptions': instance.weightOptions,
      'stock': instance.stock,
      'nutrition': instance.nutrition,
      'ingredients': instance.ingredients,
      'storageInstructions': instance.storageInstructions,
      'isFeatured': instance.isFeatured,
      'isBestSeller': instance.isBestSeller,
      'isNewArrival': instance.isNewArrival,
      'isRecentlyAdded': instance.isRecentlyAdded,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_ProductWeightOption _$ProductWeightOptionFromJson(Map<String, dynamic> json) =>
    _ProductWeightOption(
      label: json['label'] as String,
      grams: (json['grams'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductWeightOptionToJson(
  _ProductWeightOption instance,
) => <String, dynamic>{
  'label': instance.label,
  'grams': instance.grams,
  'price': instance.price,
  'discountPrice': instance.discountPrice,
};
