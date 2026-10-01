import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/address_model.dart';
import '../../../core/models/cart_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../home/application/catalog_providers.dart';
import '../application/admin_providers.dart';

class AdminCreateOrderScreen extends ConsumerStatefulWidget {
  const AdminCreateOrderScreen({super.key, this.initialCustomer});

  final UserModel? initialCustomer;

  @override
  ConsumerState<AdminCreateOrderScreen> createState() => _AdminCreateOrderScreenState();
}

class _AdminCreateOrderScreenState extends ConsumerState<AdminCreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Customer state
  bool _isExistingCustomer = true;
  UserModel? _selectedUser;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // Address state
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _stateController = TextEditingController(text: 'Karnataka');
  final _postalCodeController = TextEditingController();
  final _callNotesController = TextEditingController(text: 'Order placed via phone call with admin.');

  // Order items state
  final List<CartItemModel> _orderItems = [];

  // Currently selected product to add
  ProductModel? _selectedProduct;
  ProductWeightOption? _selectedWeightOption;
  int _itemQuantity = 1;

  // Pricing & Payment
  bool _waiveDeliveryFee = false;
  double _customDiscount = 0.0;
  final _discountController = TextEditingController(text: '0');
  final _paymentMethod = PaymentMethod.cashOnDelivery;
  String _paymentOptionName = 'Cash on Delivery (COD)';
  OrderStatus _initialStatus = OrderStatus.confirmed;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCustomer != null) {
      _applyCustomer(widget.initialCustomer!);
    }
  }

  void _applyCustomer(UserModel user) {
    setState(() {
      _selectedUser = user;
      _isExistingCustomer = true;
      _nameController.text = user.displayName ?? '';
      _phoneController.text = user.phoneNumber;
      _emailController.text = user.email ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _callNotesController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  double get _subtotal => _orderItems.fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));

  double get _deliveryCharge {
    if (_waiveDeliveryFee) return 0.0;
    if (_subtotal >= 999.0 || _subtotal == 0.0) return 0.0;
    return 49.0;
  }

  double get _total => (_subtotal + _deliveryCharge - _customDiscount).clamp(0.0, double.infinity);

  void _addItemToOrder() {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product first.')),
      );
      return;
    }

    final weight = _selectedWeightOption ?? _selectedProduct!.standardWeightOptions.first;
    final unitPrice = weight.discountPrice > 0 ? weight.discountPrice : weight.price;

    final existingIndex = _orderItems.indexWhere(
      (item) => item.productId == _selectedProduct!.id && item.weightOption.label == weight.label,
    );

    setState(() {
      if (existingIndex >= 0) {
        final current = _orderItems[existingIndex];
        _orderItems[existingIndex] = current.copyWith(
          quantity: current.quantity + _itemQuantity,
        );
      } else {
        _orderItems.add(
          CartItemModel(
            productId: _selectedProduct!.id,
            name: _selectedProduct!.name,
            imageUrl: _selectedProduct!.imageUrls.isNotEmpty ? _selectedProduct!.imageUrls.first : '',
            weightOption: weight,
            unitPrice: unitPrice,
            quantity: _itemQuantity,
          ),
        );
      }
      _itemQuantity = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${weight.label} of ${_selectedProduct!.name} to order'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one product item to the order.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final orderId = const Uuid().v4();
      final customerId = _selectedUser?.id ?? 'phone_${_phoneController.text.replaceAll(RegExp(r'\D'), '')}';

      final shippingAddress = AddressModel(
        id: const Uuid().v4(),
        userId: customerId,
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        line1: _line1Controller.text.trim(),
        line2: _line2Controller.text.trim().isEmpty ? null : _line2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        country: 'India',
        isDefault: false,
      );

      final fullInstructions = StringBuffer();
      fullInstructions.write('[Phone Call Order - Placed by Admin]');
      if (_paymentOptionName != 'Cash on Delivery (COD)') {
        fullInstructions.write(' [Payment: $_paymentOptionName]');
      }
      if (_callNotesController.text.trim().isNotEmpty) {
        fullInstructions.write('\nNote: ${_callNotesController.text.trim()}');
      }

      final newOrder = OrderModel(
        id: orderId,
        customerId: customerId,
        items: List.of(_orderItems),
        shippingAddress: shippingAddress,
        subtotal: _subtotal,
        deliveryCharge: _deliveryCharge,
        total: _total,
        status: _initialStatus,
        paymentMethod: _paymentMethod,
        deliveryInstructions: fullInstructions.toString(),
        placedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save order to both repository providers
      if (FirebaseBootstrap.isInitialized) {
        await ref.read(adminRepositoryProvider).createOrder(newOrder);
      }
      await ref.read(orderRepositoryProvider).placeOrder(newOrder);

      if (!mounted) return;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Phone Order Created!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: #${orderId.substring(0, 8).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Customer: ${_nameController.text.trim()}'),
              Text('Phone: ${_phoneController.text.trim()}'),
              Text('Total Amount: ${MoneyFormatter.format(_total)}'),
              Text('Status: ${_initialStatus.name.toUpperCase()}'),
              const SizedBox(height: 12),
              const Text(
                'This order has been confirmed on behalf of the customer and recorded in Order Management.',
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _orderItems.clear();
                  _line1Controller.clear();
                  _line2Controller.clear();
                  _postalCodeController.clear();
                  _discountController.text = '0';
                  _customDiscount = 0.0;
                });
              },
              child: const Text('Book Another Call Order'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC59B27)),
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/admin/orders');
              },
              child: const Text('View in Orders List'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    final productsAsync = ref.watch(adminProductsProvider);
    final users = usersAsync.valueOrNull ?? [];
    final products = productsAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text('Create Phone Order'),
        backgroundColor: const Color(0xFF4A3700),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'View Orders',
            icon: const Icon(Icons.receipt_long),
            onPressed: () => context.go('/admin/orders'),
          ),
        ],
      ),
      body: ResponsivePage(
        maxWidth: 920,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Notice Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A3700), Color(0xFFC59B27)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone_in_talk, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone / Mobile Call Order Booking',
                              style: GoogleFonts.josefinSans(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Create and confirm an order on behalf of a customer calling on +91-9999909122.',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // SECTION 1: Customer Selection
                _buildCard(
                  title: '1. Customer Account & Contact',
                  icon: Icons.person_outline,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle: Existing vs New Customer
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment<bool>(
                            value: true,
                            label: Text('Existing Customer Account'),
                            icon: Icon(Icons.people),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: Text('New / Direct Phone Customer'),
                            icon: Icon(Icons.person_add_alt_1),
                          ),
                        ],
                        selected: {_isExistingCustomer},
                        onSelectionChanged: (val) {
                          setState(() {
                            _isExistingCustomer = val.first;
                            if (!_isExistingCustomer) {
                              _selectedUser = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      if (_isExistingCustomer) ...[
                        const Text(
                          'Select Customer from Database:',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Autocomplete<UserModel>(
                          displayStringForOption: (u) => '${u.displayName ?? "No Name"} (${u.phoneNumber})',
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return users;
                            }
                            final q = textEditingValue.text.toLowerCase();
                            return users.where((u) =>
                                (u.displayName?.toLowerCase().contains(q) ?? false) ||
                                u.phoneNumber.contains(q) ||
                                (u.email?.toLowerCase().contains(q) ?? false));
                          },
                          onSelected: (user) {
                            _applyCustomer(user);
                          },
                          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                            if (_selectedUser != null && controller.text.isEmpty) {
                              controller.text = '${_selectedUser!.displayName ?? "No Name"} (${_selectedUser!.phoneNumber})';
                            }
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                hintText: 'Search customer by name, phone or email...',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _selectedUser != null
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          controller.clear();
                                          setState(() => _selectedUser = null);
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                        ),
                        if (_selectedUser != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC59B27).withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFC59B27).withAlpha(80)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFC59B27),
                                  foregroundColor: Colors.white,
                                  child: Text((_selectedUser!.displayName ?? 'U').substring(0, 1).toUpperCase()),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedUser!.displayName ?? 'Customer Account',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      Text('📞 ${_selectedUser!.phoneNumber} • ✉️ ${_selectedUser!.email ?? "No email"}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Quick address selector from customer's past orders
                          _buildCustomerPastAddresses(_selectedUser!.id),
                        ],
                        const SizedBox(height: 16),
                      ],

                      // Customer Input Fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Customer Full Name *',
                                prefixIcon: const Icon(Icons.badge_outlined),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Enter customer name' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Mobile Phone Number *',
                                prefixIcon: const Icon(Icons.phone_android),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Enter phone number';
                                final cleaned = val.replaceAll(RegExp(r'\D'), '');
                                if (cleaned.length < 10) return 'Enter valid 10-digit number';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Customer Email (Optional)',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 2: Shipping / Delivery Address
                _buildCard(
                  title: '2. Delivery Address',
                  icon: Icons.location_on_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _line1Controller,
                        decoration: InputDecoration(
                          labelText: 'Flat / House No., Apartment & Street Address *',
                          prefixIcon: const Icon(Icons.home_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter street address' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _line2Controller,
                        decoration: InputDecoration(
                          labelText: 'Area / Landmark / Sector (Optional)',
                          prefixIcon: const Icon(Icons.near_me_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                labelText: 'City *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Enter city' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _stateController,
                              decoration: InputDecoration(
                                labelText: 'State *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Enter state' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _postalCodeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: 'PIN Code *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'Enter PIN' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _callNotesController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Special Delivery Instructions / Call Notes',
                          prefixIcon: const Icon(Icons.note_alt_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 3: Product Selector & Items List
                _buildCard(
                  title: '3. Products Ordered (Over Call)',
                  icon: Icons.inventory_2_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product picker row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F2EA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2D6BC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add Product to Call Order:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF4A3700)),
                            ),
                            const SizedBox(height: 10),

                            // Product Dropdown
                            DropdownButtonFormField<ProductModel>(
                              value: _selectedProduct,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Choose Product',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: products.map((prod) {
                                return DropdownMenuItem<ProductModel>(
                                  value: prod,
                                  child: Text(
                                    prod.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (prod) {
                                setState(() {
                                  _selectedProduct = prod;
                                  if (prod != null && prod.standardWeightOptions.isNotEmpty) {
                                    _selectedWeightOption = prod.standardWeightOptions.first;
                                  } else {
                                    _selectedWeightOption = null;
                                  }
                                });
                              },
                            ),

                            if (_selectedProduct != null) ...[
                              const SizedBox(height: 14),
                              const Text(
                                'Select Pack Size / Weight:',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                              const SizedBox(height: 8),

                              // Weight Options Chips with Price
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: _selectedProduct!.standardWeightOptions.map((opt) {
                                  final isSelected = (_selectedWeightOption?.label == opt.label);
                                  final priceToShow = opt.discountPrice > 0 ? opt.discountPrice : opt.price;
                                  return ChoiceChip(
                                    label: Text(
                                      '${opt.label}  •  ${MoneyFormatter.format(priceToShow)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : const Color(0xFF4A3700),
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedColor: const Color(0xFFC59B27),
                                    backgroundColor: Colors.white,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() => _selectedWeightOption = opt);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const Text('Quantity: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: _itemQuantity > 1 ? () => setState(() => _itemQuantity--) : null,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade400),
                                    ),
                                    child: Text('$_itemQuantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => setState(() => _itemQuantity++),
                                  ),
                                  const Spacer(),
                                  FilledButton.icon(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF4A3700),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    ),
                                    onPressed: _addItemToOrder,
                                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                                    label: const Text('Add to Order'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List of added items
                      if (_orderItems.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('No products added yet.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              SizedBox(height: 4),
                              Text('Select products above to add items ordered by the customer.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _orderItems.length,
                          separatorBuilder: (context, _) => const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final item = _orderItems[index];
                            final itemTotal = item.unitPrice * item.quantity;
                            return Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC59B27).withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.eco_rounded, color: Color(0xFFC59B27)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFC59B27).withAlpha(30),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.weightOption.label,
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4A3700)),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('${MoneyFormatter.format(item.unitPrice)} each', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity > 1) {
                                            _orderItems[index] = item.copyWith(quantity: item.quantity - 1);
                                          } else {
                                            _orderItems.removeAt(index);
                                          }
                                        });
                                      },
                                    ),
                                    Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _orderItems[index] = item.copyWith(quantity: item.quantity + 1);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    MoneyFormatter.format(itemTotal),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF4A3700)),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => setState(() => _orderItems.removeAt(index)),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 4: Payment, Status & Billing Summary
                _buildCard(
                  title: '4. Payment & Order Summary',
                  icon: Icons.payments_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _paymentOptionName,
                              decoration: InputDecoration(
                                labelText: 'Payment Method',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Cash on Delivery (COD)', child: Text('Cash on Delivery (COD)')),
                                DropdownMenuItem(value: 'Paid via UPI (PhonePe/GPay on call)', child: Text('Paid via UPI on Call')),
                                DropdownMenuItem(value: 'Paid via Bank Transfer / IMPS', child: Text('Bank Transfer / IMPS')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _paymentOptionName = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<OrderStatus>(
                              value: _initialStatus,
                              decoration: InputDecoration(
                                labelText: 'Initial Order Status',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              items: const [
                                DropdownMenuItem(value: OrderStatus.confirmed, child: Text('CONFIRMED (Call Verified)')),
                                DropdownMenuItem(value: OrderStatus.pending, child: Text('PENDING')),
                                DropdownMenuItem(value: OrderStatus.packed, child: Text('PACKED')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _initialStatus = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Delivery fee override & custom discount
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Waive Delivery Fee (Free Delivery)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              subtitle: const Text('Special privilege for mobile call order', style: TextStyle(fontSize: 11)),
                              value: _waiveDeliveryFee,
                              onChanged: (val) => setState(() => _waiveDeliveryFee = val ?? false),
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 180,
                            child: TextFormField(
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: 'Discount (₹)',
                                prefixText: '₹ ',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _customDiscount = double.tryParse(val) ?? 0.0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28),

                      // Financial Breakdown Table
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Items Subtotal:', style: TextStyle(fontSize: 14)),
                          Text(MoneyFormatter.format(_subtotal), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charges:', style: TextStyle(fontSize: 14)),
                          Text(
                            _deliveryCharge == 0 ? 'FREE' : MoneyFormatter.format(_deliveryCharge),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _deliveryCharge == 0 ? Colors.green : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      if (_customDiscount > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount:', style: TextStyle(fontSize: 14, color: Colors.green)),
                            Text('- ${MoneyFormatter.format(_customDiscount)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green)),
                          ],
                        ),
                      ],
                      const Divider(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC59B27).withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL PAYABLE:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A3700)),
                            ),
                            Text(
                              MoneyFormatter.format(_total),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3700)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // SUBMIT BUTTON
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4A3700),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSubmitting ? null : _submitOrder,
                  icon: _isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline, size: 22),
                  label: Text(
                    _isSubmitting ? 'Booking Order...' : 'Confirm & Book Order on Customer\'s Behalf',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFEBE5DF)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFC59B27), size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.josefinSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3700),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFF0EBE3)),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerPastAddresses(String customerId) {
    return StreamBuilder<List<OrderModel>>(
      stream: ref.read(adminRepositoryProvider).watchOrdersForCustomer(customerId),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) return const SizedBox.shrink();

        // Extract unique shipping addresses from customer orders
        final addresses = <String, AddressModel>{};
        for (final o in orders) {
          final addr = o.shippingAddress;
          final key = '${addr.line1}_${addr.city}_${addr.postalCode}';
          if (!addresses.containsKey(key)) {
            addresses[key] = addr;
          }
        }

        if (addresses.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Addresses for this Customer (Click to autofill):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7A5900)),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: addresses.values.map((addr) {
                  return ActionChip(
                    avatar: const Icon(Icons.history, size: 16, color: Color(0xFF4A3700)),
                    label: Text('${addr.line1}, ${addr.city} (${addr.postalCode})', style: const TextStyle(fontSize: 11)),
                    backgroundColor: const Color(0xFFF8F3EA),
                    onPressed: () {
                      setState(() {
                        _line1Controller.text = addr.line1;
                        if (addr.line2 != null) _line2Controller.text = addr.line2!;
                        _cityController.text = addr.city;
                        _stateController.text = addr.state;
                        _postalCodeController.text = addr.postalCode;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Address autofilled from past order!'), duration: Duration(seconds: 1)),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
