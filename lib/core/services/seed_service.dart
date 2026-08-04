import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../constants/firestore_collections.dart';
import '../data/seed_data.dart';
import '../models/address_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../utils/firestore_helpers.dart';

enum SeedType { categories, products, banners, settings, orders }

class SeedService {
  SeedService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final _uuid = const Uuid();

  Future<String> seed(SeedType type) async {
    switch (type) {
      case SeedType.categories:
        return _seedCategories();
      case SeedType.products:
        return _seedProducts();
      case SeedType.banners:
        return _seedBanners();
      case SeedType.settings:
        return _seedSettings();
      case SeedType.orders:
        return _seedOrders();
    }
  }

  Future<String> _seedCategories() async {
    final batch = _firestore.batch();
    for (final (index, category) in sampleCategories.indexed) {
      final data = jsonToFirestore(
        category.copyWith(sortOrder: index).toJson(),
      );
      data.remove('id');
      batch.set(
        _firestore.collection(FirestoreCollections.categories).doc(category.id),
        data,
      );
    }
    await batch.commit();
    return 'Seeded ${sampleCategories.length} categories';
  }

  Future<String> _seedProducts() async {
    final batch = _firestore.batch();
    final now = DateTime.now();
    for (final product in sampleProducts) {
      final data = jsonToFirestore(
        product
            .copyWith(
              createdAt: now,
              updatedAt: now,
            )
            .toJson(),
      );
      data.remove('id');
      batch.set(
        _firestore.collection(FirestoreCollections.products).doc(product.id),
        data,
      );
    }
    await batch.commit();
    return 'Seeded ${sampleProducts.length} products';
  }

  Future<String> _seedBanners() async {
    final batch = _firestore.batch();
    for (final (index, banner) in sampleBanners.indexed) {
      final data = jsonToFirestore(
        banner.copyWith(sortOrder: index).toJson(),
      );
      data.remove('id');
      batch.set(
        _firestore.collection(FirestoreCollections.banners).doc(banner.id),
        data,
      );
    }
    await batch.commit();
    return 'Seeded ${sampleBanners.length} banners';
  }

  Future<String> _seedSettings() async {
    await _firestore
        .collection(FirestoreCollections.settings)
        .doc('app')
        .set(sampleSettings);
    return 'Seeded app settings';
  }

  Future<String> _seedOrders() async {
    final product = sampleProducts.first;
    final weight = product.weightOptions.first;
    final now = DateTime.now();

    final sampleOrder = OrderModel(
      id: _uuid.v4(),
      customerId: 'guest',
      items: [
        CartItemModel(
          productId: product.id,
          name: product.name,
          imageUrl: '',
          weightOption: weight,
          unitPrice: weight.discountPrice,
          quantity: 2,
        ),
      ],
      shippingAddress: const AddressModel(
        id: 'sample',
        userId: 'guest',
        fullName: 'Sample Customer',
        phoneNumber: '+91 9876543210',
        line1: '123 MG Road',
        city: 'Mumbai',
        state: 'Maharashtra',
        postalCode: '400001',
        country: 'India',
      ),
      subtotal: weight.discountPrice * 2,
      deliveryCharge: 49.0,
      total: weight.discountPrice * 2 + 49.0,
      status: OrderStatus.pending,
      placedAt: now,
      updatedAt: now,
    );

    final data = jsonToFirestore(sampleOrder.toJson());
    data.remove('id');
    await _firestore
        .collection(FirestoreCollections.orders)
        .doc(sampleOrder.id)
        .set(data);

    return 'Seeded 1 sample order';
  }

  Future<void> ensureAdminUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection(FirestoreCollections.users).doc(user.uid).set(
      {
        'id': user.uid,
        'phoneNumber': user.phoneNumber ?? '',
        'email': user.email,
        'displayName': user.displayName ?? 'Admin',
        'role': 'admin',
        'isActive': true,
        'createdAt': Timestamp.now(),
        'lastLoginAt': Timestamp.now(),
      },
      SetOptions(merge: true),
    );
  }
}
