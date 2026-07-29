import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/firestore_collections.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../utils/firestore_helpers.dart';
import 'catalog_repository.dart';

class FirestoreCatalogRepository implements CatalogRepository {
  FirestoreCatalogRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<BannerModel>> watchBanners() {
    return _firestore
        .collection(FirestoreCollections.banners)
        .where('isActive', isEqualTo: true)
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

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return _firestore
        .collection(FirestoreCollections.categories)
        .where('isActive', isEqualTo: true)
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

  @override
  Stream<ProductModel?> watchProduct(String productId) {
    return _firestore
        .collection(FirestoreCollections.products)
        .doc(productId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          final product = ProductModel.fromJson(docDataWithId(doc));
          return product.isActive ? product : null;
        });
  }

  @override
  Stream<List<ProductModel>> watchProducts() {
    return _firestore
        .collection(FirestoreCollections.products)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductModel.fromJson(docDataWithId(doc)),
              )
              .toList(),
        );
  }
}
