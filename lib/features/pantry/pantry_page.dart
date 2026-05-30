import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/pantry/pantry_action_button.dart';
import '../../widgets/pantry/pantry_item_row.dart';
import '../../widgets/pantry/pantry_list_card.dart';
import '../../widgets/pantry/recipe_card.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  static const String routeName = '/pantry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Despensa',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PantryActionButton(
                icon: Icons.add_box_outlined,
                label: 'Adicionar item por código de barras',
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              PantryActionButton(
                icon: Icons.grid_view_rounded,
                label: 'Adicionar item por categoria',
                backgroundColor: AppColors.cardGray,
                foregroundColor: AppColors.textPrimary,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              const PantryListCard(
                totalLabel: '25 itens na despensa',
                items: [
                  PantryItemRow(name: 'Item', quantity: '2un.'),
                  PantryItemRow(name: 'Item', quantity: '2un.'),
                  PantryItemRow(name: 'Item', quantity: '2un.'),
                  PantryItemRow(name: 'Item', quantity: '2un.'),
                  PantryItemRow(name: 'Item', quantity: '2un.'),
                  PantryItemRow(name: 'Item', quantity: '2un.'),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Sugestões',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    RecipeCard(
                      name: 'Bolo de ovos',
                      imagePath: 'assets/images/despensa-recipe-1.png',
                    ),
                    SizedBox(width: 11),
                    RecipeCard(
                      name: 'Strogonoff de frango',
                      imagePath: 'assets/images/despensa-recipe-2.png',
                    ),
                    SizedBox(width: 11),
                    RecipeCard(
                      name: 'Escondidinho de carne',
                      imagePath: 'assets/images/despensa-recipe-3.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        ),
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
