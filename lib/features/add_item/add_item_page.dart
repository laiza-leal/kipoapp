import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/add_item/select_field.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});

  static const String routeName = '/add-item';

  // Cor do botão "Adiciona à despensa" (azul do design).
  static const Color _addButtonColor = Color(0xFF28829F);

  @override
  Widget build(BuildContext context) {
    // Recebe o nome da categoria que foi tocada na tela anterior.
    final category =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Categoria';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: category,
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
              SelectField(label: 'Tipo', onTap: () {}),
              const SizedBox(height: 8),
              SelectField(label: 'Quantidade', onTap: () {}),
              const SizedBox(height: 8),
              SelectField(label: 'Data de validade', onTap: () {}),
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                ),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _addButtonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Adiciona à despensa',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
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
