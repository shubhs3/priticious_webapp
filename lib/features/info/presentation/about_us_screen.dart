import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/responsive_page.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        child: ResponsivePage(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF382A03),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABOUT PRITICIOUS DRY FRUITS',
                        style: GoogleFonts.josefinSans(
                          color: const Color(0xFFE8B830),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nurturing Health with Nature’s Finest Harvest',
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'At Priticious Dry Fruits, we are passionate about delivering farm-fresh, premium quality nuts, dates, berries, seeds, and spices directly to your home. Established with a vision to make healthy snacking accessible and delicious.',
                        style: GoogleFonts.josefinSans(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'Our Core Values',
                  style: GoogleFonts.josefinSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3700),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: const [
                    Expanded(
                      child: _ValueCard(
                        icon: Icons.verified_rounded,
                        title: '100% Organic & Pure',
                        description: 'Sourced directly from orchards with zero artificial preservatives.',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _ValueCard(
                        icon: Icons.handshake_outlined,
                        title: 'Fair Trade Farmers',
                        description: 'Empowering local farming communities across global harvests.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(
                      child: _ValueCard(
                        icon: Icons.sanitizer_outlined,
                        title: 'Hygienic Packaging',
                        description: 'Packed in nitrogen-flushed triple-shield airtight containers.',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _ValueCard(
                        icon: Icons.local_shipping_outlined,
                        title: 'Pan-India Delivery',
                        description: 'Express shipping to over 25,000 pin codes with tracking.',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Text(
                  'Our Story',
                  style: GoogleFonts.josefinSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3700),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Starting as a boutique store, Priticious has grown into one of India’s most trusted retail and wholesale dry fruit brands. We take immense pride in quality grading, ensuring that every almond, cashew nut, date, and spice particle meets rigorous international standards.',
                  style: GoogleFonts.josefinSans(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF444444),
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

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEBE5DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFC59B27), size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: const Color(0xFF4A3700),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
