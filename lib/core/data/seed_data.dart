import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

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
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=800',
    actionRoute: '/products',
  ),
  BannerModel(
    id: 'healthy-snacking',
    title: 'Snack clean, snack better',
    subtitle: 'Protein-rich seeds and roasted mixes delivered fresh.',
    imageUrl: 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?q=80&w=800',
    actionRoute: '/products',
  ),
];

const seedWeightOptions = <ProductWeightOption>[
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
    imageUrls: ['https://images.unsplash.com/photo-1508061253366-f7da158b6d96?q=80&w=400'],
    priceInPaise: 39900,
    discountPriceInPaise: 34900,
    weightOptions: seedWeightOptions,
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
    imageUrls: ['https://images.unsplash.com/photo-1600189020840-e9db18c3258a?q=80&w=400'],
    priceInPaise: 44900,
    discountPriceInPaise: 39900,
    weightOptions: seedWeightOptions,
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
    imageUrls: ['https://images.unsplash.com/photo-1543158087-0b1a039757f5?q=80&w=400'],
    priceInPaise: 49900,
    discountPriceInPaise: 44900,
    weightOptions: seedWeightOptions,
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
    imageUrls: ['https://images.unsplash.com/photo-1623428187969-5da2d87e0af9?q=80&w=400'],
    priceInPaise: 29900,
    discountPriceInPaise: 24900,
    weightOptions: seedWeightOptions,
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

const sampleSettings = <String, dynamic>{
  'deliveryChargeInPaise': 4900,
  'freeDeliveryThresholdInPaise': 99900,
  'supportEmail': 'support@priticious.com',
  'supportPhone': '9999909122',
  'storeName': 'PRITICIOUS DRY FRUITS',
};
