import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_collections.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/notification_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../utils/firestore_helpers.dart';

class AdminRepository {
  AdminRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // ── Products ──

  Stream<List<ProductModel>> watchAllProducts() {
    return _firestore
        .collection(FirestoreCollections.products)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  Future<void> upsertProduct(ProductModel product) async {
    final now = DateTime.now();
    final data = jsonToFirestore(
      product
          .copyWith(
            updatedAt: now,
            createdAt: product.createdAt ?? now,
          )
          .toJson(),
    );
    data.remove('id');
    await _firestore
        .collection(FirestoreCollections.products)
        .doc(product.id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection(FirestoreCollections.products).doc(id).delete();
  }

  Future<void> updateStock(String productId, int stock) async {
    await _firestore.collection(FirestoreCollections.products).doc(productId).update({
      'stock': stock,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> updatePricesBulk(List<Map<String, dynamic>> updates) async {
    for (var i = 0; i < updates.length; i += 500) {
      final chunk = updates.sublist(
        i,
        i + 500 > updates.length ? updates.length : i + 500,
      );
      final batch = _firestore.batch();
      for (final update in chunk) {
        final id = update['id'] as String;
        final docRef = _firestore.collection(FirestoreCollections.products).doc(id);
        batch.update(docRef, {
          'priceInPaise': update['priceInPaise'],
          'discountPriceInPaise': update['discountPriceInPaise'],
          'updatedAt': Timestamp.now(),
        });
      }
      await batch.commit();
    }
  }

  Future<void> insertProductsBulk(List<ProductModel> products) async {
    final now = DateTime.now();
    for (var i = 0; i < products.length; i += 500) {
      final chunk = products.sublist(
        i,
        i + 500 > products.length ? products.length : i + 500,
      );
      final batch = _firestore.batch();
      for (final product in chunk) {
        final docRef = _firestore.collection(FirestoreCollections.products).doc(product.id);
        final data = jsonToFirestore(
          product
              .copyWith(
                updatedAt: now,
                createdAt: product.createdAt ?? now,
              )
              .toJson(),
        );
        data.remove('id');
        batch.set(docRef, data, SetOptions(merge: true));
      }
      await batch.commit();
    }
  }

  // ── Categories ──

  Stream<List<CategoryModel>> watchAllCategories() {
    return _firestore
        .collection(FirestoreCollections.categories)
        .orderBy('sortOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CategoryModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  Future<void> upsertCategory(CategoryModel category) async {
    final data = jsonToFirestore(category.toJson());
    data.remove('id');
    await _firestore
        .collection(FirestoreCollections.categories)
        .doc(category.id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteCategory(String id) async {
    await _firestore.collection(FirestoreCollections.categories).doc(id).delete();
  }

  // ── Banners ──

  Stream<List<BannerModel>> watchAllBanners() {
    return _firestore
        .collection(FirestoreCollections.banners)
        .orderBy('sortOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BannerModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  Future<void> upsertBanner(BannerModel banner) async {
    final data = jsonToFirestore(banner.toJson());
    data.remove('id');
    await _firestore
        .collection(FirestoreCollections.banners)
        .doc(banner.id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteBanner(String id) async {
    await _firestore.collection(FirestoreCollections.banners).doc(id).delete();
  }

  // ── Orders ──

  Stream<List<OrderModel>> watchAllOrders() {
    return _firestore
        .collection(FirestoreCollections.orders)
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

  Stream<List<OrderModel>> watchOrdersForCustomer(String customerId) {
    return _firestore
        .collection(FirestoreCollections.orders)
        .where('customerId', isEqualTo: customerId)
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

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection(FirestoreCollections.orders).doc(orderId).update({
      'status': status.name,
      'updatedAt': Timestamp.now(),
    });
  }

  // ── Users ──

  Stream<List<UserModel>> watchAllUsers() {
    return _firestore
        .collection(FirestoreCollections.users)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => UserModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  // ── Notifications ──

  Stream<List<NotificationModel>> watchAllNotifications() {
    return _firestore
        .collection(FirestoreCollections.notifications)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => NotificationModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }

  Future<void> sendNotification(NotificationModel notification) async {
    final data = jsonToFirestore(
      notification
          .copyWith(createdAt: notification.createdAt ?? DateTime.now())
          .toJson(),
    );
    data.remove('id');
    await _firestore
        .collection(FirestoreCollections.notifications)
        .doc(notification.id)
        .set(data);
  }

  // ── Settings ──

  Stream<Map<String, dynamic>> watchSettings() {
    return _firestore
        .collection(FirestoreCollections.settings)
        .doc('app')
        .snapshots()
        .map((doc) => doc.data() ?? {});
  }

  Future<void> upsertSettings(Map<String, dynamic> settings) async {
    await _firestore
        .collection(FirestoreCollections.settings)
        .doc('app')
        .set(settings, SetOptions(merge: true));
  }

  // ── Stats ──

  Future<Map<String, dynamic>> fetchSalesStats() async {
    final ordersSnapshot = await _firestore
        .collection(FirestoreCollections.orders)
        .get();
    final productsSnapshot = await _firestore
        .collection(FirestoreCollections.products)
        .get();

    var totalRevenue = 0;
    var pendingOrders = 0;
    var deliveredOrders = 0;

    for (final doc in ordersSnapshot.docs) {
      final data = doc.data();
      final status = data['status'] as String? ?? 'pending';
      final total = (data['totalInPaise'] as num?)?.toInt() ?? 0;
      if (status == 'delivered') {
        deliveredOrders++;
        totalRevenue += total;
      } else if (status != 'cancelled') {
        pendingOrders++;
      }
    }

    var lowStockCount = 0;
    for (final doc in productsSnapshot.docs) {
      final stock = (doc.data()['stock'] as num?)?.toInt() ?? 0;
      if (stock < 20) lowStockCount++;
    }

    return {
      'totalOrders': ordersSnapshot.docs.length,
      'pendingOrders': pendingOrders,
      'deliveredOrders': deliveredOrders,
      'totalRevenueInPaise': totalRevenue,
      'productCount': productsSnapshot.docs.length,
      'lowStockCount': lowStockCount,
    };
  }
}
