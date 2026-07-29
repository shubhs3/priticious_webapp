import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/order_model.dart';
import '../../home/application/catalog_providers.dart';

final customerOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final customerId = ref.watch(currentCustomerIdProvider);
  return ref.watch(orderRepositoryProvider).watchOrdersForUser(customerId);
});
