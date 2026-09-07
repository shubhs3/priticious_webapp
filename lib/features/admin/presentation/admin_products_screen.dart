import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/seed_data.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/file_saver.dart';
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Excel Import/Export',
            onSelected: (value) => _handleExcelAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download_price',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 8),
                    Text('Download Price Template'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'upload_price',
                child: Row(
                  children: [
                    Icon(Icons.upload, size: 20),
                    SizedBox(width: 8),
                    Text('Upload Price Updates'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'download_product',
                child: Row(
                  children: [
                    Icon(Icons.download_for_offline, size: 20),
                    SizedBox(width: 8),
                    Text('Download Product Template'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'upload_product',
                child: Row(
                  children: [
                    Icon(Icons.upload_file, size: 20),
                    SizedBox(width: 8),
                    Text('Upload New Products'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'enrich_products',
                child: Row(
                  children: [
                    Icon(Icons.auto_fix_high, size: 20, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Enrich Products & Badges'),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                        Text('Price: ${MoneyFormatter.format(product.price)} | Stock: ${product.stock}'),
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

  void _handleExcelAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'download_price':
        _downloadPriceTemplate(context, ref);
        break;
      case 'upload_price':
        _uploadPriceUpdates(context, ref);
        break;
      case 'download_product':
        _downloadProductTemplate(context);
        break;
      case 'upload_product':
        _uploadNewProducts(context, ref);
        break;
      case 'enrich_products':
        _autoEnrichProducts(context, ref);
        break;
    }
  }

  void _downloadPriceTemplate(BuildContext context, WidgetRef ref) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating Price Update template...')),
      );

      final products = await ref.read(adminProductsProvider.future);
      
      var excel = Excel.createExcel();
      excel.rename('Sheet1', 'Price Updates');
      Sheet sheetObject = excel['Price Updates'];
      
      sheetObject.appendRow([
        TextCellValue('Product ID'),
        TextCellValue('Product Name'),
        TextCellValue('Price (Rupees)'),
        TextCellValue('Discount Price (Rupees)'),
      ]);

      for (final p in products) {
        sheetObject.appendRow([
          TextCellValue(p.id),
          TextCellValue(p.name),
          DoubleCellValue(p.price),
          DoubleCellValue(p.discountPrice),
        ]);
      }

      final fileBytes = excel.save();
      if (fileBytes != null) {
        saveFile(fileBytes, 'price_updates_${DateTime.now().millisecondsSinceEpoch}.xlsx');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Price template downloaded!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate template: $e')),
        );
      }
    }
  }

  void _downloadProductTemplate(BuildContext context) {
    try {
      var excel = Excel.createExcel();
      excel.rename('Sheet1', 'New Products');
      Sheet sheetObject = excel['New Products'];

      sheetObject.appendRow([
        TextCellValue('Name'),
        TextCellValue('Category Slug'),
        TextCellValue('Description'),
        TextCellValue('Price (Rupees)'),
        TextCellValue('Discount Price (Rupees)'),
        TextCellValue('Stock'),
        TextCellValue('Storage Instructions'),
      ]);

      // Sample row
      sheetObject.appendRow([
        TextCellValue('Premium California Almonds'),
        TextCellValue('almonds'),
        TextCellValue('High quality California almonds, raw and crunchy.'),
        DoubleCellValue(399.0),
        DoubleCellValue(349.0),
        IntCellValue(100),
        TextCellValue('Store in a cool, dry place.'),
      ]);

      final fileBytes = excel.save();
      if (fileBytes != null) {
        saveFile(fileBytes, 'new_products_template.xlsx');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product template downloaded!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate template: $e')),
      );
    }
  }

  String _getCellValue(List<Data?> row, int index) {
    if (index < 0 || index >= row.length) return '';
    final cell = row[index];
    if (cell == null || cell.value == null) return '';
    final val = cell.value;
    if (val is TextCellValue) {
      return (val.value.text ?? val.value.toString()).trim();
    }
    return val.toString().trim();
  }

  double _getCellDouble(List<Data?> row, int index, double defaultValue) {
    if (index < 0 || index >= row.length) return defaultValue;
    final cell = row[index];
    if (cell == null || cell.value == null) return defaultValue;
    final val = cell.value;
    if (val is DoubleCellValue) return val.value;
    if (val is IntCellValue) return val.value.toDouble();
    if (val is TextCellValue) {
      final text = val.value.text ?? val.value.toString();
      final str = text.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(str) ?? defaultValue;
    }
    final str = val.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(str) ?? defaultValue;
  }

  int _getCellInt(List<Data?> row, int index, int defaultValue) {
    if (index < 0 || index >= row.length) return defaultValue;
    final cell = row[index];
    if (cell == null || cell.value == null) return defaultValue;
    final val = cell.value;
    if (val is IntCellValue) return val.value;
    if (val is DoubleCellValue) return val.value.toInt();
    if (val is TextCellValue) {
      final text = val.value.text ?? val.value.toString();
      final str = text.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(str) ?? defaultValue;
    }
    final str = val.toString().replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(str) ?? defaultValue;
  }

  void _uploadPriceUpdates(BuildContext context, WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to read Excel file data.')),
          );
        }
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parsing file and updating prices...')),
        );
      }

      final excel = Excel.decodeBytes(bytes);
      final updates = <Map<String, dynamic>>[];

      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        for (int i = 1; i < sheet.maxRows; i++) {
          final row = sheet.rows[i];
          if (row.isEmpty) continue;

          final id = _getCellValue(row, 0);
          if (id.isEmpty || id.toLowerCase() == 'product id') continue;

          final price = _getCellDouble(row, 2, 0.0);
          final discount = _getCellDouble(row, 3, 0.0);

          if (price > 0.0 && discount > 0.0) {
            updates.add({
              'id': id,
              'price': price,
              'discountPrice': discount,
            });
          }
        }
      }

      if (updates.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid price updates found in file.')),
          );
        }
        return;
      }

      await ref.read(adminRepositoryProvider).updatePricesBulk(updates);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully updated ${updates.length} product prices!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update prices: ${e.toString()}')),
        );
      }
    }
  }

  String _getDefaultProductImage(String categoryId, String name) {
    final cat = categoryId.toLowerCase();
    final n = name.toLowerCase();
    if (cat.contains('almond') || n.contains('badam') || n.contains('almond')) {
      return 'https://images.unsplash.com/photo-1508061253366-f7da158b6d96?q=80&w=400';
    }
    if (cat.contains('cashew') || n.contains('kaaju') || n.contains('cashew')) {
      return 'https://images.unsplash.com/photo-1600189020840-e9db18c3258a?q=80&w=400';
    }
    if (cat.contains('pista') || n.contains('pista') || n.contains('pistachio')) {
      return 'https://images.unsplash.com/photo-1596568359553-a56de6970068?q=80&w=400';
    }
    if (cat.contains('walnut') || n.contains('akhrot') || n.contains('walnut')) {
      return 'https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=400';
    }
    if (cat.contains('raisin') || n.contains('kishmis') || n.contains('munakka') || n.contains('raisin')) {
      return 'https://images.unsplash.com/photo-1595412433290-7d72cb83a42d?q=80&w=400';
    }
    if (cat.contains('date') || n.contains('khajoor') || n.contains('chuhara') || n.contains('date')) {
      return 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?q=80&w=400';
    }
    if (cat.contains('makhana') || n.contains('makhana') || n.contains('makahana')) {
      return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400';
    }
    if (cat.contains('anjeer') || n.contains('anjeer') || n.contains('fig')) {
      return 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?q=80&w=400';
    }
    if (cat.contains('seed') || n.contains('seed') || n.contains('til')) {
      return 'https://images.unsplash.com/photo-1546548970-71785318a17b?q=80&w=400';
    }
    if (cat.contains('spice') || n.contains('mirch') || n.contains('elaichi') || n.contains('masala') || n.contains('dhaniya') || n.contains('cinnamon')) {
      return 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=400';
    }
    if (cat.contains('berry') || n.contains('blueberry') || n.contains('cranberry')) {
      return 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?q=80&w=400';
    }
    if (cat.contains('ayurvedic') || n.contains('chaal') || n.contains('fitkari')) {
      return 'https://images.unsplash.com/photo-1514733670139-4d87a1941d55?q=80&w=400';
    }
    return 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=400';
  }

  void _uploadNewProducts(BuildContext context, WidgetRef ref) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to read Excel file data.')),
          );
        }
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parsing file and importing products...')),
        );
      }

      final excel = Excel.decodeBytes(bytes);
      final newProducts = <ProductModel>[];

      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        for (int i = 1; i < sheet.maxRows; i++) {
          final row = sheet.rows[i];
          if (row.isEmpty) continue;

          final name = _getCellValue(row, 0);
          final categoryId = _getCellValue(row, 1);
          final description = _getCellValue(row, 2);

          if (name.isEmpty || categoryId.isEmpty) continue;
          if (name.toLowerCase() == 'name' || categoryId.toLowerCase() == 'category slug') continue;

          final price = _getCellDouble(row, 3, 349.0);
          final discount = _getCellDouble(row, 4, 299.0);
          final stock = _getCellInt(row, 5, 100);
          final storage = _getCellValue(row, 6).isNotEmpty
              ? _getCellValue(row, 6)
              : 'Cool and dry place.';

          final id = const Uuid().v4();
          final imgUrl = _getDefaultProductImage(categoryId, name);
          final index = newProducts.length;

          newProducts.add(
            ProductModel(
              id: id,
              categoryId: categoryId,
              name: name,
              description: description,
              imageUrls: [imgUrl],
              price: price,
              discountPrice: discount,
              weightOptions: [
                ProductWeightOption(
                  label: '250 g',
                  grams: 250,
                  price: discount,
                  discountPrice: (discount * 0.9).roundToDouble(),
                ),
                ProductWeightOption(
                  label: '500 g',
                  grams: 500,
                  price: (discount * 1.8).roundToDouble(),
                  discountPrice: (discount * 1.6).roundToDouble(),
                ),
                ProductWeightOption(
                  label: '1 kg',
                  grams: 1000,
                  price: (discount * 3.5).roundToDouble(),
                  discountPrice: (discount * 3.1).roundToDouble(),
                ),
              ],
              stock: stock,
              nutrition: const {'Protein': '15g', 'Fiber': '10g', 'Energy': '480 kcal'},
              ingredients: [name],
              storageInstructions: storage,
              isFeatured: (index % 3 == 0),
              isBestSeller: (index % 2 == 0),
              isNewArrival: (index % 4 == 0),
              isRecentlyAdded: true,
              isActive: true,
            ),
          );
        }
      }

      if (newProducts.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid products found in file.')),
          );
        }
        return;
      }

      await ref.read(adminRepositoryProvider).insertProductsBulk(newProducts);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully imported ${newProducts.length} new products!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import products: ${e.toString()}')),
        );
      }
    }
  }

  void _autoEnrichProducts(BuildContext context, WidgetRef ref) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enriching product images, badges & categories...')),
        );
      }

      final products = await ref.read(adminProductsProvider.future);
      final repo = ref.read(adminRepositoryProvider);

      int count = 0;
      for (int i = 0; i < products.length; i++) {
        final p = products[i];
        final defaultImg = _getDefaultProductImage(p.categoryId, p.name);
        final hasImage = p.imageUrls.isNotEmpty && p.imageUrls.first.isNotEmpty;

        final updated = p.copyWith(
          imageUrls: hasImage ? p.imageUrls : [defaultImg],
          isFeatured: (i % 3 == 0),
          isBestSeller: (i % 2 == 0),
          isNewArrival: (i % 4 == 0),
          isRecentlyAdded: true,
          weightOptions: p.weightOptions.isEmpty
              ? [
                  ProductWeightOption(
                    label: '250 g',
                    grams: 250,
                    price: p.discountPrice,
                    discountPrice: (p.discountPrice * 0.9).roundToDouble(),
                  ),
                  ProductWeightOption(
                    label: '500 g',
                    grams: 500,
                    price: (p.discountPrice * 1.8).roundToDouble(),
                    discountPrice: (p.discountPrice * 1.6).roundToDouble(),
                  ),
                  ProductWeightOption(
                    label: '1 kg',
                    grams: 1000,
                    price: (p.discountPrice * 3.5).roundToDouble(),
                    discountPrice: (p.discountPrice * 3.1).roundToDouble(),
                  ),
                ]
              : p.weightOptions,
        );

        await repo.upsertProduct(updated);
        count++;
      }

      for (final cat in sampleCategories) {
        await repo.upsertCategory(cat);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enriched $count products and updated categories!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to enrich products: $e')),
        );
      }
    }
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
    _priceController = TextEditingController(text: p?.price.toString() ?? '349.0');
    _discountController = TextEditingController(text: p?.discountPrice.toString() ?? '299.0');
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
                    price: double.tryParse(_priceController.text) ?? 349.0,
                    discountPrice: double.tryParse(_discountController.text) ?? 299.0,
                    weightOptions: widget.product?.weightOptions ?? [
                      const ProductWeightOption(label: '250 g', grams: 250, price: 399.0, discountPrice: 349.0),
                      const ProductWeightOption(label: '500 g', grams: 500, price: 749.0, discountPrice: 649.0),
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
