import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/notification_model.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminNotificationsScreen extends ConsumerWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(adminNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Sender'),
      ),
      body: ResponsivePage(
        maxWidth: 720,
        child: notificationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading notifications: $error')),
          data: (notifications) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _NotificationComposer(),
                const SizedBox(height: 24),
                Text(
                  'Sent History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (notifications.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('No notifications sent yet.', style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  )
                else
                  ...notifications.map((notif) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.notifications_outlined),
                          ),
                          title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.body),
                              if (notif.data?['route'] != null) Text('Route: ${notif.data!['route']}', style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationComposer extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NotificationComposer> createState() => _NotificationComposerState();
}

class _NotificationComposerState extends ConsumerState<_NotificationComposer> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _routeController = TextEditingController(text: '/');
  bool _sending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);
    try {
      final notif = NotificationModel(
        id: const Uuid().v4(),
        userId: 'all', // multicast to all
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        data: _routeController.text.trim().isEmpty ? null : {'route': _routeController.text.trim()},
        createdAt: DateTime.now(),
      );

      await ref.read(adminRepositoryProvider).sendNotification(notif);
      
      _titleController.clear();
      _bodyController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification sent successfully!')),
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Draft System Notification',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Message Body', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter message body' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _routeController,
                decoration: const InputDecoration(labelText: 'Action Route / Path', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _sending ? null : _send,
                icon: _sending
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send),
                label: const Text('Send to All Users'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
