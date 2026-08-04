import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/notification_model.dart';
import '../../../core/models/order_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/money_formatter.dart';
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
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (context) => _CustomerDetailDialog(user: user),
                    ),
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
                    trailing: const Icon(Icons.chevron_right),
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

class _CustomerDetailDialog extends ConsumerWidget {
  const _CustomerDetailDialog({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.read(adminRepositoryProvider).watchOrdersForCustomer(user.id);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 600,
        height: 650,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Text(
                      (user.displayName ?? 'U').substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'Customer Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        Text(
                          user.email ?? 'No Email',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.receipt_long), text: 'Order History'),
                        Tab(icon: Icon(Icons.notifications_active), text: 'Send Notification'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          StreamBuilder<List<OrderModel>>(
                            stream: ordersStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              final orders = snapshot.data ?? [];
                              if (orders.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Text(
                                      'No orders placed by this customer.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final order = orders[index];
                                  final placedDate = order.placedAt != null
                                      ? DateFormat('dd MMM yyyy, hh:mm a').format(order.placedAt!)
                                      : 'N/A';
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      title: Text(
                                        'Order #${order.id.substring(0, 8).toUpperCase()}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        'Placed: $placedDate\nTotal: ${MoneyFormatter.format(order.total)}',
                                      ),
                                      trailing: Chip(
                                        label: Text(order.status.name.toUpperCase(), style: const TextStyle(fontSize: 10)),
                                        backgroundColor: order.status == OrderStatus.delivered
                                            ? Colors.green.withAlpha(30)
                                            : Colors.orange.withAlpha(30),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          _CustomerNotificationTab(user: user),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerNotificationTab extends ConsumerStatefulWidget {
  const _CustomerNotificationTab({required this.user});

  final UserModel user;

  @override
  ConsumerState<_CustomerNotificationTab> createState() => _CustomerNotificationTabState();
}

class _CustomerNotificationTabState extends ConsumerState<_CustomerNotificationTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);
    try {
      final notif = NotificationModel(
        id: const Uuid().v4(),
        userId: widget.user.id,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(adminRepositoryProvider).sendNotification(notif);
      _titleController.clear();
      _bodyController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent to ${widget.user.displayName ?? "Customer"}!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send notification: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fcmToken = widget.user.fcmToken ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (fcmToken.isNotEmpty) ...[
              const Text(
                'Device Token (FCM)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withAlpha(50)),
                      ),
                      child: Text(
                        fcmToken,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy_all, size: 20),
                    tooltip: 'Copy Token',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: fcmToken));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('FCM Token copied to clipboard!')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This user has not registered an FCM Push Token yet. They will only receive foreground alerts while using the app.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              validator: (val) => val == null || val.trim().isEmpty ? 'Enter title' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Message Body', border: OutlineInputBorder()),
              maxLines: 4,
              validator: (val) => val == null || val.trim().isEmpty ? 'Enter message body' : null,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _sending ? null : _send,
              icon: _sending
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send_to_mobile),
              label: const Text('Send Alert'),
            ),
          ],
        ),
      ),
    );
  }
}
