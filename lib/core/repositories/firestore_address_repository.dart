import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_collections.dart';
import '../models/address_model.dart';
import '../utils/firestore_helpers.dart';
import 'address_repository.dart';

class FirestoreAddressRepository implements AddressRepository {
  FirestoreAddressRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _addresses =>
      _firestore.collection(FirestoreCollections.addresses);

  @override
  Stream<List<AddressModel>> watchAddressesForUser(String userId) {
    return _addresses
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AddressModel.fromJson(docDataWithId(doc)))
              .toList(),
        );
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    final data = jsonToFirestore(address.toJson());
    data.remove('id');

    if (address.isDefault) {
      final batch = _firestore.batch();
      final querySnapshot = await _addresses
          .where('userId', isEqualTo: address.userId)
          .where('isDefault', isEqualTo: true)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
      await batch.commit();
    }

    await _addresses.doc(address.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await _addresses.doc(addressId).delete();
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    final batch = _firestore.batch();

    final querySnapshot = await _addresses
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true)
        .get();

    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }

    batch.update(_addresses.doc(addressId), {'isDefault': true});

    await batch.commit();
  }
}
