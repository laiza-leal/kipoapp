import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/pantry/components/action_button.dart';
import '../../widgets/shopping/pantry_suggestion_tile.dart';
import 'data/shopping_store.dart';

class AddShoppingItemPage extends StatefulWidget {
  const AddShoppingItemPage({super.key});

  static const String routeName = '/add-shopping-item';

  @override
  State<AddShoppingItemPage> createState() => _AddShoppingItemPageState();
}

class _AddShoppingItemPageState extends State<AddShoppingItemPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveTyped() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      _showMessage('Informe o nome do item.');
      return;
    }
    await ShoppingStore.add(name);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _addSuggestion(String name) async {
    await ShoppingStore.add(name);
    if (mounted) _showMessage('"$name" adicionado à lista.');
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
                title: 'Adicionar item',
                onBack: () => Navigator.pop(context),
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
                  controller: _controller,
                  style: GoogleFonts.dmSans(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, size: 24, color: Colors.black),
                    hintText: 'Nome do item',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ActionButton(
                label: 'Adiciona à lista',
                onTap: _saveTyped,
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
                future: ShoppingStore.pantrySuggestions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final suggestions = snapshot.data ?? [];
                  if (suggestions.isEmpty) {
                    return Text(
                      'Nenhuma sugestão por enquanto.',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < suggestions.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        PantrySuggestionTile(
                          name: suggestions[i].name,
                          reason: suggestions[i].reason,
                          onAdd: () => _addSuggestion(suggestions[i].name),
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
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.close, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
