import 'dart:async';

import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'catalog_repository.dart';

class SampleCatalogRepository implements CatalogRepository {
  @override
  Stream<List<BannerModel>> watchBanners() => Stream.value(sampleBanners);

  @override
  Stream<List<CategoryModel>> watchCategories() =>
      Stream.value(sampleCategories);

  @override
  Stream<ProductModel?> watchProduct(String productId) {
    return Stream.value(
      sampleProducts.where((item) => item.id == productId).firstOrNull,
    );
  }

  @override
  Stream<List<ProductModel>> watchProducts() => Stream.value(sampleProducts);
}

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

const sampleCategories = <CategoryModel>[
  CategoryModel(id: 'almonds', name: 'Almonds', slug: 'almonds', imageUrl: ''),
  CategoryModel(id: 'cashews', name: 'Cashews', slug: 'cashews', imageUrl: ''),
  CategoryModel(
    id: 'pistachios',
    name: 'Pistachios',
    slug: 'pistachios',
    imageUrl: '',
  ),
  CategoryModel(id: 'walnuts', name: 'Walnuts', slug: 'walnuts', imageUrl: ''),
  CategoryModel(id: 'raisins', name: 'Raisins', slug: 'raisins', imageUrl: ''),
  CategoryModel(id: 'dates', name: 'Dates', slug: 'dates', imageUrl: ''),
  CategoryModel(
    id: 'mixed-nuts',
    name: 'Mixed Nuts',
    slug: 'mixed-nuts',
    imageUrl: '',
  ),
  CategoryModel(id: 'seeds', name: 'Seeds', slug: 'seeds', imageUrl: ''),
  CategoryModel(id: 'spices', name: 'Spices', slug: 'spices', imageUrl: ''),
  CategoryModel(
    id: 'gift-packs',
    name: 'Gift Packs',
    slug: 'gift-packs',
    imageUrl: '',
  ),
];

const sampleBanners = <BannerModel>[
  BannerModel(
    id: 'festival',
    title: 'Premium festive gifting',
    subtitle: 'Handpicked nuts, dates, and trail mixes for every celebration.',
    imageUrl: '',
    actionRoute: '/products',
  ),
  BannerModel(
    id: 'healthy-snacking',
    title: 'Snack clean, snack better',
    subtitle: 'Protein-rich seeds and roasted mixes delivered fresh.',
    imageUrl: '',
    actionRoute: '/products',
  ),
];

const _weights = <ProductWeightOption>[
  ProductWeightOption(
    label: '250 g',
    grams: 250,
    priceInPaise: 39900,
    discountPriceInPaise: 34900,
  ),
  ProductWeightOption(
    label: '500 g',
    grams: 500,
    priceInPaise: 74900,
    discountPriceInPaise: 64900,
  ),
  ProductWeightOption(
    label: '1 kg',
    grams: 1000,
    priceInPaise: 139900,
    discountPriceInPaise: 124900,
  ),
];

const sampleProducts = <ProductModel>[
  ProductModel(
    id: 'california-almonds',
    categoryId: 'almonds',
    name: 'California Almonds',
    description:
        'Crunchy whole almonds selected for daily nutrition and clean snacking.',
    imageUrls: [],
    priceInPaise: 39900,
    discountPriceInPaise: 34900,
    weightOptions: _weights,
    stock: 120,
    nutrition: {'Protein': '21g', 'Fiber': '12g', 'Energy': '579 kcal'},
    ingredients: ['Whole almonds'],
    storageInstructions: 'Store in an airtight container in a cool, dry place.',
    isFeatured: true,
    isBestSeller: true,
    isRecentlyAdded: true,
  ),
  ProductModel(
    id: 'premium-cashews',
    categoryId: 'cashews',
    name: 'Premium Whole Cashews',
    description:
        'Creamy W320 cashews for sweets, curries, and mindful snacking.',
    imageUrls: [],
    priceInPaise: 44900,
    discountPriceInPaise: 39900,
    weightOptions: _weights,
    stock: 80,
    nutrition: {'Protein': '18g', 'Iron': '6.7mg', 'Energy': '553 kcal'},
    ingredients: ['Whole cashews'],
    storageInstructions:
        'Keep sealed after opening. Refrigerate for longer freshness.',
    isFeatured: true,
    isBestSeller: true,
  ),
  ProductModel(
    id: 'jumbo-pistachios',
    categoryId: 'pistachios',
    name: 'Roasted Salted Pistachios',
    description:
        'Jumbo pistachios roasted in small batches with balanced sea salt.',
    imageUrls: [],
    priceInPaise: 49900,
    discountPriceInPaise: 44900,
    weightOptions: _weights,
    stock: 64,
    nutrition: {'Protein': '20g', 'Potassium': '1025mg', 'Energy': '562 kcal'},
    ingredients: ['Pistachios', 'Sea salt'],
    storageInstructions: 'Store away from moisture and direct sunlight.',
    isNewArrival: true,
    isFeatured: true,
  ),
  ProductModel(
    id: 'seed-mix',
    categoryId: 'seeds',
    name: 'Five Seed Super Mix',
    description:
        'A balanced mix of pumpkin, sunflower, flax, chia, and melon seeds.',
    imageUrls: [],
    priceInPaise: 29900,
    discountPriceInPaise: 24900,
    weightOptions: _weights,
    stock: 150,
    nutrition: {'Omega-3': 'Rich', 'Fiber': 'High', 'Protein': '18g'},
    ingredients: [
      'Pumpkin seeds',
      'Sunflower seeds',
      'Flax seeds',
      'Chia seeds',
      'Melon seeds',
    ],
    storageInstructions: 'Transfer to an airtight jar after opening.',
    isNewArrival: true,
    isRecentlyAdded: true,
  ),
];
