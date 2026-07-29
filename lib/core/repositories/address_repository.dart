import '../models/address_model.dart';

abstract class AddressRepository {
  Stream<List<AddressModel>> watchAddressesForUser(String userId);
  Future<void> saveAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String userId, String addressId);
}


