// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 String get id; String get categoryId; String get name; String get description; List<String> get imageUrls; double get price; double get discountPrice; List<ProductWeightOption> get weightOptions; int get stock; Map<String, String> get nutrition; List<String> get ingredients; String get storageInstructions; bool get isFeatured; bool get isBestSeller; bool get isNewArrival; bool get isRecentlyAdded; bool get isActive; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountPrice, discountPrice) || other.discountPrice == discountPrice)&&const DeepCollectionEquality().equals(other.weightOptions, weightOptions)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other.nutrition, nutrition)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.storageInstructions, storageInstructions) || other.storageInstructions == storageInstructions)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isBestSeller, isBestSeller) || other.isBestSeller == isBestSeller)&&(identical(other.isNewArrival, isNewArrival) || other.isNewArrival == isNewArrival)&&(identical(other.isRecentlyAdded, isRecentlyAdded) || other.isRecentlyAdded == isRecentlyAdded)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,categoryId,name,description,const DeepCollectionEquality().hash(imageUrls),price,discountPrice,const DeepCollectionEquality().hash(weightOptions),stock,const DeepCollectionEquality().hash(nutrition),const DeepCollectionEquality().hash(ingredients),storageInstructions,isFeatured,isBestSeller,isNewArrival,isRecentlyAdded,isActive,createdAt,updatedAt]);

@override
String toString() {
  return 'ProductModel(id: $id, categoryId: $categoryId, name: $name, description: $description, imageUrls: $imageUrls, price: $price, discountPrice: $discountPrice, weightOptions: $weightOptions, stock: $stock, nutrition: $nutrition, ingredients: $ingredients, storageInstructions: $storageInstructions, isFeatured: $isFeatured, isBestSeller: $isBestSeller, isNewArrival: $isNewArrival, isRecentlyAdded: $isRecentlyAdded, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String name, String description, List<String> imageUrls, double price, double discountPrice, List<ProductWeightOption> weightOptions, int stock, Map<String, String> nutrition, List<String> ingredients, String storageInstructions, bool isFeatured, bool isBestSeller, bool isNewArrival, bool isRecentlyAdded, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? imageUrls = null,Object? price = null,Object? discountPrice = null,Object? weightOptions = null,Object? stock = null,Object? nutrition = null,Object? ingredients = null,Object? storageInstructions = null,Object? isFeatured = null,Object? isBestSeller = null,Object? isNewArrival = null,Object? isRecentlyAdded = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountPrice: null == discountPrice ? _self.discountPrice : discountPrice // ignore: cast_nullable_to_non_nullable
as double,weightOptions: null == weightOptions ? _self.weightOptions : weightOptions // ignore: cast_nullable_to_non_nullable
as List<ProductWeightOption>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Map<String, String>,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,storageInstructions: null == storageInstructions ? _self.storageInstructions : storageInstructions // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isBestSeller: null == isBestSeller ? _self.isBestSeller : isBestSeller // ignore: cast_nullable_to_non_nullable
as bool,isNewArrival: null == isNewArrival ? _self.isNewArrival : isNewArrival // ignore: cast_nullable_to_non_nullable
as bool,isRecentlyAdded: null == isRecentlyAdded ? _self.isRecentlyAdded : isRecentlyAdded // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String description,  List<String> imageUrls,  double price,  double discountPrice,  List<ProductWeightOption> weightOptions,  int stock,  Map<String, String> nutrition,  List<String> ingredients,  String storageInstructions,  bool isFeatured,  bool isBestSeller,  bool isNewArrival,  bool isRecentlyAdded,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.imageUrls,_that.price,_that.discountPrice,_that.weightOptions,_that.stock,_that.nutrition,_that.ingredients,_that.storageInstructions,_that.isFeatured,_that.isBestSeller,_that.isNewArrival,_that.isRecentlyAdded,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String name,  String description,  List<String> imageUrls,  double price,  double discountPrice,  List<ProductWeightOption> weightOptions,  int stock,  Map<String, String> nutrition,  List<String> ingredients,  String storageInstructions,  bool isFeatured,  bool isBestSeller,  bool isNewArrival,  bool isRecentlyAdded,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.imageUrls,_that.price,_that.discountPrice,_that.weightOptions,_that.stock,_that.nutrition,_that.ingredients,_that.storageInstructions,_that.isFeatured,_that.isBestSeller,_that.isNewArrival,_that.isRecentlyAdded,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String name,  String description,  List<String> imageUrls,  double price,  double discountPrice,  List<ProductWeightOption> weightOptions,  int stock,  Map<String, String> nutrition,  List<String> ingredients,  String storageInstructions,  bool isFeatured,  bool isBestSeller,  bool isNewArrival,  bool isRecentlyAdded,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.categoryId,_that.name,_that.description,_that.imageUrls,_that.price,_that.discountPrice,_that.weightOptions,_that.stock,_that.nutrition,_that.ingredients,_that.storageInstructions,_that.isFeatured,_that.isBestSeller,_that.isNewArrival,_that.isRecentlyAdded,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel implements ProductModel {
  const _ProductModel({required this.id, required this.categoryId, required this.name, required this.description, required final  List<String> imageUrls, required this.price, required this.discountPrice, required final  List<ProductWeightOption> weightOptions, required this.stock, required final  Map<String, String> nutrition, required final  List<String> ingredients, required this.storageInstructions, this.isFeatured = false, this.isBestSeller = false, this.isNewArrival = false, this.isRecentlyAdded = false, this.isActive = true, this.createdAt, this.updatedAt}): _imageUrls = imageUrls,_weightOptions = weightOptions,_nutrition = nutrition,_ingredients = ingredients;
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String name;
@override final  String description;
 final  List<String> _imageUrls;
@override List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  double price;
@override final  double discountPrice;
 final  List<ProductWeightOption> _weightOptions;
@override List<ProductWeightOption> get weightOptions {
  if (_weightOptions is EqualUnmodifiableListView) return _weightOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weightOptions);
}

@override final  int stock;
 final  Map<String, String> _nutrition;
@override Map<String, String> get nutrition {
  if (_nutrition is EqualUnmodifiableMapView) return _nutrition;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_nutrition);
}

 final  List<String> _ingredients;
@override List<String> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override final  String storageInstructions;
@override@JsonKey() final  bool isFeatured;
@override@JsonKey() final  bool isBestSeller;
@override@JsonKey() final  bool isNewArrival;
@override@JsonKey() final  bool isRecentlyAdded;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountPrice, discountPrice) || other.discountPrice == discountPrice)&&const DeepCollectionEquality().equals(other._weightOptions, _weightOptions)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other._nutrition, _nutrition)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.storageInstructions, storageInstructions) || other.storageInstructions == storageInstructions)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isBestSeller, isBestSeller) || other.isBestSeller == isBestSeller)&&(identical(other.isNewArrival, isNewArrival) || other.isNewArrival == isNewArrival)&&(identical(other.isRecentlyAdded, isRecentlyAdded) || other.isRecentlyAdded == isRecentlyAdded)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,categoryId,name,description,const DeepCollectionEquality().hash(_imageUrls),price,discountPrice,const DeepCollectionEquality().hash(_weightOptions),stock,const DeepCollectionEquality().hash(_nutrition),const DeepCollectionEquality().hash(_ingredients),storageInstructions,isFeatured,isBestSeller,isNewArrival,isRecentlyAdded,isActive,createdAt,updatedAt]);

@override
String toString() {
  return 'ProductModel(id: $id, categoryId: $categoryId, name: $name, description: $description, imageUrls: $imageUrls, price: $price, discountPrice: $discountPrice, weightOptions: $weightOptions, stock: $stock, nutrition: $nutrition, ingredients: $ingredients, storageInstructions: $storageInstructions, isFeatured: $isFeatured, isBestSeller: $isBestSeller, isNewArrival: $isNewArrival, isRecentlyAdded: $isRecentlyAdded, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String name, String description, List<String> imageUrls, double price, double discountPrice, List<ProductWeightOption> weightOptions, int stock, Map<String, String> nutrition, List<String> ingredients, String storageInstructions, bool isFeatured, bool isBestSeller, bool isNewArrival, bool isRecentlyAdded, bool isActive, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? name = null,Object? description = null,Object? imageUrls = null,Object? price = null,Object? discountPrice = null,Object? weightOptions = null,Object? stock = null,Object? nutrition = null,Object? ingredients = null,Object? storageInstructions = null,Object? isFeatured = null,Object? isBestSeller = null,Object? isNewArrival = null,Object? isRecentlyAdded = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountPrice: null == discountPrice ? _self.discountPrice : discountPrice // ignore: cast_nullable_to_non_nullable
as double,weightOptions: null == weightOptions ? _self._weightOptions : weightOptions // ignore: cast_nullable_to_non_nullable
as List<ProductWeightOption>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,nutrition: null == nutrition ? _self._nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Map<String, String>,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,storageInstructions: null == storageInstructions ? _self.storageInstructions : storageInstructions // ignore: cast_nullable_to_non_nullable
as String,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isBestSeller: null == isBestSeller ? _self.isBestSeller : isBestSeller // ignore: cast_nullable_to_non_nullable
as bool,isNewArrival: null == isNewArrival ? _self.isNewArrival : isNewArrival // ignore: cast_nullable_to_non_nullable
as bool,isRecentlyAdded: null == isRecentlyAdded ? _self.isRecentlyAdded : isRecentlyAdded // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProductWeightOption {

 String get label; int get grams; double get price; double get discountPrice;
/// Create a copy of ProductWeightOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductWeightOptionCopyWith<ProductWeightOption> get copyWith => _$ProductWeightOptionCopyWithImpl<ProductWeightOption>(this as ProductWeightOption, _$identity);

  /// Serializes this ProductWeightOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductWeightOption&&(identical(other.label, label) || other.label == label)&&(identical(other.grams, grams) || other.grams == grams)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountPrice, discountPrice) || other.discountPrice == discountPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,grams,price,discountPrice);

@override
String toString() {
  return 'ProductWeightOption(label: $label, grams: $grams, price: $price, discountPrice: $discountPrice)';
}


}

/// @nodoc
abstract mixin class $ProductWeightOptionCopyWith<$Res>  {
  factory $ProductWeightOptionCopyWith(ProductWeightOption value, $Res Function(ProductWeightOption) _then) = _$ProductWeightOptionCopyWithImpl;
@useResult
$Res call({
 String label, int grams, double price, double discountPrice
});




}
/// @nodoc
class _$ProductWeightOptionCopyWithImpl<$Res>
    implements $ProductWeightOptionCopyWith<$Res> {
  _$ProductWeightOptionCopyWithImpl(this._self, this._then);

  final ProductWeightOption _self;
  final $Res Function(ProductWeightOption) _then;

/// Create a copy of ProductWeightOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? grams = null,Object? price = null,Object? discountPrice = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountPrice: null == discountPrice ? _self.discountPrice : discountPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductWeightOption].
extension ProductWeightOptionPatterns on ProductWeightOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductWeightOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductWeightOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductWeightOption value)  $default,){
final _that = this;
switch (_that) {
case _ProductWeightOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductWeightOption value)?  $default,){
final _that = this;
switch (_that) {
case _ProductWeightOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  int grams,  double price,  double discountPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductWeightOption() when $default != null:
return $default(_that.label,_that.grams,_that.price,_that.discountPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  int grams,  double price,  double discountPrice)  $default,) {final _that = this;
switch (_that) {
case _ProductWeightOption():
return $default(_that.label,_that.grams,_that.price,_that.discountPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  int grams,  double price,  double discountPrice)?  $default,) {final _that = this;
switch (_that) {
case _ProductWeightOption() when $default != null:
return $default(_that.label,_that.grams,_that.price,_that.discountPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductWeightOption implements ProductWeightOption {
  const _ProductWeightOption({required this.label, required this.grams, required this.price, required this.discountPrice});
  factory _ProductWeightOption.fromJson(Map<String, dynamic> json) => _$ProductWeightOptionFromJson(json);

@override final  String label;
@override final  int grams;
@override final  double price;
@override final  double discountPrice;

/// Create a copy of ProductWeightOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductWeightOptionCopyWith<_ProductWeightOption> get copyWith => __$ProductWeightOptionCopyWithImpl<_ProductWeightOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductWeightOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductWeightOption&&(identical(other.label, label) || other.label == label)&&(identical(other.grams, grams) || other.grams == grams)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountPrice, discountPrice) || other.discountPrice == discountPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,grams,price,discountPrice);

@override
String toString() {
  return 'ProductWeightOption(label: $label, grams: $grams, price: $price, discountPrice: $discountPrice)';
}


}

/// @nodoc
abstract mixin class _$ProductWeightOptionCopyWith<$Res> implements $ProductWeightOptionCopyWith<$Res> {
  factory _$ProductWeightOptionCopyWith(_ProductWeightOption value, $Res Function(_ProductWeightOption) _then) = __$ProductWeightOptionCopyWithImpl;
@override @useResult
$Res call({
 String label, int grams, double price, double discountPrice
});




}
/// @nodoc
class __$ProductWeightOptionCopyWithImpl<$Res>
    implements _$ProductWeightOptionCopyWith<$Res> {
  __$ProductWeightOptionCopyWithImpl(this._self, this._then);

  final _ProductWeightOption _self;
  final $Res Function(_ProductWeightOption) _then;

/// Create a copy of ProductWeightOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? grams = null,Object? price = null,Object? discountPrice = null,}) {
  return _then(_ProductWeightOption(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountPrice: null == discountPrice ? _self.discountPrice : discountPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
