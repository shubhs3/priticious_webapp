import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/models/user_model.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminCustomersScreen extends ConsumerWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Accounts'),
      ),
      body: ResponsivePage(
        maxWidth: 720,
        child: usersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading customers: $error')),
          data: (users) {
            if (users.isEmpty) {
              return const EmptyState(
                title: 'No customers',
                message: 'No registered user accounts found in database.',
                icon: Icons.people_outline,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final dateFormat = DateFormat('dd MMM yyyy');
                final joinedDate = user.createdAt != null ? dateFormat.format(user.createdAt!) : 'N/A';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        (user.displayName ?? 'U').substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(user.displayName ?? 'No name', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user.email ?? "N/A"}'),
                        Text('Phone: ${user.phoneNumber}'),
                        Text('Joined: $joinedDate'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(user.role.name.toUpperCase()),
                      backgroundColor: user.role == UserRole.admin ? Colors.red.withAlpha(25) : null,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
