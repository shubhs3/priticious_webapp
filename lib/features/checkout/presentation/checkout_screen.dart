import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/address_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../features/cart/application/cart_controller.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../home/application/catalog_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();

  bool _isPlacingOrder = false;
  bool _saveToProfile = true;
  AddressModel? _selectedAddress;
  bool _hasInitialAddressLoaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacingOrder = true);

    try {
      final summary = ref.read(cartSummaryProvider);
      final customerId = ref.read(currentCustomerIdProvider);
      final isLoggedIn = customerId != guestCustomerId;
      final uuid = const Uuid().v4();

      final address = AddressModel(
        id: _selectedAddress?.id ?? const Uuid().v4(),
        userId: customerId,
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        line1: _addressController.text.trim(),
        city: _selectedAddress?.city ?? 'Local',
        state: _selectedAddress?.state ?? 'Local',
        postalCode: _selectedAddress?.postalCode ?? '000000',
        country: 'India',
        isDefault: _selectedAddress?.isDefault ?? false,
      );

      if (_saveToProfile && isLoggedIn) {
        await ref.read(addressRepositoryProvider).saveAddress(address);
      }

      final order = OrderModel(
        id: uuid,
        customerId: customerId,
        items: summary.items,
        shippingAddress: address,
        subtotalInPaise: summary.subtotalInPaise,
        deliveryChargeInPaise: summary.deliveryChargeInPaise,
        totalInPaise: summary.totalInPaise,
        status: OrderStatus.pending,
        paymentMethod: PaymentMethod.cashOnDelivery,
        deliveryInstructions: _instructionsController.text.trim().isEmpty
            ? null
            : _instructionsController.text.trim(),
        placedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(orderRepositoryProvider).placeOrder(order);

      if (mounted) {
        ref.read(cartControllerProvider.notifier).clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('COD Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/orders');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(cartSummaryProvider);
    final customerId = ref.watch(currentCustomerIdProvider);
    final isLoggedIn = customerId != guestCustomerId;

    ref.listen<AsyncValue<List<AddressModel>>>(userAddressesProvider, (previous, next) {
      next.whenData((addresses) {
        if (addresses.isNotEmpty && !_hasInitialAddressLoaded) {
          final defaultAddr = addresses.firstWhere(
            (addr) => addr.isDefault,
            orElse: () => addresses.first,
          );
          setState(() {
            _selectedAddress = defaultAddr;
            _nameController.text = defaultAddr.fullName;
            _phoneController.text = defaultAddr.phoneNumber;
            _addressController.text = defaultAddr.line2 != null
                ? '${defaultAddr.line1}, ${defaultAddr.line2}'
                : defaultAddr.line1;
            _hasInitialAddressLoaded = true;
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ResponsivePage(
        maxWidth: 760,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              if (isLoggedIn)
                ref.watch(userAddressesProvider).when(
                  data: (addresses) {
                    if (addresses.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<AddressModel>(
                        value: _selectedAddress,
                        decoration: const InputDecoration(
                          labelText: 'Select Saved Address',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        items: addresses.map((addr) {
                          return DropdownMenuItem(
                            value: addr,
                            child: Text(
                              '${addr.fullName} - ${addr.line1}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (addr) {
                          if (addr != null) {
                            setState(() {
                              _selectedAddress = addr;
                              _nameController.text = addr.fullName;
                              _phoneController.text = addr.phoneNumber;
                              _addressController.text = addr.line2 != null
                                  ? '${addr.line1}, ${addr.line2}'
                                  : addr.line1;
                            });
                          }
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.trim().length < 8) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Detailed Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your delivery address';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a detailed address';
                  }
                  return null;
                },
              ),
              if (isLoggedIn) ...[
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Save address to profile for future orders'),
                  value: _saveToProfile,
                  onChanged: (val) => setState(() => _saveToProfile = val ?? false),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _instructionsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Delivery instructions (Optional)',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      for (final item in summary.items)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity} × ${item.name} (${item.weightOption.label})',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              Text(
                                MoneyFormatter.formatPaise(
                                  item.unitPriceInPaise * item.quantity,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text(
                            MoneyFormatter.formatPaise(summary.subtotalInPaise),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charges'),
                          Text(
                            summary.deliveryChargeInPaise == 0
                                ? 'FREE'
                                : MoneyFormatter.formatPaise(
                                    summary.deliveryChargeInPaise,
                                  ),
                            style: TextStyle(
                              color: summary.deliveryChargeInPaise == 0
                                  ? Colors.green
                                  : null,
                              fontWeight: summary.deliveryChargeInPaise == 0
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Payable (COD)',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            MoneyFormatter.formatPaise(summary.totalInPaise),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: (summary.items.isEmpty || _isPlacingOrder)
                    ? null
                    : _placeOrder,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Place COD Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
