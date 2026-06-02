import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/pantry/pantry_action_button.dart';
import '../../widgets/pantry/pantry_item_row.dart';
import '../../widgets/pantry/pantry_list_card.dart';
import '../../widgets/pantry/recipe_card.dart';
import '../add_item/add_item_page.dart';
import '../barcode_item/add_item_by_barcode_service.dart';
import '../barcode_item/barcode_scanner_sheet.dart';
import '../categories/categories_page.dart';
import 'pantry_firestore_service.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  static const String routeName = '/pantry';

  static final AddItemByBarcodeService _addItemByBarcodeService =
      AddItemByBarcodeService();

  static final PantryFirestoreService _pantryFirestoreService =
      PantryFirestoreService();

  Future<void> _handleAddByBarcode(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faça login para adicionar itens à despensa.'),
        ),
      );
      return;
    }

    final rawBarcode = await showBarcodeScannerSheet(context);

    if (!context.mounted || rawBarcode == null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processando produto...'),
        duration: Duration(seconds: 1),
      ),
    );

    final result = await _addItemByBarcodeService.addFromBarcode(
      rawBarcode: rawBarcode,
      userId: user.uid,
      quantity: 1,
    );

    if (!context.mounted) {
      return;
    }

    switch (result.type) {
      case AddItemByBarcodeResultType.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result.productName ?? 'Item'} adicionado à despensa.',
            ),
          ),
        );
        break;

      case AddItemByBarcodeResultType.manualRegistrationRequired:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto não encontrado. Abrindo cadastro manual.'),
          ),
        );

        Navigator.pushNamed(
          context,
          AddItemPage.routeName,
          arguments: {'barcode': result.barcode, 'source': 'barcode'},
        );
        break;

      case AddItemByBarcodeResultType.invalidBarcode:
      case AddItemByBarcodeResultType.networkError:
      case AddItemByBarcodeResultType.firebaseError:
      case AddItemByBarcodeResultType.unknownError:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
        break;
    }
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
                onTap: () => _handleAddByBarcode(context),
              ),
              const SizedBox(height: 16),
              PantryActionButton(
                icon: Icons.grid_view_rounded,
                label: 'Adicionar item por categoria',
                backgroundColor: AppColors.cardGray,
                foregroundColor: AppColors.textPrimary,
                onTap: () {
                  Navigator.pushNamed(context, CategoriesPage.routeName);
                },
              ),
              const SizedBox(height: 16),
              _BuildPantryItemsList(
                pantryFirestoreService: _pantryFirestoreService,
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
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        },
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _BuildPantryItemsList extends StatelessWidget {
  const _BuildPantryItemsList({required this.pantryFirestoreService});

  final PantryFirestoreService pantryFirestoreService;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const PantryListCard(totalLabel: '0 itens na despensa', items: []);
    }

    return StreamBuilder<List<PantryFirestoreItem>>(
      stream: pantryFirestoreService.watchUserItems(userId: user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PantryListCard(
            totalLabel: 'Carregando despensa...',
            items: [],
          );
        }

        if (snapshot.hasError) {
          return const PantryListCard(
            totalLabel: 'Erro ao carregar despensa',
            items: [],
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const PantryListCard(
            totalLabel: '0 itens na despensa',
            items: [],
          );
        }

        return PantryListCard(
          totalLabel: '${items.length} itens na despensa',
          items: items.map((item) {
            return PantryItemRow(
              name: item.name,
              quantity: '${item.quantity}un.',
            );
          }).toList(),
        );
      },
    );
  }
}
