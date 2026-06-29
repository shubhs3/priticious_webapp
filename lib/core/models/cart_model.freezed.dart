// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemModel {

 String get productId; String get name; String get imageUrl; ProductWeightOption get weightOption; int get unitPriceInPaise; int get quantity;
/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemModelCopyWith<CartItemModel> get copyWith => _$CartItemModelCopyWithImpl<CartItemModel>(this as CartItemModel, _$identity);

  /// Serializes this CartItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.weightOption, weightOption) || other.weightOption == weightOption)&&(identical(other.unitPriceInPaise, unitPriceInPaise) || other.unitPriceInPaise == unitPriceInPaise)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,imageUrl,weightOption,unitPriceInPaise,quantity);

@override
String toString() {
  return 'CartItemModel(productId: $productId, name: $name, imageUrl: $imageUrl, weightOption: $weightOption, unitPriceInPaise: $unitPriceInPaise, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $CartItemModelCopyWith<$Res>  {
  factory $CartItemModelCopyWith(CartItemModel value, $Res Function(CartItemModel) _then) = _$CartItemModelCopyWithImpl;
@useResult
$Res call({
 String productId, String name, String imageUrl, ProductWeightOption weightOption, int unitPriceInPaise, int quantity
});


$ProductWeightOptionCopyWith<$Res> get weightOption;

}
/// @nodoc
class _$CartItemModelCopyWithImpl<$Res>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._self, this._then);

  final CartItemModel _self;
  final $Res Function(CartItemModel) _then;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? imageUrl = null,Object? weightOption = null,Object? unitPriceInPaise = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,weightOption: null == weightOption ? _self.weightOption : weightOption // ignore: cast_nullable_to_non_nullable
as ProductWeightOption,unitPriceInPaise: null == unitPriceInPaise ? _self.unitPriceInPaise : unitPriceInPaise // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductWeightOptionCopyWith<$Res> get weightOption {
  
  return $ProductWeightOptionCopyWith<$Res>(_self.weightOption, (value) {
    return _then(_self.copyWith(weightOption: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartItemModel].
extension CartItemModelPatterns on CartItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemModel value)  $default,){
final _that = this;
switch (_that) {
case _CartItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  String imageUrl,  ProductWeightOption weightOption,  int unitPriceInPaise,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that.productId,_that.name,_that.imageUrl,_that.weightOption,_that.unitPriceInPaise,_that.quantity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  String imageUrl,  ProductWeightOption weightOption,  int unitPriceInPaise,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _CartItemModel():
return $default(_that.productId,_that.name,_that.imageUrl,_that.weightOption,_that.unitPriceInPaise,_that.quantity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  String imageUrl,  ProductWeightOption weightOption,  int unitPriceInPaise,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that.productId,_that.name,_that.imageUrl,_that.weightOption,_that.unitPriceInPaise,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartItemModel implements CartItemModel {
  const _CartItemModel({required this.productId, required this.name, required this.imageUrl, required this.weightOption, required this.unitPriceInPaise, required this.quantity});
  factory _CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

@override final  String productId;
@override final  String name;
@override final  String imageUrl;
@override final  ProductWeightOption weightOption;
@override final  int unitPriceInPaise;
@override final  int quantity;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemModelCopyWith<_CartItemModel> get copyWith => __$CartItemModelCopyWithImpl<_CartItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.weightOption, weightOption) || other.weightOption == weightOption)&&(identical(other.unitPriceInPaise, unitPriceInPaise) || other.unitPriceInPaise == unitPriceInPaise)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,imageUrl,weightOption,unitPriceInPaise,quantity);

@override
String toString() {
  return 'CartItemModel(productId: $productId, name: $name, imageUrl: $imageUrl, weightOption: $weightOption, unitPriceInPaise: $unitPriceInPaise, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$CartItemModelCopyWith<$Res> implements $CartItemModelCopyWith<$Res> {
  factory _$CartItemModelCopyWith(_CartItemModel value, $Res Function(_CartItemModel) _then) = __$CartItemModelCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, String imageUrl, ProductWeightOption weightOption, int unitPriceInPaise, int quantity
});


@override $ProductWeightOptionCopyWith<$Res> get weightOption;

}
/// @nodoc
class __$CartItemModelCopyWithImpl<$Res>
    implements _$CartItemModelCopyWith<$Res> {
  __$CartItemModelCopyWithImpl(this._self, this._then);

  final _CartItemModel _self;
  final $Res Function(_CartItemModel) _then;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? imageUrl = null,Object? weightOption = null,Object? unitPriceInPaise = null,Object? quantity = null,}) {
  return _then(_CartItemModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,weightOption: null == weightOption ? _self.weightOption : weightOption // ignore: cast_nullable_to_non_nullable
as ProductWeightOption,unitPriceInPaise: null == unitPriceInPaise ? _self.unitPriceInPaise : unitPriceInPaise // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductWeightOptionCopyWith<$Res> get weightOption {
  
  return $ProductWeightOptionCopyWith<$Res>(_self.weightOption, (value) {
    return _then(_self.copyWith(weightOption: value));
  });
}
}


/// @nodoc
mixin _$CartSummaryModel {

 List<CartItemModel> get items; int get subtotalInPaise; int get discountInPaise; int get deliveryChargeInPaise; int get totalInPaise;
/// Create a copy of CartSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartSummaryModelCopyWith<CartSummaryModel> get copyWith => _$CartSummaryModelCopyWithImpl<CartSummaryModel>(this as CartSummaryModel, _$identity);

  /// Serializes this CartSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartSummaryModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalInPaise, subtotalInPaise) || other.subtotalInPaise == subtotalInPaise)&&(identical(other.discountInPaise, discountInPaise) || other.discountInPaise == discountInPaise)&&(identical(other.deliveryChargeInPaise, deliveryChargeInPaise) || other.deliveryChargeInPaise == deliveryChargeInPaise)&&(identical(other.totalInPaise, totalInPaise) || other.totalInPaise == totalInPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),subtotalInPaise,discountInPaise,deliveryChargeInPaise,totalInPaise);

@override
String toString() {
  return 'CartSummaryModel(items: $items, subtotalInPaise: $subtotalInPaise, discountInPaise: $discountInPaise, deliveryChargeInPaise: $deliveryChargeInPaise, totalInPaise: $totalInPaise)';
}


}

/// @nodoc
abstract mixin class $CartSummaryModelCopyWith<$Res>  {
  factory $CartSummaryModelCopyWith(CartSummaryModel value, $Res Function(CartSummaryModel) _then) = _$CartSummaryModelCopyWithImpl;
@useResult
$Res call({
 List<CartItemModel> items, int subtotalInPaise, int discountInPaise, int deliveryChargeInPaise, int totalInPaise
});




}
/// @nodoc
class _$CartSummaryModelCopyWithImpl<$Res>
    implements $CartSummaryModelCopyWith<$Res> {
  _$CartSummaryModelCopyWithImpl(this._self, this._then);

  final CartSummaryModel _self;
  final $Res Function(CartSummaryModel) _then;

/// Create a copy of CartSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? subtotalInPaise = null,Object? discountInPaise = null,Object? deliveryChargeInPaise = null,Object? totalInPaise = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,subtotalInPaise: null == subtotalInPaise ? _self.subtotalInPaise : subtotalInPaise // ignore: cast_nullable_to_non_nullable
as int,discountInPaise: null == discountInPaise ? _self.discountInPaise : discountInPaise // ignore: cast_nullable_to_non_nullable
as int,deliveryChargeInPaise: null == deliveryChargeInPaise ? _self.deliveryChargeInPaise : deliveryChargeInPaise // ignore: cast_nullable_to_non_nullable
as int,totalInPaise: null == totalInPaise ? _self.totalInPaise : totalInPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CartSummaryModel].
extension CartSummaryModelPatterns on CartSummaryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartSummaryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _CartSummaryModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CartSummaryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CartItemModel> items,  int subtotalInPaise,  int discountInPaise,  int deliveryChargeInPaise,  int totalInPaise)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartSummaryModel() when $default != null:
return $default(_that.items,_that.subtotalInPaise,_that.discountInPaise,_that.deliveryChargeInPaise,_that.totalInPaise);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CartItemModel> items,  int subtotalInPaise,  int discountInPaise,  int deliveryChargeInPaise,  int totalInPaise)  $default,) {final _that = this;
switch (_that) {
case _CartSummaryModel():
return $default(_that.items,_that.subtotalInPaise,_that.discountInPaise,_that.deliveryChargeInPaise,_that.totalInPaise);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CartItemModel> items,  int subtotalInPaise,  int discountInPaise,  int deliveryChargeInPaise,  int totalInPaise)?  $default,) {final _that = this;
switch (_that) {
case _CartSummaryModel() when $default != null:
return $default(_that.items,_that.subtotalInPaise,_that.discountInPaise,_that.deliveryChargeInPaise,_that.totalInPaise);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartSummaryModel implements CartSummaryModel {
  const _CartSummaryModel({required final  List<CartItemModel> items, required this.subtotalInPaise, required this.discountInPaise, required this.deliveryChargeInPaise, required this.totalInPaise}): _items = items;
  factory _CartSummaryModel.fromJson(Map<String, dynamic> json) => _$CartSummaryModelFromJson(json);

 final  List<CartItemModel> _items;
@override List<CartItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int subtotalInPaise;
@override final  int discountInPaise;
@override final  int deliveryChargeInPaise;
@override final  int totalInPaise;

/// Create a copy of CartSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartSummaryModelCopyWith<_CartSummaryModel> get copyWith => __$CartSummaryModelCopyWithImpl<_CartSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartSummaryModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalInPaise, subtotalInPaise) || other.subtotalInPaise == subtotalInPaise)&&(identical(other.discountInPaise, discountInPaise) || other.discountInPaise == discountInPaise)&&(identical(other.deliveryChargeInPaise, deliveryChargeInPaise) || other.deliveryChargeInPaise == deliveryChargeInPaise)&&(identical(other.totalInPaise, totalInPaise) || other.totalInPaise == totalInPaise));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),subtotalInPaise,discountInPaise,deliveryChargeInPaise,totalInPaise);

@override
String toString() {
  return 'CartSummaryModel(items: $items, subtotalInPaise: $subtotalInPaise, discountInPaise: $discountInPaise, deliveryChargeInPaise: $deliveryChargeInPaise, totalInPaise: $totalInPaise)';
}


}

/// @nodoc
abstract mixin class _$CartSummaryModelCopyWith<$Res> implements $CartSummaryModelCopyWith<$Res> {
  factory _$CartSummaryModelCopyWith(_CartSummaryModel value, $Res Function(_CartSummaryModel) _then) = __$CartSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 List<CartItemModel> items, int subtotalInPaise, int discountInPaise, int deliveryChargeInPaise, int totalInPaise
});




}
/// @nodoc
class __$CartSummaryModelCopyWithImpl<$Res>
    implements _$CartSummaryModelCopyWith<$Res> {
  __$CartSummaryModelCopyWithImpl(this._self, this._then);

  final _CartSummaryModel _self;
  final $Res Function(_CartSummaryModel) _then;

/// Create a copy of CartSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? subtotalInPaise = null,Object? discountInPaise = null,Object? deliveryChargeInPaise = null,Object? totalInPaise = null,}) {
  return _then(_CartSummaryModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,subtotalInPaise: null == subtotalInPaise ? _self.subtotalInPaise : subtotalInPaise // ignore: cast_nullable_to_non_nullable
as int,discountInPaise: null == discountInPaise ? _self.discountInPaise : discountInPaise // ignore: cast_nullable_to_non_nullable
as int,deliveryChargeInPaise: null == deliveryChargeInPaise ? _self.deliveryChargeInPaise : deliveryChargeInPaise // ignore: cast_nullable_to_non_nullable
as int,totalInPaise: null == totalInPaise ? _self.totalInPaise : totalInPaise // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
