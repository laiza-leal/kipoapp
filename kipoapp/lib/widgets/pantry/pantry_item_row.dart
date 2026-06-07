import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class PantryItemRow extends StatelessWidget {
  const PantryItemRow({
    super.key,
    required this.name,
    required this.quantity,
  });

  final String name;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.image_outlined, color: Colors.black, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.black,
                height: 1.0,
              ),
            ),
          ),
          Text(
            quantity,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
