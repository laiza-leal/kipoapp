import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/categories/category_card.dart';
import '../../widgets/search_box.dart';
import '../add_item/add_item_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static const String routeName = '/categories';

  void _openCategory(BuildContext context, String name) {
    Navigator.pushNamed(context, AddItemPage.routeName, arguments: name);
  }

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
                  children: [
                    CategoryCard(
                      label: 'Mercearia',
                      imagePath: 'assets/images/categoria-mercearia.png',
                      onTap: () => _openCategory(context, 'Mercearia'),
                    ),
                    CategoryCard(
                      label: 'Açougue e Peixaria',
                      imagePath: 'assets/images/categoria-acougue.png',
                      onTap: () => _openCategory(context, 'Açougue e Peixaria'),
                    ),
                    CategoryCard(
                      label: 'Frios e Laticínios',
                      imagePath: 'assets/images/categoria-frios.png',
                      onTap: () => _openCategory(context, 'Frios e Laticínios'),
                    ),
                    CategoryCard(
                      label: 'Hortifruti',
                      imagePath: 'assets/images/categoria-hortifruti.png',
                      onTap: () => _openCategory(context, 'Hortifruti'),
                    ),
                    CategoryCard(
                      label: 'Padaria e Confeitaria',
                      imagePath: 'assets/images/categoria-padaria.png',
                      onTap: () =>
                          _openCategory(context, 'Padaria e Confeitaria'),
                    ),
                    CategoryCard(
                      label: 'Bebidas',
                      imagePath: 'assets/images/categoria-bebidas.png',
                      onTap: () => _openCategory(context, 'Bebidas'),
                    ),
                    CategoryCard(
                      label: 'Condimentos',
                      imagePath: 'assets/images/categoria-condimentos.png',
                      onTap: () => _openCategory(context, 'Condimentos'),
                    ),
                    CategoryCard(
                      label: 'Industrializados e Congelados',
                      imagePath: 'assets/images/categoria-industrializados.png',
                      onTap: () => _openCategory(
                        context,
                        'Industrializados e Congelados',
                      ),
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
        onPressed: () => Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/', (route) => false),
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
