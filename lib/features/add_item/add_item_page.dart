import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/action_button.dart';
import '../../widgets/add_item/select_field.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/search_box.dart';
import 'add_item_firestore_service.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});

  static const String routeName = '/add-item';

  static final AddItemFirestoreService _addItemFirestoreService =
      AddItemFirestoreService();

  Future<void> _handleSave(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(context, 'Faça login para adicionar itens à despensa.');
      return;
    }

    final arguments = _AddItemPageArguments.fromContext(context);

    final input = await _showManualItemDialog(context);

    if (!context.mounted || input == null) {
      return;
    }

    final result = await _addItemFirestoreService.addManualItem(
      userId: user.uid,
      name: input.name,
      quantity: input.quantity,
      category: arguments.category,
      type: input.type,
      barcode: arguments.barcode,
    );

    if (!context.mounted) {
      return;
    }

    _showMessage(context, result.message);

    if (result.success) {
      Navigator.pop(context, true);
    }
  }

  Future<_ManualItemInput?> _showManualItemDialog(BuildContext context) async {
    var name = '';
    var quantityText = '1';
    var type = 'Unidade';

    return showDialog<_ManualItemInput>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  name = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Nome do item',
                  hintText: 'Ex: Leite integral',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  quantityText = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: 'Ex: 1',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  type = value.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  hintText: 'Ex: Unidade, pacote, caixa',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final quantity = int.tryParse(quantityText) ?? 1;

                Navigator.pop(
                  dialogContext,
                  _ManualItemInput(
                    name: name,
                    quantity: quantity,
                    type: type.isEmpty ? null : type,
                  ),
                );
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final arguments = _AddItemPageArguments.fromContext(context);

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
              if (arguments.barcode != null) ...[
                _BarcodeInfoCard(barcode: arguments.barcode!),
                const SizedBox(height: 16),
              ],
              const SearchBox(),
              const SizedBox(height: 16),
              SelectField(
                label: arguments.category ?? 'Categoria',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              SelectField(label: 'Tipo', onTap: () {}),
              const SizedBox(height: 8),
              SelectField(label: 'Quantidade', onTap: () {}),
              const SizedBox(height: 16),
              ActionButton(
                label: 'Adiciona à despensa',
                onTap: () => _handleSave(context),
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

final class _AddItemPageArguments {
  const _AddItemPageArguments({this.category, this.barcode, this.source});

  final String? category;
  final String? barcode;
  final String? source;

  factory _AddItemPageArguments.fromContext(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is String) {
      return _AddItemPageArguments(category: arguments);
    }

    if (arguments is Map) {
      return _AddItemPageArguments(
        category: _readString(arguments['category']),
        barcode: _readString(arguments['barcode']),
        source: _readString(arguments['source']),
      );
    }

    return const _AddItemPageArguments();
  }

  static String? _readString(Object? value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }
}

final class _ManualItemInput {
  const _ManualItemInput({
    required this.name,
    required this.quantity,
    this.type,
  });

  final String name;
  final int quantity;
  final String? type;
}

class _BarcodeInfoCard extends StatelessWidget {
  const _BarcodeInfoCard({required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.qr_code_2),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Código lido: $barcode',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
