import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class PantrySuggestionTile extends StatelessWidget {
  const PantrySuggestionTile({
    super.key,
    required this.name,
    required this.reason,
    required this.onAdd,
  });

  final String name;
  final String reason;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  reason,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAdd,
            child: const Icon(Icons.add_circle, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
