import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/responsive_page.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  static const stores = [
    {
      'city': 'Bengaluru - HSR Layout',
      'address': 'No. 452, 27th Main Rd, Sector 1, HSR Layout, Bengaluru, Karnataka 560102',
      'phone': '+91-7483600212',
      'timing': '9:30 AM - 10:00 PM (All Days)',
    },
    {
      'city': 'Bengaluru - Indiranagar',
      'address': '100 Feet Rd, 12th Main Corner, Indiranagar, Bengaluru, Karnataka 560038',
      'phone': '+91-9364896022',
      'timing': '9:30 AM - 10:00 PM (All Days)',
    },
    {
      'city': 'Hyderabad - Jubilee Hills',
      'address': 'Road No. 36, Near Metro Station, Jubilee Hills, Hyderabad, Telangana 500033',
      'phone': '+91-9876543210',
      'timing': '10:00 AM - 9:30 PM (All Days)',
    },
    {
      'city': 'Mumbai - Bandra West',
      'address': 'Linking Road, Opposite Shoppers Stop, Bandra West, Mumbai, Maharashtra 400050',
      'phone': '+91-9820123456',
      'timing': '10:00 AM - 10:00 PM (All Days)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Locations')),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OUR RETAIL STORES',
                  style: GoogleFonts.josefinSans(
                    color: const Color(0xFF4A3700),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Visit our experience centers to taste our fresh harvest and customized gift hampers.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),

                for (final store in stores)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEBE5DF)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F6F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: Color(0xFFC59B27), size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store['city']!,
                                style: GoogleFonts.josefinSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: const Color(0xFF4A3700),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                store['address']!,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 14, color: Color(0xFFD4AF37)),
                                  const SizedBox(width: 4),
                                  Text(store['phone']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.access_time, size: 14, color: Color(0xFFD4AF37)),
                                  const SizedBox(width: 4),
                                  Text(store['timing']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
