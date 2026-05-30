import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';

class PantryListCard extends StatefulWidget {
  const PantryListCard({
    super.key,
    required this.totalLabel,
    required this.items,
  });

  final String totalLabel;
  final List<Widget> items;

  @override
  State<PantryListCard> createState() => _PantryListCardState();
}

class _PantryListCardState extends State<PantryListCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Row(
              children: [
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
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
                      widget.totalLabel,
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
          ),
          if (_expanded) ...[
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: AppColors.inactive),
            const SizedBox(height: 16),
            for (final item in widget.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: item,
              ),
          ],
        ],
      ),
    );
  }
}
