import csv
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

products = [
    {
        "name": "Shelled Akhrot",
        "category_slug": "walnuts",
        "item_category": "Chilli AKHROT",
        "description": "Premium shelled walnuts with fresh, crisp half-kernels. Rich in Omega-3 fatty acids, antioxidants, and essential nutrients for brain health.",
        "price": 1100.0,
        "discount_price": 980.0,
        "stock": 100,
        "storage": "Store in a cool, dry place in an airtight container. Refrigeration recommended for extended freshness."
    },
    {
        "name": "Amrican Giri Badam",
        "category_slug": "almonds",
        "item_category": "BADAM",
        "description": "High-grade California / American almond kernels. Naturally sweet, crunchy, and packed with Vitamin E, protein, and dietary fiber.",
        "price": 1200.0,
        "discount_price": 1040.0,
        "stock": 150,
        "storage": "Store in a cool, dry place away from direct sunlight."
    },
    {
        "name": "1 pcs Kaaju",
        "category_slug": "cashews",
        "item_category": "KAAJU-240 nos",
        "description": "Premium W-240 jumbo whole cashew nuts. Rich, creamy texture and whole shape perfect for premium snacking, sweets, and festive gifting.",
        "price": 1150.0,
        "discount_price": 1020.0,
        "stock": 120,
        "storage": "Keep in an airtight container in a dry place."
    },
    {
        "name": "Pista Salted",
        "category_slug": "pistachios",
        "item_category": "PISTA",
        "description": "Lightly salted roasted pistachios in shell. Crunchy, savory snack packed with protein, healthy fats, and antioxidants.",
        "price": 1490.0,
        "discount_price": 1330.0,
        "stock": 100,
        "storage": "Store in a cool, dark, airtight container to maintain crispiness."
    },
    {
        "name": "KISHMIS",
        "category_slug": "raisins",
        "item_category": "KISHMIS",
        "description": "Naturally sun-dried sweet Indian green raisins. Soft, juicy, and rich in natural iron, potassium, and quick energy.",
        "price": 700.0,
        "discount_price": 620.0,
        "stock": 150,
        "storage": "Keep in a cool, dry place or refrigerate to preserve moisture."
    },
    {
        "name": "Makahna",
        "category_slug": "makhana",
        "item_category": "MAKAHANA",
        "description": "Premium quality giant fox nuts (Phool Makhana). Low in calories, rich in calcium and protein—ideal for healthy guilt-free snacking and fasting.",
        "price": 1400.0,
        "discount_price": 1260.0,
        "stock": 100,
        "storage": "Keep in an airtight container to retain crispness."
    },
    {
        "name": "Anjeer",
        "category_slug": "anjeer",
        "item_category": "Anjeer",
        "description": "Soft and chewy premium dried figs. Packed with dietary fiber, iron, calcium, and minerals for digestive health and immunity.",
        "price": 1400.0,
        "discount_price": 1260.0,
        "stock": 80,
        "storage": "Store in a cool, dry place in a closed box."
    },
    {
        "name": "Mix Healthy Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Power-packed superfood blend of pumpkin, chia, flax, sunflower, and watermelon seeds. Ideal for smoothie bowls, yogurt, and daily snacking.",
        "price": 650.0,
        "discount_price": 550.0,
        "stock": 100,
        "storage": "Keep in a cool, dry container."
    },
    {
        "name": "Elaichi",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Premium aromatic green cardamom pods (Choti Elaichi). Intense natural fragrance and flavor for sweets, tea, biryanis, and traditional recipes.",
        "price": 3500.0,
        "discount_price": 3120.0,
        "stock": 50,
        "storage": "Store in a cool, dry, dark airtight jar to lock in essential oils."
    },
    {
        "name": "Kaagzi Badam",
        "category_slug": "almonds",
        "item_category": "BADAM",
        "description": "Thin-shelled raw almonds (Kaagzi Badam) that crack open easily by hand. Sweet internal kernels packed with traditional wholesome nourishment.",
        "price": 700.0,
        "discount_price": 610.0,
        "stock": 80,
        "storage": "Keep in a dry, well-ventilated container."
    },
    {
        "name": "Munakka",
        "category_slug": "raisins",
        "item_category": "MUNAKKA",
        "description": "Large sweet brown seeded raisins (Munakka). Traditionally prized in Ayurveda for soothing digestion, improving hemoglobin, and boosting vitality.",
        "price": 890.0,
        "discount_price": 780.0,
        "stock": 90,
        "storage": "Store in a cool, dry place."
    },
    {
        "name": "Gurbandi Giri Badam",
        "category_slug": "almonds",
        "item_category": "BADAM",
        "description": "Authentic Afghan Gurbandi almond kernels. Rich in natural almond oils, distinct nut flavor, and unmatched nutritional richness.",
        "price": 1500.0,
        "discount_price": 1320.0,
        "stock": 70,
        "storage": "Store in an airtight container away from heat."
    },
    {
        "name": "Chuhara",
        "category_slug": "dates",
        "item_category": "Chuhara",
        "description": "Dry yellow/red dates (Dry Chuhara). High in dietary fiber, iron, and natural sugars—great for energy milk preparations and traditional sweets.",
        "price": 500.0,
        "discount_price": 430.0,
        "stock": 100,
        "storage": "Store in a cool, dry place."
    },
    {
        "name": "Pind Khajoor",
        "category_slug": "dates",
        "item_category": "Khajoor",
        "description": "Soft, moist, and naturally sweet Pind dates. Great source of quick energy, natural sweetness, and daily dietary minerals.",
        "price": 450.0,
        "discount_price": 390.0,
        "stock": 120,
        "storage": "Keep in a cool place or refrigerate after opening."
    },
    {
        "name": "Mamra Giri Badam",
        "category_slug": "almonds",
        "item_category": "BADAM",
        "description": "Exquisite Iranian Mamra Badam Giri. Ultra-premium almond kernels known for high oil content, concaved shape, and supreme health benefits.",
        "price": 4200.0,
        "discount_price": 3780.0,
        "stock": 40,
        "storage": "Refrigerate in an airtight container for maximum freshness."
    },
    {
        "name": "Daalchini",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Whole aromatic Ceylon cinnamon sticks (Daalchini). Fragrant, sweet spice stick ideal for curries, desserts, teas, and immunity drinks.",
        "price": 680.0,
        "discount_price": 590.0,
        "stock": 100,
        "storage": "Store in a cool, dry glass container."
    },
    {
        "name": "Akhrot Giri",
        "category_slug": "walnuts",
        "item_category": "AKHROT",
        "description": "Extra-light handpicked walnut kernels (Akhrot Giri halves). Fresh, buttery, rich in Omega-3 fatty acids, and beneficial for brain & heart health.",
        "price": 1950.0,
        "discount_price": 1740.0,
        "stock": 60,
        "storage": "Store in a cool, dry, airtight container. Refrigeration recommended."
    },
    {
        "name": "Gola",
        "category_slug": "gola",
        "item_category": "Gola",
        "description": "Whole dried coconut cup (Sukha Gola / Khopra). Natural coconut fats and flavor used widely in traditional cooking, sweets, and worship.",
        "price": 500.0,
        "discount_price": 440.0,
        "stock": 100,
        "storage": "Keep in a dry, ventilated place."
    },
    {
        "name": "Gulla Chuhara",
        "category_slug": "dates",
        "item_category": "Chuhara",
        "description": "Round dry dates (Gulla Chuhara). Crunchy texture with rich natural sweetness, useful for festive prasad and sweet dishes.",
        "price": 480.0,
        "discount_price": 420.0,
        "stock": 80,
        "storage": "Store in a cool, dry container."
    },
    {
        "name": "Jumbo Kaaju (150 No.)",
        "category_slug": "cashews",
        "item_category": "KAAJU",
        "description": "King-size W-150 grade Jumbo cashew nuts. Exceptionally large, creamy, and pristine—ideal for luxury gift packs and gourmet recipes.",
        "price": 1300.0,
        "discount_price": 1150.0,
        "stock": 70,
        "storage": "Keep in an airtight jar in a cool, dry place."
    },
    {
        "name": "Gulkand",
        "category_slug": "gulkand",
        "item_category": "Gulkand",
        "description": "Traditional sweet preserve of damask rose petals and natural sugar. Cooling herbal mouth-freshener that aids digestion and acidity relief.",
        "price": 620.0,
        "discount_price": 550.0,
        "stock": 90,
        "storage": "Refrigerate after opening."
    },
    {
        "name": "2 pcs Kaaju",
        "category_slug": "cashews",
        "item_category": "KAAJU",
        "description": "Split cashew halves (2-piece cashew). Ideal for everyday home cooking, gravies, garnishing, and baking.",
        "price": 25.0,
        "discount_price": 20.0,
        "stock": 500,
        "storage": "Store in a dry airtight container."
    },
    {
        "name": "Mirch",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Premium ground red chili powder (Lal Mirch). Vibrant color, spicy kick, and authentic pungent flavor for Indian curries.",
        "price": 25.0,
        "discount_price": 20.0,
        "stock": 300,
        "storage": "Store in a sealed container in a dark cabinet."
    },
    {
        "name": "Garam Masala",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Aromatic Indian spice mix blended from roasted whole spices. Elevates curries, dals, and gravies with rich warmth and aroma.",
        "price": 25.0,
        "discount_price": 20.0,
        "stock": 300,
        "storage": "Keep in an airtight spice container."
    },
    {
        "name": "Kali mirch",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Whole black peppercorns (Kali Mirch). Pungent, spicy peppercorns rich in piperine for health, digestion, and daily seasoning.",
        "price": 25.0,
        "discount_price": 20.0,
        "stock": 300,
        "storage": "Keep dry in an airtight container."
    },
    {
        "name": "Mirch sabut",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Whole dried red chillies (Sabut Lal Mirch). Rich red pigment and strong spice level for tempering (tadka) and spice blends.",
        "price": 25.0,
        "discount_price": 20.0,
        "stock": 300,
        "storage": "Keep in a dry container."
    },
    {
        "name": "Sabut dhaniya",
        "category_slug": "spices",
        "item_category": "SPICES",
        "description": "Whole coriander seeds (Sabut Dhaniya). Earthy, citrusy aroma essential for Indian spice pastes, powders, and gravies.",
        "price": 25.0,
        "discount_price": 20.0,
        "stock": 300,
        "storage": "Store in a cool, dry place."
    },
    {
        "name": "Dry Blueberry",
        "category_slug": "berries",
        "item_category": "Blueberry",
        "description": "Whole dried blueberries. Bursting with natural sweetness, rich in antioxidants, Vitamin C, and daily dietary fiber.",
        "price": 1950.0,
        "discount_price": 1760.0,
        "stock": 80,
        "storage": "Store in a cool, dry place or refrigerate for prolonged shelf life."
    },
    {
        "name": "Dry Cranberry",
        "category_slug": "berries",
        "item_category": "Dry Cranberry",
        "description": "Soft and tangy dried cranberries. Perfect balance of sweet and tart taste, packed with antioxidants and health benefits.",
        "price": 1300.0,
        "discount_price": 1150.0,
        "stock": 90,
        "storage": "Store in a cool, dark, airtight container."
    },
    {
        "name": "Khuskhus",
        "category_slug": "spices",
        "item_category": "Khuskhus",
        "description": "White poppy seeds (Khus Khus). Rich in minerals and calcium, widely used for thickening curries, thandai, and traditional desserts.",
        "price": 1850.0,
        "discount_price": 1660.0,
        "stock": 60,
        "storage": "Keep dry in an airtight container away from humidity."
    },
    {
        "name": "Kharbuja Giri",
        "category_slug": "seeds",
        "item_category": "Kharbuja Giri",
        "description": "Raw melon seeds (Kharbuja Giri). Nutrient-dense seeds loaded with plant protein, magnesium, and zinc for healthy snacking and cooking.",
        "price": 1100.0,
        "discount_price": 980.0,
        "stock": 90,
        "storage": "Keep in an airtight container in a dry location."
    },
    {
        "name": "Mungfali",
        "category_slug": "mixed-nuts",
        "item_category": "Mungfali",
        "description": "High-grade raw shelled peanuts (Mungfali Giri). Excellent source of plant protein, healthy fats, and energy for roasting or cooking.",
        "price": 190.0,
        "discount_price": 160.0,
        "stock": 200,
        "storage": "Store in a dry place."
    },
    {
        "name": "Sasme Seeds Til",
        "category_slug": "seeds",
        "item_category": "White TIL",
        "description": "Cleaned hulled white sesame seeds (Safed Til). Rich in calcium and healthy fats, ideal for winter sweets, baking, and garnishing.",
        "price": 270.0,
        "discount_price": 230.0,
        "stock": 150,
        "storage": "Keep dry in an airtight jar."
    },
    {
        "name": "1 pcs Kaaju Salted",
        "category_slug": "cashews",
        "item_category": "kaaju",
        "description": "Crisp roasted whole cashews with a touch of Himalayan salt. Creamy, savory snack perfect for tea-time and entertaining guests.",
        "price": 1400.0,
        "discount_price": 1250.0,
        "stock": 100,
        "storage": "Store in an airtight box to keep crunchy."
    },
    {
        "name": "Chia Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Raw organic chia seeds. Loaded with Omega-3, fiber, and protein. Expands in liquids to form healthy puddings and smoothie toppers.",
        "price": 530.0,
        "discount_price": 470.0,
        "stock": 120,
        "storage": "Store in a cool, dry place."
    },
    {
        "name": "Flex Seeds Roasted",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Crunchy roasted flax seeds (Alsi). Rich in lignans and dietary fiber, perfect as a digestive after-meal snack.",
        "price": 450.0,
        "discount_price": 390.0,
        "stock": 100,
        "storage": "Store in an airtight jar."
    },
    {
        "name": "Flex Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Raw natural flax seeds (Alsi). Abundant in Omega-3 fatty acids and fiber, ideal for grinding into daily powders or breakfast bowls.",
        "price": 200.0,
        "discount_price": 170.0,
        "stock": 150,
        "storage": "Store in a cool, dry place."
    },
    {
        "name": "Sunflower Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Shelled raw sunflower seed kernels. Rich in Vitamin E, selenium, and healthy fats for heart health and glowing skin.",
        "price": 420.0,
        "discount_price": 360.0,
        "stock": 110,
        "storage": "Store in a cool, dry place."
    },
    {
        "name": "Pumpkin Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "AAA-grade raw pumpkin seeds (Kaddu Giri). High in zinc, magnesium, and antioxidants for prostate, heart, and immunity health.",
        "price": 780.0,
        "discount_price": 680.0,
        "stock": 100,
        "storage": "Keep in an airtight container in a cool spot."
    },
    {
        "name": "Besil Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Sweet basil seeds (Sabja Seeds). Natural cooling agent rich in fiber; swells quickly in water for faloodas, lemonade, and summer drinks.",
        "price": 880.0,
        "discount_price": 780.0,
        "stock": 90,
        "storage": "Keep dry in a moisture-free container."
    },
    {
        "name": "Chilgoza",
        "category_slug": "mixed-nuts",
        "item_category": "Chilgoza",
        "description": "Luxury raw pine nuts in shell (Chilgoza). Rare, exotic dry fruit packed with pinolenic acid, high protein, and unmatched butteriness.",
        "price": 5800.0,
        "discount_price": 5120.0,
        "stock": 30,
        "storage": "Store in a refrigerator in a tight jar."
    },
    {
        "name": "Arjun Chaal",
        "category_slug": "ayurvedic",
        "item_category": "Arjun Chaal",
        "description": "Pure dried Terminalia Arjuna bark (Arjun Chaal). Renowned Ayurvedic botanical herbal remedy for heart wellness and blood pressure support.",
        "price": 300.0,
        "discount_price": 260.0,
        "stock": 80,
        "storage": "Store in a dry place away from moisture."
    },
    {
        "name": "Chironji",
        "category_slug": "mixed-nuts",
        "item_category": "Dry Cranberry",
        "description": "Premium whole Chironji seeds (Charoli). Nutty taste with high protein and essential oils, prized in Indian sweets, kheer, and Mughlai curries.",
        "price": 1980.0,
        "discount_price": 1780.0,
        "stock": 50,
        "storage": "Store in a cool, dry airtight container."
    },
    {
        "name": "Priticious Special",
        "category_slug": "spices",
        "item_category": "Powder",
        "description": "Signature Priticious dry fruit powder mix. Master blend of ground almonds, pistachios, cashews, saffron, and cardamom for energy milk mixes.",
        "price": 1300.0,
        "discount_price": 1150.0,
        "stock": 70,
        "storage": "Store in a cool place in an airtight jar."
    },
    {
        "name": "Mishri",
        "category_slug": "sweets",
        "item_category": "Mishri",
        "description": "Pure rock sugar crystals (Dhaaga Mishri). Traditional digestive mouth freshener and unrefined natural sweetener for prasad and beverages.",
        "price": 130.0,
        "discount_price": 110.0,
        "stock": 150,
        "storage": "Keep in a dry, moisture-free jar."
    },
    {
        "name": "Fitkari",
        "category_slug": "ayurvedic",
        "item_category": "Fitkari",
        "description": "Pure natural Alum stone crystal (Phitkari). Multi-purpose traditional mineral for water purification, skin care, and mouth hygiene.",
        "price": 120.0,
        "discount_price": 100.0,
        "stock": 100,
        "storage": "Keep dry."
    },
    {
        "name": "Pista Pishori",
        "category_slug": "pistachios",
        "item_category": "Pista Pishori",
        "description": "Authentic Peshawari green pistachio kernels (Pishori Pista). Vibrant green color, rich nut aroma, and exquisite taste for luxury desserts.",
        "price": 4300.0,
        "discount_price": 3880.0,
        "stock": 40,
        "storage": "Store in a cool place or refrigerate."
    },
    {
        "name": "WaterMelon Seeds",
        "category_slug": "seeds",
        "item_category": "Seeds",
        "description": "Shelled raw watermelon seed kernels (Tarbooj Giri). Nutrient-dense source of protein, iron, and magnesium for heart health and daily vitality.",
        "price": 750.0,
        "discount_price": 650.0,
        "stock": 100,
        "storage": "Store in an airtight container in a dry place."
    }
]

def generate_excel():
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "New Products"
    
    # Header Styling
    header_font = Font(name="Calibri", size=11, bold=True, color="FFFFFF")
    header_fill = PatternFill(start_color="2A5C84", end_color="2A5C84", fill_type="solid")
    center_align = Alignment(horizontal="center", vertical="center", wrap_text=True)
    left_align = Alignment(horizontal="left", vertical="center", wrap_text=True)
    right_align = Alignment(horizontal="right", vertical="center")
    
    thin_border = Border(
        left=Side(style='thin', color='D3D3D3'),
        right=Side(style='thin', color='D3D3D3'),
        top=Side(style='thin', color='D3D3D3'),
        bottom=Side(style='thin', color='D3D3D3')
    )
    
    headers = [
        "Name",
        "Category Slug",
        "Description",
        "Price (Rupees)",
        "Discount Price (Rupees)",
        "Stock",
        "Storage Instructions"
    ]
    
    ws.append(headers)
    ws.row_dimensions[1].height = 28
    
    for col_idx, h in enumerate(headers, start=1):
        cell = ws.cell(row=1, column=col_idx)
        cell.font = header_font
        cell.fill = header_fill
        cell.alignment = center_align
        cell.border = thin_border
        
    alt_fill = PatternFill(start_color="F9FBFD", end_color="F9FBFD", fill_type="solid")
    
    for row_idx, p in enumerate(products, start=2):
        ws.append([
            p["name"],
            p["category_slug"],
            p["description"],
            p["price"],
            p["discount_price"],
            p["stock"],
            p["storage"]
        ])
        ws.row_dimensions[row_idx].height = 24
        
        for col_idx in range(1, 8):
            cell = ws.cell(row=row_idx, column=col_idx)
            cell.border = thin_border
            if row_idx % 2 == 1:
                cell.fill = alt_fill
                
            if col_idx in [1, 2, 3, 7]:
                cell.alignment = left_align
            elif col_idx in [4, 5]:
                cell.alignment = right_align
                cell.number_format = '0.00'
            elif col_idx == 6:
                cell.alignment = center_align
                cell.number_format = '0'

    column_widths = {
        "A": 26,
        "B": 18,
        "C": 65,
        "D": 16,
        "E": 22,
        "F": 12,
        "G": 45
    }
    
    for col_letter, width in column_widths.items():
        ws.column_dimensions[col_letter].width = width

    excel_path = "/Users/itmis/Projects/priticious/new_products_import.xlsx"
    wb.save(excel_path)
    print(f"Clean single-sheet Excel generated at: {excel_path}")

def generate_csv():
    csv_path = "/Users/itmis/Projects/priticious/new_products_import.csv"
    headers = [
        "Name",
        "Category Slug",
        "Description",
        "Price (Rupees)",
        "Discount Price (Rupees)",
        "Stock",
        "Storage Instructions"
    ]
    with open(csv_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        for p in products:
            writer.writerow([
                p["name"],
                p["category_slug"],
                p["description"],
                p["price"],
                p["discount_price"],
                p["stock"],
                p["storage"]
            ])
    print(f"CSV generated at: {csv_path}")

if __name__ == "__main__":
    generate_excel()
    generate_csv()
