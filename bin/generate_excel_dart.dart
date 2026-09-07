import 'dart:io';
import 'package:excel/excel.dart';

final products = [
  {
    "name": "Shelled Akhrot",
    "category_slug": "walnuts",
    "description": "Premium shelled walnuts with fresh, crisp half-kernels. Rich in Omega-3 fatty acids, antioxidants, and essential nutrients for brain health.",
    "price": 1100.0,
    "discount_price": 980.0,
    "stock": 100,
    "storage": "Store in a cool, dry place in an airtight container. Refrigeration recommended for extended freshness."
  },
  {
    "name": "Amrican Giri Badam",
    "category_slug": "almonds",
    "description": "High-grade California / American almond kernels. Naturally sweet, crunchy, and packed with Vitamin E, protein, and dietary fiber.",
    "price": 1200.0,
    "discount_price": 1040.0,
    "stock": 150,
    "storage": "Store in a cool, dry place away from direct sunlight."
  },
  {
    "name": "1 pcs Kaaju",
    "category_slug": "cashews",
    "description": "Premium W-240 jumbo whole cashew nuts. Rich, creamy texture and whole shape perfect for premium snacking, sweets, and festive gifting.",
    "price": 1150.0,
    "discount_price": 1020.0,
    "stock": 120,
    "storage": "Keep in an airtight container in a dry place."
  },
  {
    "name": "Pista Salted",
    "category_slug": "pistachios",
    "description": "Lightly salted roasted pistachios in shell. Crunchy, savory snack packed with protein, healthy fats, and antioxidants.",
    "price": 1490.0,
    "discount_price": 1330.0,
    "stock": 100,
    "storage": "Store in a cool, dark, airtight container to maintain crispiness."
  },
  {
    "name": "KISHMIS",
    "category_slug": "raisins",
    "description": "Naturally sun-dried sweet Indian green raisins. Soft, juicy, and rich in natural iron, potassium, and quick energy.",
    "price": 700.0,
    "discount_price": 620.0,
    "stock": 150,
    "storage": "Keep in a cool, dry place or refrigerate to preserve moisture."
  },
  {
    "name": "Makahna",
    "category_slug": "makhana",
    "description": "Premium quality giant fox nuts (Phool Makhana). Low in calories, rich in calcium and protein—ideal for healthy guilt-free snacking and fasting.",
    "price": 1400.0,
    "discount_price": 1260.0,
    "stock": 100,
    "storage": "Keep in an airtight container to retain crispness."
  },
  {
    "name": "Anjeer",
    "category_slug": "anjeer",
    "description": "Soft and chewy premium dried figs. Packed with dietary fiber, iron, calcium, and minerals for digestive health and immunity.",
    "price": 1400.0,
    "discount_price": 1260.0,
    "stock": 80,
    "storage": "Store in a cool, dry place in a closed box."
  },
  {
    "name": "Mix Healthy Seeds",
    "category_slug": "seeds",
    "description": "Power-packed superfood blend of pumpkin, chia, flax, sunflower, and watermelon seeds. Ideal for smoothie bowls, yogurt, and daily snacking.",
    "price": 650.0,
    "discount_price": 550.0,
    "stock": 100,
    "storage": "Keep in a cool, dry container."
  },
  {
    "name": "Elaichi",
    "category_slug": "spices",
    "description": "Premium aromatic green cardamom pods (Choti Elaichi). Intense natural fragrance and flavor for sweets, tea, biryanis, and traditional recipes.",
    "price": 3500.0,
    "discount_price": 3120.0,
    "stock": 50,
    "storage": "Store in a cool, dry, dark airtight jar to lock in essential oils."
  },
  {
    "name": "Kaagzi Badam",
    "category_slug": "almonds",
    "description": "Thin-shelled raw almonds (Kaagzi Badam) that crack open easily by hand. Sweet internal kernels packed with traditional wholesome nourishment.",
    "price": 700.0,
    "discount_price": 610.0,
    "stock": 80,
    "storage": "Keep in a dry, well-ventilated container."
  },
  {
    "name": "Munakka",
    "category_slug": "raisins",
    "description": "Large sweet brown seeded raisins (Munakka). Traditionally prized in Ayurveda for soothing digestion, improving hemoglobin, and boosting vitality.",
    "price": 890.0,
    "discount_price": 780.0,
    "stock": 90,
    "storage": "Store in a cool, dry place."
  },
  {
    "name": "Gurbandi Giri Badam",
    "category_slug": "almonds",
    "description": "Authentic Afghan Gurbandi almond kernels. Rich in natural almond oils, distinct nut flavor, and unmatched nutritional richness.",
    "price": 1500.0,
    "discount_price": 1320.0,
    "stock": 70,
    "storage": "Store in an airtight container away from heat."
  },
  {
    "name": "Chuhara",
    "category_slug": "dates",
    "description": "Dry yellow/red dates (Dry Chuhara). High in dietary fiber, iron, and natural sugars—great for energy milk preparations and traditional sweets.",
    "price": 500.0,
    "discount_price": 430.0,
    "stock": 100,
    "storage": "Store in a cool, dry place."
  },
  {
    "name": "Pind Khajoor",
    "category_slug": "dates",
    "description": "Soft, moist, and naturally sweet Pind dates. Great source of quick energy, natural sweetness, and daily dietary minerals.",
    "price": 450.0,
    "discount_price": 390.0,
    "stock": 120,
    "storage": "Keep in a cool place or refrigerate after opening."
  },
  {
    "name": "Mamra Giri Badam",
    "category_slug": "almonds",
    "description": "Exquisite Iranian Mamra Badam Giri. Ultra-premium almond kernels known for high oil content, concaved shape, and supreme health benefits.",
    "price": 4200.0,
    "discount_price": 3780.0,
    "stock": 40,
    "storage": "Refrigerate in an airtight container for maximum freshness."
  },
  {
    "name": "Daalchini",
    "category_slug": "spices",
    "description": "Whole aromatic Ceylon cinnamon sticks (Daalchini). Fragrant, sweet spice stick ideal for curries, desserts, teas, and immunity drinks.",
    "price": 680.0,
    "discount_price": 590.0,
    "stock": 100,
    "storage": "Store in a cool, dry glass container."
  },
  {
    "name": "Akhrot Giri",
    "category_slug": "walnuts",
    "description": "Extra-light handpicked walnut kernels (Akhrot Giri halves). Fresh, buttery, rich in Omega-3 fatty acids, and beneficial for brain & heart health.",
    "price": 1950.0,
    "discount_price": 1740.0,
    "stock": 60,
    "storage": "Store in a cool, dry, airtight container. Refrigeration recommended."
  },
  {
    "name": "Gola",
    "category_slug": "gola",
    "description": "Whole dried coconut cup (Sukha Gola / Khopra). Natural coconut fats and flavor used widely in traditional cooking, sweets, and worship.",
    "price": 500.0,
    "discount_price": 440.0,
    "stock": 100,
    "storage": "Keep in a dry, ventilated place."
  },
  {
    "name": "Gulla Chuhara",
    "category_slug": "dates",
    "description": "Round dry dates (Gulla Chuhara). Crunchy texture with rich natural sweetness, useful for festive prasad and sweet dishes.",
    "price": 480.0,
    "discount_price": 420.0,
    "stock": 80,
    "storage": "Store in a cool, dry container."
  },
  {
    "name": "Jumbo Kaaju (150 No.)",
    "category_slug": "cashews",
    "description": "King-size W-150 grade Jumbo cashew nuts. Exceptionally large, creamy, and pristine—ideal for luxury gift packs and gourmet recipes.",
    "price": 1300.0,
    "discount_price": 1150.0,
    "stock": 70,
    "storage": "Keep in an airtight jar in a cool, dry place."
  },
  {
    "name": "Gulkand",
    "category_slug": "gulkand",
    "description": "Traditional sweet preserve of damask rose petals and natural sugar. Cooling herbal mouth-freshener that aids digestion and acidity relief.",
    "price": 620.0,
    "discount_price": 550.0,
    "stock": 90,
    "storage": "Refrigerate after opening."
  },
  {
    "name": "2 pcs Kaaju",
    "category_slug": "cashews",
    "description": "Split cashew halves (2-piece cashew). Ideal for everyday home cooking, gravies, garnishing, and baking.",
    "price": 25.0,
    "discount_price": 20.0,
    "stock": 500,
    "storage": "Store in a dry airtight container."
  },
  {
    "name": "Mirch",
    "category_slug": "spices",
    "description": "Premium ground red chili powder (Lal Mirch). Vibrant color, spicy kick, and authentic pungent flavor for Indian curries.",
    "price": 25.0,
    "discount_price": 20.0,
    "stock": 300,
    "storage": "Store in a sealed container in a dark cabinet."
  },
  {
    "name": "Garam Masala",
    "category_slug": "spices",
    "description": "Aromatic Indian spice mix blended from roasted whole spices. Elevates curries, dals, and gravies with rich warmth and aroma.",
    "price": 25.0,
    "discount_price": 20.0,
    "stock": 300,
    "storage": "Keep in an airtight spice container."
  },
  {
    "name": "Kali mirch",
    "category_slug": "spices",
    "description": "Whole black peppercorns (Kali Mirch). Pungent, spicy peppercorns rich in piperine for health, digestion, and daily seasoning.",
    "price": 25.0,
    "discount_price": 20.0,
    "stock": 300,
    "storage": "Keep dry in an airtight container."
  },
  {
    "name": "Mirch sabut",
    "category_slug": "spices",
    "description": "Whole dried red chillies (Sabut Lal Mirch). Rich red pigment and strong spice level for tempering (tadka) and spice blends.",
    "price": 25.0,
    "discount_price": 20.0,
    "stock": 300,
    "storage": "Keep in a dry container."
  },
  {
    "name": "Sabut dhaniya",
    "category_slug": "spices",
    "description": "Whole coriander seeds (Sabut Dhaniya). Earthy, citrusy aroma essential for Indian spice pastes, powders, and gravies.",
    "price": 25.0,
    "discount_price": 20.0,
    "stock": 300,
    "storage": "Store in a cool, dry place."
  },
  {
    "name": "Dry Blueberry",
    "category_slug": "berries",
    "description": "Whole dried blueberries. Bursting with natural sweetness, rich in antioxidants, Vitamin C, and daily dietary fiber.",
    "price": 1950.0,
    "discount_price": 1760.0,
    "stock": 80,
    "storage": "Store in a cool, dry place or refrigerate for prolonged shelf life."
  },
  {
    "name": "Dry Cranberry",
    "category_slug": "berries",
    "description": "Soft and tangy dried cranberries. Perfect balance of sweet and tart taste, packed with antioxidants and health benefits.",
    "price": 1300.0,
    "discount_price": 1150.0,
    "stock": 90,
    "storage": "Store in a cool, dark, airtight container."
  },
  {
    "name": "Khuskhus",
    "category_slug": "spices",
    "description": "White poppy seeds (Khus Khus). Rich in minerals and calcium, widely used for thickening curries, thandai, and traditional desserts.",
    "price": 1850.0,
    "discount_price": 1660.0,
    "stock": 60,
    "storage": "Keep dry in an airtight container away from humidity."
  },
  {
    "name": "Kharbuja Giri",
    "category_slug": "seeds",
    "description": "Raw melon seeds (Kharbuja Giri). Nutrient-dense seeds loaded with plant protein, magnesium, and zinc for healthy snacking and cooking.",
    "price": 1100.0,
    "discount_price": 980.0,
    "stock": 90,
    "storage": "Keep in an airtight container in a dry location."
  },
  {
    "name": "Mungfali",
    "category_slug": "mixed-nuts",
    "description": "High-grade raw shelled peanuts (Mungfali Giri). Excellent source of plant protein, healthy fats, and energy for roasting or cooking.",
    "price": 190.0,
    "discount_price": 160.0,
    "stock": 200,
    "storage": "Store in a dry place."
  },
  {
    "name": "Sasme Seeds Til",
    "category_slug": "seeds",
    "description": "Cleaned hulled white sesame seeds (Safed Til). Rich in calcium and healthy fats, ideal for winter sweets, baking, and garnishing.",
    "price": 270.0,
    "discount_price": 230.0,
    "stock": 150,
    "storage": "Keep dry in an airtight jar."
  },
  {
    "name": "1 pcs Kaaju Salted",
    "category_slug": "cashews",
    "description": "Crisp roasted whole cashews with a touch of Himalayan salt. Creamy, savory snack perfect for tea-time and entertaining guests.",
    "price": 1400.0,
    "discount_price": 1250.0,
    "stock": 100,
    "storage": "Store in an airtight box to keep crunchy."
  },
  {
    "name": "Chia Seeds",
    "category_slug": "seeds",
    "description": "Raw organic chia seeds. Loaded with Omega-3, fiber, and protein. Expands in liquids to form healthy puddings and smoothie toppers.",
    "price": 530.0,
    "discount_price": 470.0,
    "stock": 120,
    "storage": "Store in a cool, dry place."
  },
  {
    "name": "Flex Seeds Roasted",
    "category_slug": "seeds",
    "description": "Crunchy roasted flax seeds (Alsi). Rich in lignans and dietary fiber, perfect as a digestive after-meal snack.",
    "price": 450.0,
    "discount_price": 390.0,
    "stock": 100,
    "storage": "Store in an airtight jar."
  },
  {
    "name": "Flex Seeds",
    "category_slug": "seeds",
    "description": "Raw natural flax seeds (Alsi). Abundant in Omega-3 fatty acids and fiber, ideal for grinding into daily powders or breakfast bowls.",
    "price": 200.0,
    "discount_price": 170.0,
    "stock": 150,
    "storage": "Store in a cool, dry place."
  },
  {
    "name": "Sunflower Seeds",
    "category_slug": "seeds",
    "description": "Shelled raw sunflower seed kernels. Rich in Vitamin E, selenium, and healthy fats for heart health and glowing skin.",
    "price": 420.0,
    "discount_price": 360.0,
    "stock": 110,
    "storage": "Store in a cool, dry place."
  },
  {
    "name": "Pumpkin Seeds",
    "category_slug": "seeds",
    "description": "AAA-grade raw pumpkin seeds (Kaddu Giri). High in zinc, magnesium, and antioxidants for prostate, heart, and immunity health.",
    "price": 780.0,
    "discount_price": 680.0,
    "stock": 100,
    "storage": "Keep in an airtight container in a cool spot."
  },
  {
    "name": "Besil Seeds",
    "category_slug": "seeds",
    "description": "Sweet basil seeds (Sabja Seeds). Natural cooling agent rich in fiber; swells quickly in water for faloodas, lemonade, and summer drinks.",
    "price": 880.0,
    "discount_price": 780.0,
    "stock": 90,
    "storage": "Keep dry in a moisture-free container."
  },
  {
    "name": "Chilgoza",
    "category_slug": "mixed-nuts",
    "description": "Luxury raw pine nuts in shell (Chilgoza). Rare, exotic dry fruit packed with pinolenic acid, high protein, and unmatched butteriness.",
    "price": 5800.0,
    "discount_price": 5120.0,
    "stock": 30,
    "storage": "Store in a refrigerator in a tight jar."
  },
  {
    "name": "Arjun Chaal",
    "category_slug": "ayurvedic",
    "description": "Pure dried Terminalia Arjuna bark (Arjun Chaal). Renowned Ayurvedic botanical herbal remedy for heart wellness and blood pressure support.",
    "price": 300.0,
    "discount_price": 260.0,
    "stock": 80,
    "storage": "Store in a dry place away from moisture."
  },
  {
    "name": "Chironji",
    "category_slug": "mixed-nuts",
    "description": "Premium whole Chironji seeds (Charoli). Nutty taste with high protein and essential oils, prized in Indian sweets, kheer, and Mughlai curries.",
    "price": 1980.0,
    "discount_price": 1780.0,
    "stock": 50,
    "storage": "Store in a cool, dry airtight container."
  },
  {
    "name": "Priticious Special",
    "category_slug": "spices",
    "description": "Signature Priticious dry fruit powder mix. Master blend of ground almonds, pistachios, cashews, saffron, and cardamom for energy milk mixes.",
    "price": 1300.0,
    "discount_price": 1150.0,
    "stock": 70,
    "storage": "Store in a cool place in an airtight jar."
  },
  {
    "name": "Mishri",
    "category_slug": "sweets",
    "description": "Pure rock sugar crystals (Dhaaga Mishri). Traditional digestive mouth freshener and unrefined natural sweetener for prasad and beverages.",
    "price": 130.0,
    "discount_price": 110.0,
    "stock": 150,
    "storage": "Keep in a dry, moisture-free jar."
  },
  {
    "name": "Fitkari",
    "category_slug": "ayurvedic",
    "description": "Pure natural Alum stone crystal (Phitkari). Multi-purpose traditional mineral for water purification, skin care, and mouth hygiene.",
    "price": 120.0,
    "discount_price": 100.0,
    "stock": 100,
    "storage": "Keep dry."
  },
  {
    "name": "Pista Pishori",
    "category_slug": "pistachios",
    "description": "Authentic Peshawari green pistachio kernels (Pishori Pista). Vibrant green color, rich nut aroma, and exquisite taste for luxury desserts.",
    "price": 4300.0,
    "discount_price": 3880.0,
    "stock": 40,
    "storage": "Store in a cool place or refrigerate."
  },
  {
    "name": "WaterMelon Seeds",
    "category_slug": "seeds",
    "description": "Shelled raw watermelon seed kernels (Tarbooj Giri). Nutrient-dense source of protein, iron, and magnesium for heart health and daily vitality.",
    "price": 750.0,
    "discount_price": 650.0,
    "stock": 100,
    "storage": "Store in an airtight container in a dry place."
  }
];

void main() {
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

  for (final p in products) {
    sheetObject.appendRow([
      TextCellValue(p['name'] as String),
      TextCellValue(p['category_slug'] as String),
      TextCellValue(p['description'] as String),
      DoubleCellValue((p['price'] as num).toDouble()),
      DoubleCellValue((p['discount_price'] as num).toDouble()),
      IntCellValue((p['stock'] as num).toInt()),
      TextCellValue(p['storage'] as String),
    ]);
  }

  final bytes = excel.save();
  if (bytes != null) {
    final file = File('/Users/itmis/Projects/priticious/new_products_import.xlsx');
    file.writeAsBytesSync(bytes);
    print('Generated new_products_import.xlsx using Dart Excel library (${bytes.length} bytes)');
  }

  // Now verify decodeBytes on the generated file!
  final readBytes = File('/Users/itmis/Projects/priticious/new_products_import.xlsx').readAsBytesSync();
  final decoded = Excel.decodeBytes(readBytes);
  print('Decoded tables: ${decoded.tables.keys}');
  final sheet = decoded.tables['New Products']!;
  print('Sheet rows count: ${sheet.maxRows}');
  print('First product row name: ${sheet.rows[1][0]?.value}');
  print('SUCCESSFULLY CREATED AND VERIFIED DART EXCEL FILE!');
}
