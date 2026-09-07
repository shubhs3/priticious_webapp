import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

const sampleCategories = <CategoryModel>[
  CategoryModel(
    id: 'almonds',
    name: 'Almonds',
    slug: 'almonds',
    imageUrl: 'https://images.unsplash.com/photo-1508061253366-f7da158b6d96?q=80&w=400',
  ),
  CategoryModel(
    id: 'cashews',
    name: 'Cashews',
    slug: 'cashews',
    imageUrl: 'https://images.unsplash.com/photo-1600189020840-e9db18c3258a?q=80&w=400',
  ),
  CategoryModel(
    id: 'pistachios',
    name: 'Pistachios',
    slug: 'pistachios',
    imageUrl: 'https://images.unsplash.com/photo-1596568359553-a56de6970068?q=80&w=400',
  ),
  CategoryModel(
    id: 'walnuts',
    name: 'Walnuts',
    slug: 'walnuts',
    imageUrl: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?q=80&w=400',
  ),
  CategoryModel(
    id: 'raisins',
    name: 'Raisins',
    slug: 'raisins',
    imageUrl: 'https://images.unsplash.com/photo-1595412433290-7d72cb83a42d?q=80&w=400',
  ),
  CategoryModel(
    id: 'dates',
    name: 'Dates & Chuhara',
    slug: 'dates',
    imageUrl: 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?q=80&w=400',
  ),
  CategoryModel(
    id: 'makhana',
    name: 'Makhana',
    slug: 'makhana',
    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=400',
  ),
  CategoryModel(
    id: 'anjeer',
    name: 'Figs & Anjeer',
    slug: 'anjeer',
    imageUrl: 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?q=80&w=400',
  ),
  CategoryModel(
    id: 'seeds',
    name: 'Healthy Seeds',
    slug: 'seeds',
    imageUrl: 'https://images.unsplash.com/photo-1546548970-71785318a17b?q=80&w=400',
  ),
  CategoryModel(
    id: 'spices',
    name: 'Spices & Herbs',
    slug: 'spices',
    imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=400',
  ),
  CategoryModel(
    id: 'berries',
    name: 'Dry Berries',
    slug: 'berries',
    imageUrl: 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?q=80&w=400',
  ),
  CategoryModel(
    id: 'mixed-nuts',
    name: 'Mixed Nuts',
    slug: 'mixed-nuts',
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=400',
  ),
  CategoryModel(
    id: 'ayurvedic',
    name: 'Ayurvedic',
    slug: 'ayurvedic',
    imageUrl: 'https://images.unsplash.com/photo-1514733670139-4d87a1941d55?q=80&w=400',
  ),
  CategoryModel(
    id: 'gola',
    name: 'Coconut & Gola',
    slug: 'gola',
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=400',
  ),
  CategoryModel(
    id: 'gulkand',
    name: 'Gulkand & Sweets',
    slug: 'gulkand',
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=400',
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
    price: 399.0,
    discountPrice: 349.0,
  ),
  ProductWeightOption(
    label: '500 g',
    grams: 500,
    price: 749.0,
    discountPrice: 649.0,
  ),
  ProductWeightOption(
    label: '1 kg',
    grams: 1000,
    price: 1399.0,
    discountPrice: 1249.0,
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
    price: 399.0,
    discountPrice: 349.0,
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
    price: 449.0,
    discountPrice: 399.0,
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
    price: 499.0,
    discountPrice: 449.0,
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
    price: 299.0,
    discountPrice: 249.0,
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
  'deliveryCharge': 49.0,
  'freeDeliveryThreshold': 999.0,
  'supportEmail': 'support@priticious.com',
  'supportPhone': '9999909122',
  'storeName': 'PRITICIOUS DRY FRUITS',
};
