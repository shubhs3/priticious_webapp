import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/seed_service.dart';
import '../../../shared/widgets/responsive_page.dart';

class AdminSeedPanel extends ConsumerStatefulWidget {
  const AdminSeedPanel({super.key});

  @override
  ConsumerState<AdminSeedPanel> createState() => _AdminSeedPanelState();
}

class _AdminSeedPanelState extends ConsumerState<AdminSeedPanel> {
  SeedType? _loading;

  Future<void> _runSeed(SeedType type, String label) async {
    setState(() => _loading = type);
    try {
      final message = await ref.read(seedServiceProvider).seed(type);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label: $message')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to seed $label: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sample Data Seeding',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              isAdmin
                  ? 'Populate Firestore with sample catalog and order data.'
                  : 'Sign in as admin to enable seeding.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SeedButton(
                  label: 'Seed Categories',
                  icon: Icons.category_outlined,
                  loading: _loading == SeedType.categories,
                  onPressed: isAdmin
                      ? () => _runSeed(SeedType.categories, 'Categories')
                      : null,
                ),
                _SeedButton(
                  label: 'Seed Products',
                  icon: Icons.inventory_2_outlined,
                  loading: _loading == SeedType.products,
                  onPressed: isAdmin
                      ? () => _runSeed(SeedType.products, 'Products')
                      : null,
                ),
                _SeedButton(
                  label: 'Seed Banners',
                  icon: Icons.view_carousel_outlined,
                  loading: _loading == SeedType.banners,
                  onPressed: isAdmin
                      ? () => _runSeed(SeedType.banners, 'Banners')
                      : null,
                ),
                _SeedButton(
                  label: 'Seed Settings',
                  icon: Icons.settings_outlined,
                  loading: _loading == SeedType.settings,
                  onPressed: isAdmin
                      ? () => _runSeed(SeedType.settings, 'Settings')
                      : null,
                ),
                _SeedButton(
                  label: 'Seed Sample Order',
                  icon: Icons.receipt_long_outlined,
                  loading: _loading == SeedType.orders,
                  onPressed: isAdmin
                      ? () => _runSeed(SeedType.orders, 'Orders')
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SeedButton extends StatelessWidget {
  const _SeedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class AdminLoginPanel extends ConsumerStatefulWidget {
  const AdminLoginPanel({super.key});

  @override
  ConsumerState<AdminLoginPanel> createState() => _AdminLoginPanelState();
}

class _AdminLoginPanelState extends ConsumerState<AdminLoginPanel> {
  final _emailController = TextEditingController(text: 'admin@priticious.com');
  final _passwordController = TextEditingController(text: 'Admin@123');
  var _isSignUp = false;
  var _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final auth = ref.read(adminAuthServiceProvider);
      if (_isSignUp) {
        await auth.signUp(_emailController.text.trim(), _passwordController.text);
      } else {
        await auth.signIn(_emailController.text.trim(), _passwordController.text);
      }
    } catch (error) {
      if (mounted) {
        String errorMessage = 'Auth failed: $error';
        if (error is FirebaseAuthException) {
          if (error.code == 'configuration-not-found' || error.code == 'operation-not-allowed') {
            errorMessage = 'Email/Password sign-in provider is not enabled in your Firebase Console.\n\n'
                'To fix this:\n'
                '1. Open Firebase Console for project "priticious-51a56"\n'
                '2. Go to Build > Authentication > Sign-in method\n'
                '3. Add new provider "Email/Password" and enable it!';
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 8),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      maxWidth: 480,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Admin Sign In',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: Text(_isSignUp ? 'Create Admin Account' : 'Sign In'),
              ),
              TextButton(
                onPressed: _loading
                    ? null
                    : () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp
                      ? 'Already have an account? Sign in'
                      : 'First time? Create admin account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
