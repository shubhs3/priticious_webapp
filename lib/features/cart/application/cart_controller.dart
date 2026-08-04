import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/models/product_model.dart';

final cartControllerProvider =
    StateNotifierProvider<CartController, List<CartItemModel>>(
      (ref) => CartController(),
    );

final cartSummaryProvider = Provider<CartSummaryModel>((ref) {
  final items = ref.watch(cartControllerProvider);
  final subtotal = items.fold<double>(
    0.0,
    (total, item) => total + item.unitPrice * item.quantity,
  );
  final delivery =
      !AppConstants.enableDeliveryCharges ||
      subtotal >= AppConstants.freeDeliveryThreshold ||
      subtotal == 0.0
      ? 0.0
      : AppConstants.standardDeliveryCharge;

  return CartSummaryModel(
    items: items,
    subtotal: subtotal,
    discount: 0.0,
    deliveryCharge: delivery,
    total: subtotal + delivery,
  );
});

class CartController extends StateNotifier<List<CartItemModel>> {
  CartController() : super(const []);

  void addProduct(ProductModel product, ProductWeightOption weightOption) {
    final existingIndex = state.indexWhere(
      (item) =>
          item.productId == product.id && item.weightOption == weightOption,
    );
    if (existingIndex == -1) {
      state = [
        ...state,
        CartItemModel(
          productId: product.id,
          name: product.name,
          imageUrl: product.imageUrls.firstOrNull ?? '',
          weightOption: weightOption,
          unitPrice: weightOption.discountPrice,
          quantity: 1,
        ),
      ];
      return;
    }

    state = [
      for (final (index, item) in state.indexed)
        if (index == existingIndex)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void updateQuantity(CartItemModel cartItem, int quantity) {
    if (quantity <= 0) {
      remove(cartItem);
      return;
    }
    state = [
      for (final item in state)
        if (_matches(item, cartItem))
          item.copyWith(quantity: quantity)
        else
          item,
    ];
  }

  void remove(CartItemModel cartItem) {
    state = [
      for (final item in state)
        if (!_matches(item, cartItem)) item,
    ];
  }

  void clear() {
    state = const [];
  }

  bool _matches(CartItemModel left, CartItemModel right) {
    return left.productId == right.productId &&
        left.weightOption == right.weightOption;
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
