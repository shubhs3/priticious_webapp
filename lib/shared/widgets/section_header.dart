import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8B830), Color(0xFFC59B27)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.josefinSans(
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      color: const Color(0xFF4A3700),
                    ),
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton.icon(
              onPressed: onAction,
              icon: Text(
                actionLabel!,
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: const Color(0xFFC59B27),
                ),
              ),
              label: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Color(0xFFC59B27),
              ),
            ),
        ],
      ),
    );
  }
}

