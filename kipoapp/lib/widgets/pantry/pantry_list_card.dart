import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class PantryListCard extends StatelessWidget {
  const PantryListCard({
    super.key,
    required this.totalLabel,
    required this.items,
  });

  final String totalLabel;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    const expanded = true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visualizar',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    totalLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: AppColors.inactive),
            const SizedBox(height: 16),
            for (final item in items)
              Padding(padding: const EdgeInsets.only(bottom: 8), child: item),
          ],
        ],
      ),
    );
  }
}
