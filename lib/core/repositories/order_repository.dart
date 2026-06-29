import '../models/order_model.dart';

abstract interface class OrderRepository {
  Stream<List<OrderModel>> watchOrdersForUser(String userId);
  Future<void> placeOrder(OrderModel order);
  Future<void> updateStatus(String orderId, OrderStatus status);
}
