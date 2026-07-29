import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_collections.dart';
import '../models/order_model.dart';
import '../utils/firestore_helpers.dart';
import 'order_repository.dart';

class FirestoreOrderRepository implements OrderRepository {
  FirestoreOrderRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection(FirestoreCollections.orders);

  @override
  Stream<List<OrderModel>> watchOrdersForUser(String userId) {
    return _orders
        .where('customerId', isEqualTo: userId)
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => OrderModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  @override
  Stream<List<OrderModel>> watchAllOrders() {
    return _orders
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => OrderModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  @override
  Future<void> placeOrder(OrderModel order) async {
    final data = jsonToFirestore(order.toJson());
    data.remove('id');
    await _orders.doc(order.id).set(data);
  }

  @override
  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _orders.doc(orderId).update({
      'status': status.name,
      'updatedAt': Timestamp.now(),
    });
  }
}
