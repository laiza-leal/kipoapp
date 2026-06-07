import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../../widgets/categories/category_card.dart';
import '../../../widgets/pantry/components/search_box.dart';
import '../add_item/add_item_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static const String routeName = '/categories';

  static const List<_CategoryOption> _categories = [
    _CategoryOption(
      label: 'Mercearia',
      imagePath: 'assets/images/categoria-mercearia.png',
    ),
    _CategoryOption(
      label: 'Açougue e Peixaria',
      imagePath: 'assets/images/categoria-acougue.png',
    ),
    _CategoryOption(
      label: 'Frios e Laticínios',
      imagePath: 'assets/images/categoria-frios.png',
    ),
    _CategoryOption(
      label: 'Hortifruti',
      imagePath: 'assets/images/categoria-hortifruti.png',
    ),
    _CategoryOption(
      label: 'Padaria e Confeitaria',
      imagePath: 'assets/images/categoria-padaria.png',
    ),
    _CategoryOption(
      label: 'Bebidas',
      imagePath: 'assets/images/categoria-bebidas.png',
    ),
    _CategoryOption(
      label: 'Condimentos',
      imagePath: 'assets/images/categoria-condimentos.png',
    ),
    _CategoryOption(
      label: 'Industrializados e Congelados',
      imagePath: 'assets/images/categoria-industrializados.png',
    ),
  ];

  void _openCategory(BuildContext context, String name) {
    Navigator.pushNamed(
      context,
      AddItemPage.routeName,
      arguments: {'category': name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            AppHeader(
              title: 'Categorias',
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 32),
            const SearchBox(),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _categories.map((category) {
                  return CategoryCard(
                    label: category.label,
                    imagePath: category.imagePath,
                    onTap: () => _openCategory(context, category.label),
                  );
                }).toList(),
              ),
            ),
          ],
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
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        },
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

final class _CategoryOption {
  const _CategoryOption({
    required this.label,
    required this.imagePath,
  });

  final String label;
  final String imagePath;
}