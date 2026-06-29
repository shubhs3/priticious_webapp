// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {

 String get id; String get customerId; List<CartItemModel> get items; AddressModel get shippingAddress; int get subtotalInPaise; int get deliveryChargeInPaise; int get totalInPaise; OrderStatus get status; PaymentMethod get paymentMethod; String? get deliveryInstructions; DateTime? get placedAt; DateTime? get updatedAt;
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderModelCopyWith<OrderModel> get copyWith => _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.subtotalInPaise, subtotalInPaise) || other.subtotalInPaise == subtotalInPaise)&&(identical(other.deliveryChargeInPaise, deliveryChargeInPaise) || other.deliveryChargeInPaise == deliveryChargeInPaise)&&(identical(other.totalInPaise, totalInPaise) || other.totalInPaise == totalInPaise)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.deliveryInstructions, deliveryInstructions) || other.deliveryInstructions == deliveryInstructions)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,const DeepCollectionEquality().hash(items),shippingAddress,subtotalInPaise,deliveryChargeInPaise,totalInPaise,status,paymentMethod,deliveryInstructions,placedAt,updatedAt);

@override
String toString() {
  return 'OrderModel(id: $id, customerId: $customerId, items: $items, shippingAddress: $shippingAddress, subtotalInPaise: $subtotalInPaise, deliveryChargeInPaise: $deliveryChargeInPaise, totalInPaise: $totalInPaise, status: $status, paymentMethod: $paymentMethod, deliveryInstructions: $deliveryInstructions, placedAt: $placedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res>  {
  factory $OrderModelCopyWith(OrderModel value, $Res Function(OrderModel) _then) = _$OrderModelCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, List<CartItemModel> items, AddressModel shippingAddress, int subtotalInPaise, int deliveryChargeInPaise, int totalInPaise, OrderStatus status, PaymentMethod paymentMethod, String? deliveryInstructions, DateTime? placedAt, DateTime? updatedAt
});


$AddressModelCopyWith<$Res> get shippingAddress;

}
/// @nodoc
class _$OrderModelCopyWithImpl<$Res>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? items = null,Object? shippingAddress = null,Object? subtotalInPaise = null,Object? deliveryChargeInPaise = null,Object? totalInPaise = null,Object? status = null,Object? paymentMethod = null,Object? deliveryInstructions = freezed,Object? placedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,shippingAddress: null == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as AddressModel,subtotalInPaise: null == subtotalInPaise ? _self.subtotalInPaise : subtotalInPaise // ignore: cast_nullable_to_non_nullable
as int,deliveryChargeInPaise: null == deliveryChargeInPaise ? _self.deliveryChargeInPaise : deliveryChargeInPaise // ignore: cast_nullable_to_non_nullable
as int,totalInPaise: null == totalInPaise ? _self.totalInPaise : totalInPaise // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,deliveryInstructions: freezed == deliveryInstructions ? _self.deliveryInstructions : deliveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,placedAt: freezed == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressModelCopyWith<$Res> get shippingAddress {
  
  return $AddressModelCopyWith<$Res>(_self.shippingAddress, (value) {
    return _then(_self.copyWith(shippingAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  List<CartItemModel> items,  AddressModel shippingAddress,  int subtotalInPaise,  int deliveryChargeInPaise,  int totalInPaise,  OrderStatus status,  PaymentMethod paymentMethod,  String? deliveryInstructions,  DateTime? placedAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.customerId,_that.items,_that.shippingAddress,_that.subtotalInPaise,_that.deliveryChargeInPaise,_that.totalInPaise,_that.status,_that.paymentMethod,_that.deliveryInstructions,_that.placedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  List<CartItemModel> items,  AddressModel shippingAddress,  int subtotalInPaise,  int deliveryChargeInPaise,  int totalInPaise,  OrderStatus status,  PaymentMethod paymentMethod,  String? deliveryInstructions,  DateTime? placedAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderModel():
return $default(_that.id,_that.customerId,_that.items,_that.shippingAddress,_that.subtotalInPaise,_that.deliveryChargeInPaise,_that.totalInPaise,_that.status,_that.paymentMethod,_that.deliveryInstructions,_that.placedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  List<CartItemModel> items,  AddressModel shippingAddress,  int subtotalInPaise,  int deliveryChargeInPaise,  int totalInPaise,  OrderStatus status,  PaymentMethod paymentMethod,  String? deliveryInstructions,  DateTime? placedAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.customerId,_that.items,_that.shippingAddress,_that.subtotalInPaise,_that.deliveryChargeInPaise,_that.totalInPaise,_that.status,_that.paymentMethod,_that.deliveryInstructions,_that.placedAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderModel implements OrderModel {
  const _OrderModel({required this.id, required this.customerId, required final  List<CartItemModel> items, required this.shippingAddress, required this.subtotalInPaise, required this.deliveryChargeInPaise, required this.totalInPaise, required this.status, this.paymentMethod = PaymentMethod.cashOnDelivery, this.deliveryInstructions, this.placedAt, this.updatedAt}): _items = items;
  factory _OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

@override final  String id;
@override final  String customerId;
 final  List<CartItemModel> _items;
@override List<CartItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  AddressModel shippingAddress;
@override final  int subtotalInPaise;
@override final  int deliveryChargeInPaise;
@override final  int totalInPaise;
@override final  OrderStatus status;
@override@JsonKey() final  PaymentMethod paymentMethod;
@override final  String? deliveryInstructions;
@override final  DateTime? placedAt;
@override final  DateTime? updatedAt;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderModelCopyWith<_OrderModel> get copyWith => __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.subtotalInPaise, subtotalInPaise) || other.subtotalInPaise == subtotalInPaise)&&(identical(other.deliveryChargeInPaise, deliveryChargeInPaise) || other.deliveryChargeInPaise == deliveryChargeInPaise)&&(identical(other.totalInPaise, totalInPaise) || other.totalInPaise == totalInPaise)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.deliveryInstructions, deliveryInstructions) || other.deliveryInstructions == deliveryInstructions)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,const DeepCollectionEquality().hash(_items),shippingAddress,subtotalInPaise,deliveryChargeInPaise,totalInPaise,status,paymentMethod,deliveryInstructions,placedAt,updatedAt);

@override
String toString() {
  return 'OrderModel(id: $id, customerId: $customerId, items: $items, shippingAddress: $shippingAddress, subtotalInPaise: $subtotalInPaise, deliveryChargeInPaise: $deliveryChargeInPaise, totalInPaise: $totalInPaise, status: $status, paymentMethod: $paymentMethod, deliveryInstructions: $deliveryInstructions, placedAt: $placedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res> implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(_OrderModel value, $Res Function(_OrderModel) _then) = __$OrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, List<CartItemModel> items, AddressModel shippingAddress, int subtotalInPaise, int deliveryChargeInPaise, int totalInPaise, OrderStatus status, PaymentMethod paymentMethod, String? deliveryInstructions, DateTime? placedAt, DateTime? updatedAt
});


@override $AddressModelCopyWith<$Res> get shippingAddress;

}
/// @nodoc
class __$OrderModelCopyWithImpl<$Res>
    implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? items = null,Object? shippingAddress = null,Object? subtotalInPaise = null,Object? deliveryChargeInPaise = null,Object? totalInPaise = null,Object? status = null,Object? paymentMethod = null,Object? deliveryInstructions = freezed,Object? placedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_OrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemModel>,shippingAddress: null == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as AddressModel,subtotalInPaise: null == subtotalInPaise ? _self.subtotalInPaise : subtotalInPaise // ignore: cast_nullable_to_non_nullable
as int,deliveryChargeInPaise: null == deliveryChargeInPaise ? _self.deliveryChargeInPaise : deliveryChargeInPaise // ignore: cast_nullable_to_non_nullable
as int,totalInPaise: null == totalInPaise ? _self.totalInPaise : totalInPaise // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,deliveryInstructions: freezed == deliveryInstructions ? _self.deliveryInstructions : deliveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,placedAt: freezed == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressModelCopyWith<$Res> get shippingAddress {
  
  return $AddressModelCopyWith<$Res>(_self.shippingAddress, (value) {
    return _then(_self.copyWith(shippingAddress: value));
  });
}
}

// dart format on
