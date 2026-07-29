import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/product_model.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/responsive_page.dart';
import '../application/admin_providers.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
      ),
      body: ResponsivePage(
        maxWidth: 960,
        child: productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error loading products: $error')),
          data: (products) {
            if (products.isEmpty) {
              return const EmptyState(
                title: 'No products found',
                message: 'Tap the button below to add your first product.',
                icon: Icons.inventory_2_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(Icons.inventory_2_outlined),
                    ),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${product.categoryId}'),
                        Text('Price: ${MoneyFormatter.formatPaise(product.priceInPaise)} | Stock: ${product.stock}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit Stock',
                          icon: const Icon(Icons.edit_road_outlined),
                          onPressed: () => _showStockDialog(context, ref, product),
                        ),
                        IconButton(
                          tooltip: 'Edit Product',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showProductDialog(context, ref, product: product),
                        ),
                        IconButton(
                          tooltip: 'Delete Product',
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDelete(context, ref, product),
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
        onPressed: () => _showProductDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  void _showStockDialog(BuildContext context, WidgetRef ref, ProductModel product) {
    final controller = TextEditingController(text: product.stock.toString());
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock: ${product.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Stock Quantity'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newStock = int.tryParse(controller.text) ?? product.stock;
              await ref.read(adminRepositoryProvider).updateStock(product.id, newStock);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, WidgetRef ref, {ProductModel? product}) {
    showDialog<void>(
      context: context,
      builder: (context) => _ProductEditDialog(product: product),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ProductModel product) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}? This action is permanent.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteProduct(product.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ProductEditDialog extends ConsumerStatefulWidget {
  const _ProductEditDialog({this.product});

  final ProductModel? product;

  @override
  ConsumerState<_ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends ConsumerState<_ProductEditDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountController;
  late final TextEditingController _stockController;
  late final TextEditingController _storageController;

  final List<String> _imageUrls = [];
  bool _isUploading = false;
  String? _uploadError;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _categoryController = TextEditingController(text: p?.categoryId ?? 'almonds');
    _descController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p?.priceInPaise.toString() ?? '34900');
    _discountController = TextEditingController(text: p?.discountPriceInPaise.toString() ?? '29900');
    _stockController = TextEditingController(text: p?.stock.toString() ?? '100');
    _storageController = TextEditingController(text: p?.storageInstructions ?? 'Cool and dry place.');

    if (p?.imageUrls != null) {
      _imageUrls.addAll(p!.imageUrls);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _storageController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    debugPrint('[ImageUpload] Starting image pick process...');
    setState(() {
      _isUploading = true;
      _uploadError = null;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 70,
      );

      if (pickedFile == null) {
        debugPrint('[ImageUpload] No image selected.');
        setState(() {
          _isUploading = false;
        });
        return;
      }

      debugPrint('[ImageUpload] Selected file: ${pickedFile.name}');
      final bytes = await pickedFile.readAsBytes();
      debugPrint('[ImageUpload] Read ${bytes.length} bytes successfully.');

      final base64Str = base64Encode(bytes);
      final extension = pickedFile.name.split('.').last.toLowerCase();
      final dataUrl = 'data:image/$extension;base64,$base64Str';
      debugPrint('[ImageUpload] Converted successfully to Base64 data URL (length: ${dataUrl.length}).');

      setState(() {
        _imageUrls.add(dataUrl);
        _isUploading = false;
      });
    } catch (e, stack) {
      debugPrint('[ImageUpload] Error caught: $e');
      debugPrint('[ImageUpload] Stack trace: $stack');
      setState(() {
        _uploadError = 'Upload failed: $e';
        _isUploading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category Slug'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price (paise)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _discountController,
                      decoration: const InputDecoration(labelText: 'Discount Price (paise)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _storageController,
                      decoration: const InputDecoration(labelText: 'Storage Instructions'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Product Images',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ..._imageUrls.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final url = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: url.startsWith('data:image/')
                              ? Image.memory(
                                  base64Decode(url.split(';base64,').last),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: url,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[100],
                                    child: const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(idx),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  if (_isUploading)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    InkWell(
                      onTap: _pickAndUploadImage,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                      ),
                    ),
                ],
              ),
              if (_uploadError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _uploadError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isUploading
              ? null
              : () async {
                  final id = widget.product?.id ?? const Uuid().v4();
                  final newProduct = ProductModel(
                    id: id,
                    categoryId: _categoryController.text.trim(),
                    name: _nameController.text.trim(),
                    description: _descController.text.trim(),
                    imageUrls: _imageUrls,
                    priceInPaise: int.tryParse(_priceController.text) ?? 34900,
                    discountPriceInPaise: int.tryParse(_discountController.text) ?? 29900,
                    weightOptions: widget.product?.weightOptions ?? [
                      const ProductWeightOption(label: '250 g', grams: 250, priceInPaise: 39900, discountPriceInPaise: 34900),
                      const ProductWeightOption(label: '500 g', grams: 500, priceInPaise: 74900, discountPriceInPaise: 64900),
                    ],
                    stock: int.tryParse(_stockController.text) ?? 100,
                    nutrition: widget.product?.nutrition ?? {'Energy': '500 kcal'},
                    ingredients: widget.product?.ingredients ?? ['Pure ingredients'],
                    storageInstructions: _storageController.text.trim(),
                    isActive: widget.product?.isActive ?? true,
                    createdAt: widget.product?.createdAt,
                  );

                  await ref.read(adminRepositoryProvider).upsertProduct(newProduct);
                  if (context.mounted) Navigator.pop(context);
                },
          child: Text(isEdit ? 'Save Changes' : 'Create'),
        ),
      ],
    );
  }
}
