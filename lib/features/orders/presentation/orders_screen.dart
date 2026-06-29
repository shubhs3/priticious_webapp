import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const EmptyState(
        title: 'No orders yet',
        message:
            'Your COD order history and tracking timeline will appear here.',
        icon: Icons.receipt_long_outlined,
      ),
    );
  }
}
