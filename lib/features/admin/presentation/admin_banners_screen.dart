import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/banner_model.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminBannersScreen extends ConsumerWidget {
  const AdminBannersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(adminBannersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Management'),
      ),
      body: ResponsivePage(
        maxWidth: 720,
        child: bannersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading banners: $error')),
          data: (banners) {
            if (banners.isEmpty) {
              return const EmptyState(
                title: 'No banners',
                message: 'Tap the button below to add your first banner.',
                icon: Icons.view_carousel_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      child: const Icon(Icons.view_carousel_outlined),
                    ),
                    title: Text(banner.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Route: ${banner.actionRoute} | Order: ${banner.sortOrder}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit Banner',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showBannerDialog(context, ref, banner: banner),
                        ),
                        IconButton(
                          tooltip: 'Delete Banner',
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDelete(context, ref, banner),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBannerDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Banner'),
      ),
    );
  }

  void _showBannerDialog(BuildContext context, WidgetRef ref, {BannerModel? banner}) {
    final isEdit = banner != null;
    final titleController = TextEditingController(text: banner?.title ?? '');
    final subtitleController = TextEditingController(text: banner?.subtitle ?? '');
    final routeController = TextEditingController(text: banner?.actionRoute ?? '/products');
    final orderController = TextEditingController(text: banner?.sortOrder.toString() ?? '0');

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Banner' : 'Add Banner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Banner Title')),
            TextField(controller: subtitleController, decoration: const InputDecoration(labelText: 'Subtitle')),
            TextField(controller: routeController, decoration: const InputDecoration(labelText: 'Action Route')),
            TextField(controller: orderController, decoration: const InputDecoration(labelText: 'Sort Order'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final id = banner?.id ?? const Uuid().v4();
              final newBanner = BannerModel(
                id: id,
                title: titleController.text.trim(),
                subtitle: subtitleController.text.trim(),
                imageUrl: banner?.imageUrl ?? '',
                actionRoute: routeController.text.trim(),
                isActive: banner?.isActive ?? true,
                sortOrder: int.tryParse(orderController.text) ?? 0,
              );

              await ref.read(adminRepositoryProvider).upsertBanner(newBanner);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, BannerModel banner) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Banner'),
        content: Text('Are you sure you want to delete banner "${banner.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteBanner(banner.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
