import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../shared/widgets/responsive_page.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ResponsivePage(
        maxWidth: 720,
        child: ListView(
          children: [
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Guest Customer'),
              subtitle: Text('Login to sync orders and addresses'),
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark theme'),
              value: themeMode == ThemeMode.dark,
              onChanged: (value) => ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light,
            ),
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Saved Addresses'),
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
        ),
      ),
    );
  }
}
