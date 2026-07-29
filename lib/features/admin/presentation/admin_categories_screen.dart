import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/category_model.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
      ),
      body: ResponsivePage(
        maxWidth: 720,
        child: categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading categories: $error')),
          data: (categories) {
            if (categories.isEmpty) {
              return const EmptyState(
                title: 'No categories',
                message: 'Tap the button below to add your first category.',
                icon: Icons.category_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      child: const Icon(Icons.category_outlined),
                    ),
                    title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Slug: ${category.slug} | Order: ${category.sortOrder}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit Category',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showCategoryDialog(context, ref, category: category),
                        ),
                        IconButton(
                          tooltip: 'Delete Category',
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDelete(context, ref, category),
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
        onPressed: () => _showCategoryDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Category'),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {CategoryModel? category}) {
    final isEdit = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    final slugController = TextEditingController(text: category?.slug ?? '');
    final orderController = TextEditingController(text: category?.sortOrder.toString() ?? '0');

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Category' : 'Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Category Name')),
            TextField(controller: slugController, decoration: const InputDecoration(labelText: 'Category Slug / ID')),
            TextField(controller: orderController, decoration: const InputDecoration(labelText: 'Sort Order'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final id = category?.id ?? slugController.text.trim();
              if (id.isEmpty) return;

              final newCategory = CategoryModel(
                id: id,
                name: nameController.text.trim(),
                slug: slugController.text.trim(),
                imageUrl: category?.imageUrl ?? '',
                isActive: category?.isActive ?? true,
                sortOrder: int.tryParse(orderController.text) ?? 0,
              );

              await ref.read(adminRepositoryProvider).upsertCategory(newCategory);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEdit ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, CategoryModel category) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete ${category.name}? Products in this category will become unlinked.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteCategory(category.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
