import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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

      if (!isLoggedIn) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Required: Please sign in or register to place your order.'),
              backgroundColor: Colors.orange,
            ),
          );
          context.go('/login');
        }
        return;
      }

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
        subtotal: summary.subtotal,
        deliveryCharge: summary.deliveryCharge,
        total: summary.total,
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

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Center(
          child: ResponsivePage(
            maxWidth: 500,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF6DF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 48,
                      color: Color(0xFFC59B27),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Login Required to Checkout',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A3700),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Guest ordering is disabled. Please log in or create an account to complete your order and track your delivery in real-time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC59B27),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.login_rounded),
                      label: const Text(
                        'Log In / Register Now',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outlineVariant.withAlpha(60),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: item.imageUrl.isEmpty
                                      ? Icon(
                                          Icons.spa_outlined,
                                          size: 20,
                                          color: Theme.of(context).colorScheme.primary,
                                        )
                                      : (item.imageUrl.startsWith('data:image/')
                                          ? Image.memory(
                                              base64Decode(item.imageUrl.split(';base64,').last),
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 16),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: item.imageUrl,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => const Icon(Icons.image, size: 16),
                                            )),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${item.weightOption.label} × ${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                MoneyFormatter.format(
                                  item.unitPrice * item.quantity,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
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
                            MoneyFormatter.format(summary.subtotal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charges'),
                          Text(
                            summary.deliveryCharge == 0.0
                                ? 'FREE'
                                : MoneyFormatter.format(
                                    summary.deliveryCharge,
                                  ),
                            style: TextStyle(
                              color: summary.deliveryCharge == 0.0
                                  ? Colors.green
                                  : null,
                              fontWeight: summary.deliveryCharge == 0.0
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
                            MoneyFormatter.format(summary.total),
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
