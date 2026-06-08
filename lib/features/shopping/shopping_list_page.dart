import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/pantry/components/action_button.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shopping/shopping_list_item.dart';
import 'add_shopping_item_page.dart';
import 'data/shopping_store.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  static const String routeName = '/shopping-list';

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
                title: 'Lista de Compras',
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),
              Text(
                'Lista de Compras',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 24),
              StreamBuilder(
                stream: ShoppingStore.watch(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      'Erro ao carregar: ${snapshot.error}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.danger,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Text(
                      'Sua lista está vazia. Toque no + para adicionar.',
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < docs.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        Dismissible(
                          key: ValueKey(docs[i].id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => ShoppingStore.remove(docs[i].id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: ShoppingListItem(
                            label: docs[i]['name'],
                            checked: docs[i]['checked'],
                            onTap: () => ShoppingStore.toggle(
                              docs[i].id,
                              docs[i]['checked'],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              ActionButton(
                label: 'Concluir',
                onTap: () async {
                  await ShoppingStore.clearAll();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                    );
                  }
                },
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
        onPressed: () =>
            Navigator.pushNamed(context, AddShoppingItemPage.routeName),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
