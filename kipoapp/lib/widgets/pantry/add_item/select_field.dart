import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme.dart';

/// Campo de seleção: um texto à esquerda e uma seta para baixo à direita.
class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
