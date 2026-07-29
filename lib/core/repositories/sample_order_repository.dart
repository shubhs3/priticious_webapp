import 'dart:async';

import '../models/order_model.dart';
import 'order_repository.dart';

class SampleOrderRepository implements OrderRepository {
  static final List<OrderModel> _orders = [];
  static final StreamController<List<OrderModel>> _controller =
      StreamController<List<OrderModel>>.broadcast();

  @override
  Stream<List<OrderModel>> watchOrdersForUser(String userId) async* {
    yield _orders.where((o) => o.customerId == userId).toList();
    yield* _controller.stream.map(
      (list) => list.where((o) => o.customerId == userId).toList(),
    );
  }

  @override
  Stream<List<OrderModel>> watchAllOrders() async* {
    yield List.of(_orders);
    yield* _controller.stream;
  }

  @override
  Future<void> placeOrder(OrderModel order) async {
    _orders.add(order);
    _controller.add(List.unmodifiable(_orders));
  }

  @override
  Future<void> updateStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      _controller.add(List.unmodifiable(_orders));
    }
  }
}
