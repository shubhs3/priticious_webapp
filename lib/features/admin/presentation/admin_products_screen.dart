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

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _stockFilter = 'all'; // 'all', 'in_stock', 'low_stock', 'out_of_stock'
  String _sortBy = 'name_asc'; // 'name_asc', 'name_desc', 'price_asc', 'price_desc', 'stock_asc', 'stock_desc', 'newest'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'all';
      _stockFilter = 'all';
      _sortBy = 'name_asc';
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(adminProductsProvider);
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];
    final categoryMap = {for (final c in categories) c.id: c.name};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            tooltip: 'Add Product',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showProductDialog(context, ref),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Excel Import/Export & Tools',
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
        maxWidth: 1040,
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

            // Extract unique categories available from products or master category list
            final availableCategories = <String>{};
            for (final p in products) {
              if (p.categoryId.isNotEmpty) {
                availableCategories.add(p.categoryId);
              }
            }

            // Filter logic
            final filteredProducts = products.where((product) {
              // 1. Search query
              if (_searchQuery.isNotEmpty) {
                final q = _searchQuery.toLowerCase();
                final catName = categoryMap[product.categoryId] ?? product.categoryId;
                final matchName = product.name.toLowerCase().contains(q);
                final matchCat = catName.toLowerCase().contains(q) || product.categoryId.toLowerCase().contains(q);
                final matchDesc = product.description.toLowerCase().contains(q);
                if (!matchName && !matchCat && !matchDesc) return false;
              }

              // 2. Category filter
              if (_selectedCategory != 'all' && product.categoryId != _selectedCategory) {
                return false;
              }

              // 3. Stock filter
              if (_stockFilter == 'in_stock' && product.stock <= 10) return false;
              if (_stockFilter == 'low_stock' && (product.stock <= 0 || product.stock > 10)) return false;
              if (_stockFilter == 'out_of_stock' && product.stock > 0) return false;

              return true;
            }).toList();

            // Sort logic
            filteredProducts.sort((a, b) {
              switch (_sortBy) {
                case 'name_desc':
                  return b.name.toLowerCase().compareTo(a.name.toLowerCase());
                case 'price_asc':
                  return a.discountPrice.compareTo(b.discountPrice);
                case 'price_desc':
                  return b.discountPrice.compareTo(a.discountPrice);
                case 'stock_asc':
                  return a.stock.compareTo(b.stock);
                case 'stock_desc':
                  return b.stock.compareTo(a.stock);
                case 'newest':
                  final dateA = a.createdAt ?? DateTime(2020);
                  final dateB = b.createdAt ?? DateTime(2020);
                  return dateB.compareTo(dateA);
                case 'name_asc':
                default:
                  return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              }
            });

            final totalCount = products.length;
            final lowStockCount = products.where((p) => p.stock > 0 && p.stock <= 10).length;
            final outOfStockCount = products.where((p) => p.stock <= 0).length;

            return Column(
              children: [
                // Top Search & Filter Panel
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Search Bar Field
                      TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'Search products by name, category, or description...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFC59B27)),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Theme.of(context).cardTheme.color ?? Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.amber.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant.withAlpha(120),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFC59B27), width: 1.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 2. Filters & Sort Controls Row
                      Row(
                        children: [
                          // Stock Filter Dropdown / Selector
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Stock Filter Chips
                                  _buildFilterChip(
                                    label: 'All Items',
                                    selected: _stockFilter == 'all',
                                    onSelected: () => setState(() => _stockFilter = 'all'),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: 'In Stock',
                                    selected: _stockFilter == 'in_stock',
                                    badgeColor: Colors.teal,
                                    onSelected: () => setState(() => _stockFilter = 'in_stock'),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: 'Low Stock ($lowStockCount)',
                                    selected: _stockFilter == 'low_stock',
                                    badgeColor: Colors.amber.shade900,
                                    onSelected: () => setState(() => _stockFilter = 'low_stock'),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildFilterChip(
                                    label: 'Out of Stock ($outOfStockCount)',
                                    selected: _stockFilter == 'out_of_stock',
                                    badgeColor: Colors.red.shade700,
                                    onSelected: () => setState(() => _stockFilter = 'out_of_stock'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Sort Button / Menu
                          PopupMenuButton<String>(
                            initialValue: _sortBy,
                            tooltip: 'Sort Products',
                            onSelected: (val) => setState(() => _sortBy = val),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outlineVariant.withAlpha(150),
                                ),
                                color: Theme.of(context).cardTheme.color,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.sort, size: 16, color: Color(0xFFC59B27)),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getSortLabel(_sortBy),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(Icons.arrow_drop_down, size: 16),
                                ],
                              ),
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'name_asc', child: Text('Name (A to Z)')),
                              const PopupMenuItem(value: 'name_desc', child: Text('Name (Z to A)')),
                              const PopupMenuItem(value: 'price_asc', child: Text('Price (Lowest First)')),
                              const PopupMenuItem(value: 'price_desc', child: Text('Price (Highest First)')),
                              const PopupMenuItem(value: 'stock_asc', child: Text('Stock (Lowest / Needs Restock)')),
                              const PopupMenuItem(value: 'stock_desc', child: Text('Stock (Highest First)')),
                              const PopupMenuItem(value: 'newest', child: Text('Recently Added')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 3. Horizontal Category Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('All Categories'),
                              selected: _selectedCategory == 'all',
                              onSelected: (_) => setState(() => _selectedCategory = 'all'),
                            ),
                            const SizedBox(width: 6),
                            for (final catId in availableCategories) ...[
                              ChoiceChip(
                                label: Text(categoryMap[catId] ?? catId),
                                selected: _selectedCategory == catId,
                                onSelected: (_) => setState(() => _selectedCategory = catId),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 4. Live Stats Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Showing ${filteredProducts.length} of $totalCount products',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty || _selectedCategory != 'all' || _stockFilter != 'all')
                            InkWell(
                              onTap: _clearFilters,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text(
                                  'Clear all filters',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC59B27),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Product List
                Expanded(
                  child: filteredProducts.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off_outlined, size: 56, color: Colors.grey.shade400),
                                const SizedBox(height: 12),
                                Text(
                                  'No products found matching your search',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Try adjusting the search query or clearing your category & stock filters.',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                FilledButton.tonal(
                                  onPressed: _clearFilters,
                                  child: const Text('Reset All Filters'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final catName = categoryMap[product.categoryId] ?? product.categoryId;
                            return _AdminProductCard(
                              product: product,
                              categoryName: catName,
                              onEditStock: () => _showStockDialog(context, ref, product),
                              onEditProduct: () => _showProductDialog(context, ref, product: product),
                              onDelete: () => _confirmDelete(context, ref, product),
                            );
                          },
                        ),
                ),
              ],
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

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    Color? badgeColor,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : (badgeColor ?? Colors.black87),
      ),
      selectedColor: badgeColor ?? const Color(0xFFC59B27),
    );
  }

  String _getSortLabel(String sortBy) {
    return switch (sortBy) {
      'name_desc' => 'Name Z-A',
      'price_asc' => 'Price ↑',
      'price_desc' => 'Price ↓',
      'stock_asc' => 'Stock ↑',
      'stock_desc' => 'Stock ↓',
      'newest' => 'Newest',
      _ => 'Name A-Z',
    };
  }

  void _showStockDialog(BuildContext context, WidgetRef ref, ProductModel product) {
    int currentStock = product.stock;
    final controller = TextEditingController(text: currentStock.toString());

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setModalState) {
          void updateVal(int delta) {
            final nowVal = int.tryParse(controller.text) ?? currentStock;
            final updated = (nowVal + delta).clamp(0, 99999);
            controller.text = updated.toString();
            setModalState(() {
              currentStock = updated;
            });
          }

          void setDirectVal(int val) {
            controller.text = val.toString();
            setModalState(() {
              currentStock = val;
            });
          }

          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: Color(0xFFC59B27)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Update Stock: ${product.name}',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Adjust the current stock quantity for this item in real-time.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),

                // Direct Text Field with Steppers
                Row(
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Decrease 1',
                      icon: const Icon(Icons.remove),
                      onPressed: () => updateVal(-1),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Stock Units',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null) {
                            setModalState(() => currentStock = parsed);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Increase 1',
                      icon: const Icon(Icons.add),
                      onPressed: () => updateVal(1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Quick Increment/Decrement Buttons
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => updateVal(-10),
                      child: const Text('-10'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => updateVal(10),
                      child: const Text('+10'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => updateVal(50),
                      child: const Text('+50'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => setDirectVal(0),
                      child: const Text('Out of Stock'),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFC59B27),
                ),
                onPressed: () async {
                  final newStock = int.tryParse(controller.text) ?? currentStock;
                  await ref.read(adminRepositoryProvider).updateStock(product.id, newStock);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                child: const Text('Save Stock'),
              ),
            ],
          );
        },
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

class _AdminProductCard extends StatelessWidget {
  const _AdminProductCard({
    required this.product,
    required this.categoryName,
    required this.onEditStock,
    required this.onEditProduct,
    required this.onDelete,
  });

  final ProductModel product;
  final String categoryName;
  final VoidCallback onEditStock;
  final VoidCallback onEditProduct;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.price > product.discountPrice;
    final discountPercent = hasDiscount
        ? (((product.price - product.discountPrice) / product.price) * 100).round()
        : 0;

    final isOutOfStock = product.stock <= 0;
    final isLowStock = product.stock > 0 && product.stock <= 10;

    final Color stockColor = isOutOfStock
        ? Colors.red.shade700
        : isLowStock
            ? Colors.amber.shade900
            : Colors.teal.shade700;

    final String stockLabel = isOutOfStock
        ? 'Out of Stock (0)'
        : isLowStock
            ? 'Low Stock (${product.stock} left)'
            : 'In Stock (${product.stock})';

    final IconData stockIcon = isOutOfStock
        ? Icons.cancel_outlined
        : isLowStock
            ? Icons.warning_amber_rounded
            : Icons.check_circle_outline;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(70),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Product Image Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 76,
                height: 76,
                color: const Color(0xFFFFF9E8),
                child: product.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.inventory_2_outlined, color: Color(0xFFC59B27), size: 30),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.inventory_2_outlined, color: Color(0xFFC59B27), size: 30),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // 2. Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Category & Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC59B27).withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          categoryName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A5900),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (product.isBestSeller)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'BESTSELLER',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      if (product.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'FEATURED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price Information
                  Row(
                    children: [
                      Text(
                        MoneyFormatter.format(product.discountPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF4A3700),
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          MoneyFormatter.format(product.price),
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$discountPercent% off',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Interactive Stock Badge
                  InkWell(
                    onTap: onEditStock,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: stockColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: stockColor.withAlpha(100), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(stockIcon, size: 13, color: stockColor),
                          const SizedBox(width: 5),
                          Text(
                            stockLabel,
                            style: TextStyle(
                              color: stockColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.edit, size: 11, color: stockColor.withAlpha(180)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Actions Column
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Update Stock Units',
                  icon: const Icon(Icons.warehouse_outlined, size: 20),
                  color: const Color(0xFFC59B27),
                  onPressed: onEditStock,
                ),
                IconButton(
                  tooltip: 'Edit Full Product',
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  color: Colors.blue.shade700,
                  onPressed: onEditProduct,
                ),
                IconButton(
                  tooltip: 'Delete Product',
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.red.shade700,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
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
