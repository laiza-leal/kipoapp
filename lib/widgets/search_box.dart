import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';

/// Caixa de busca (ícone de lupa + texto "Buscar").
class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 24, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            'Buscar',
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
