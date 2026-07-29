import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/address_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../../home/application/catalog_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ResponsivePage(
        maxWidth: 720,
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (user) {
            final isLoggedIn = user != null;
            return ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(isLoggedIn ? Icons.person : Icons.person_outline),
                  ),
                  title: Text(isLoggedIn ? (user.displayName ?? 'Customer') : 'Guest Customer'),
                  subtitle: Text(
                    isLoggedIn
                        ? '${user.email ?? ''}\nPhone: ${user.phoneNumber}'
                        : 'Login to sync orders and addresses',
                  ),
                  isThreeLine: isLoggedIn,
                  trailing: isLoggedIn
                      ? IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Log out',
                          onPressed: () => ref.read(customerAuthServiceProvider).signOut(),
                        )
                      : TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Login'),
                        ),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark theme'),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) => ref.read(themeModeProvider.notifier).state =
                      value ? ThemeMode.dark : ThemeMode.light,
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('Saved Addresses'),
                  onTap: () {
                    if (isLoggedIn) {
                      showDialog<void>(
                        context: context,
                        builder: (context) => const _AddressManagerDialog(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please log in to manage addresses.')),
                      );
                    }
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.support_agent),
                  title: Text('Contact Us'),
                  subtitle: Text('For Order Contact no. 9999909122'),
                ),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  subtitle: Text('DEALS IN PREMIUM DRY FRUITS'),
                ),
                const ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy Policy'),
                ),
                const ListTile(
                  leading: Icon(Icons.description_outlined),
                  title: Text('Terms & Conditions'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AddressManagerDialog extends ConsumerWidget {
  const _AddressManagerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(userAddressesProvider);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('My Addresses'),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Address',
            onPressed: () => _openEditDialog(context, null),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: addressesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (addresses) {
            if (addresses.isEmpty) {
              return const Center(
                child: Text(
                  'No saved addresses yet.\nTap the + icon above to add one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          addr.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (addr.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      '${addr.line1}${addr.line2 != null ? ', ${addr.line2}' : ''}\n${addr.city}, ${addr.state} - ${addr.postalCode}\nPhone: ${addr.phoneNumber}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!addr.isDefault)
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, size: 20),
                            tooltip: 'Set as Default',
                            onPressed: () => ref
                                .read(addressRepositoryProvider)
                                .setDefaultAddress(addr.userId, addr.id),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          tooltip: 'Edit',
                          onPressed: () => _openEditDialog(context, addr),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          tooltip: 'Delete',
                          onPressed: () => ref
                              .read(addressRepositoryProvider)
                              .deleteAddress(addr.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _openEditDialog(BuildContext context, AddressModel? address) {
    showDialog<void>(
      context: context,
      builder: (context) => _AddressEditDialog(address: address),
    );
  }
}

class _AddressEditDialog extends ConsumerStatefulWidget {
  const _AddressEditDialog({this.address});

  final AddressModel? address;

  @override
  ConsumerState<_AddressEditDialog> createState() => _AddressEditDialogState();
}

class _AddressEditDialogState extends ConsumerState<_AddressEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _line1Controller;
  late final TextEditingController _line2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.fullName);
    _phoneController = TextEditingController(text: widget.address?.phoneNumber);
    _line1Controller = TextEditingController(text: widget.address?.line1);
    _line2Controller = TextEditingController(text: widget.address?.line2);
    _cityController = TextEditingController(text: widget.address?.city ?? 'Local');
    _stateController = TextEditingController(text: widget.address?.state ?? 'Local');
    _zipController = TextEditingController(text: widget.address?.postalCode);
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final customerId = ref.read(currentCustomerIdProvider);
    if (customerId == guestCustomerId) return;

    final addressId = widget.address?.id ?? const Uuid().v4();
    final address = AddressModel(
      id: addressId,
      userId: customerId,
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      line1: _line1Controller.text.trim(),
      line2: _line2Controller.text.trim().isEmpty ? null : _line2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _zipController.text.trim(),
      country: 'India',
      isDefault: _isDefault,
    );

    await ref.read(addressRepositoryProvider).saveAddress(address);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Name required' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Phone required' : null,
                ),
                TextFormField(
                  controller: _line1Controller,
                  decoration: const InputDecoration(labelText: 'Detailed Address'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Address required' : null,
                ),
                TextFormField(
                  controller: _line2Controller,
                  decoration: const InputDecoration(labelText: 'Landmark / Area (Optional)'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'City required' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(labelText: 'State'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'State required' : null,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(labelText: 'Postal Code (PIN Code)'),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.trim().isEmpty ? 'PIN Code required' : null,
                ),
                CheckboxListTile(
                  title: const Text('Set as Default Address'),
                  value: _isDefault,
                  onChanged: (val) => setState(() => _isDefault = val ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
