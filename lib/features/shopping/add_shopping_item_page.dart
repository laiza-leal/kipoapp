import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/pantry/components/action_button.dart';
import '../../widgets/shopping/pantry_suggestion_tile.dart';
import 'add_shopping_item_controller.dart';
import 'data/shopping_store.dart';

class AddShoppingItemPage extends StatelessWidget {
  const AddShoppingItemPage({super.key});

  static const String routeName = '/add-shopping-item';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddShoppingItemController>(
      create: (_) => AddShoppingItemController(),
      child: const _AddShoppingItemView(),
    );
  }
}

class _AddShoppingItemView extends StatelessWidget {
  const _AddShoppingItemView();

  Future<void> _saveTyped(BuildContext context) async {
    final AddShoppingItemController controller = context
        .read<AddShoppingItemController>();

    final AddShoppingItemResult result = await controller.saveTypedItem();

    if (!context.mounted) {
      return;
    }

    _handleResult(context, result);
  }

  Future<void> _addSuggestion(BuildContext context, String name) async {
    final AddShoppingItemController controller = context
        .read<AddShoppingItemController>();

    final AddShoppingItemResult result = await controller.addSuggestion(name);

    if (!context.mounted) {
      return;
    }

    _handleResult(context, result);
  }

  void _handleResult(BuildContext context, AddShoppingItemResult result) {
    switch (result.status) {
      case AddShoppingItemResultStatus.successClose:
        Navigator.pop(context);
        return;

      case AddShoppingItemResultStatus.successMessage:
        _showMessage(context, result.message ?? 'Item adicionado à lista.');
        return;

      case AddShoppingItemResultStatus.failure:
        _showMessage(
          context,
          result.message ?? 'Não foi possível concluir a ação.',
        );
        return;

      case AddShoppingItemResultStatus.ignored:
        return;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _closePage(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final AddShoppingItemController controller = context
        .watch<AddShoppingItemController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                title: 'Adicionar item',
                onBack: () => _closePage(context),
              ),
              const SizedBox(height: 32),
              Text(
                'Adicionar item',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: controller.itemNameController,
                  style: GoogleFonts.dmSans(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, size: 24, color: Colors.black),
                    hintText: 'Nome do item',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _saveTyped(context),
                ),
              ),
              const SizedBox(height: 16),
              ActionButton(
                label: controller.isSaving
                    ? 'Adicionando...'
                    : 'Adiciona à lista',
                onTap: controller.isSaving ? () {} : () => _saveTyped(context),
              ),
              const SizedBox(height: 32),
              Text(
                'Sugestões da despensa',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Itens que venceram, vão vencer ou acabaram.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<ShoppingSuggestion>>(
                future: controller.pantrySuggestionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'Não foi possível carregar as sugestões.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    );
                  }

                  final List<ShoppingSuggestion> suggestions =
                      snapshot.data ?? [];

                  if (suggestions.isEmpty) {
                    return Text(
                      'Nenhuma sugestão por enquanto.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (var i = 0; i < suggestions.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        PantrySuggestionTile(
                          name: suggestions[i].name,
                          reason: suggestions[i].reason,
                          onAdd: controller.isSaving
                              ? () {}
                              : () => _addSuggestion(
                                  context,
                                  suggestions[i].name,
                                ),
                        ),
                      ],
                    ],
                  );
                },
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
        onPressed: () => _closePage(context),
        child: const Icon(Icons.close, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
