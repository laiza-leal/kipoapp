import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/pantry/components/action_button.dart';
import '../../widgets/pantry/add_item/select_field.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/pantry/components/search_box.dart';

class AddShoppingItemPage extends StatelessWidget {
  const AddShoppingItemPage({super.key});

  static const String routeName = '/add-shopping-item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'Adicionar item',
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),
              Text(
                'Selecione:',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 24),
              const SearchBox(),
              const SizedBox(height: 16),
              SelectField(label: 'Categoria', onTap: () {}),
              const SizedBox(height: 8),
              SelectField(label: 'Tipo', onTap: () {}),
              const SizedBox(height: 8),
              SelectField(label: 'Quantidade', onTap: () {}),
              const SizedBox(height: 16),
              ActionButton(
                label: 'Adiciona à lista',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.danger,
        shape: const CircleBorder(),
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.close, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
