import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/bottom_nav_bar.dart';
import 'add_item_firestore_service.dart';
import 'add_item_form_controller.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});

  static const String routeName = '/add-item';

  static final AddItemFirestoreService _addItemFirestoreService =
      AddItemFirestoreService();

  @override
  Widget build(BuildContext context) {
    final arguments = _AddItemPageArguments.fromContext(context);

    return ChangeNotifierProvider(
      create: (_) => AddItemFormController(
        addItemFirestoreService: _addItemFirestoreService,
        initialCategory: arguments.category,
        barcode: arguments.barcode,
      ),
      child: const _AddItemPageContent(),
    );
  }
}

class _AddItemPageContent extends StatelessWidget {
  const _AddItemPageContent();

  Future<void> _pickExpirationDate(BuildContext context) async {
    final controller = context.read<AddItemFormController>();
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedExpirationDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );

    if (selectedDate == null) {
      return;
    }

    controller.changeExpirationDate(selectedDate);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');

    return '$day/$month/$year';
  }

  Future<void> _handleSave(BuildContext context) async {
    final controller = context.read<AddItemFormController>();

    final result = await controller.save();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));

    if (result.success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddItemFormController>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
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
            if (controller.barcode != null) ...[
              _BarcodeInfoCard(barcode: controller.barcode!),
              const SizedBox(height: 16),
            ],
            _TextInputField(
              label: 'Nome do item',
              hintText: 'Ex: Pão francês',
              controller: controller.nameController,
            ),
            const SizedBox(height: 8),
            _DropdownInputField<String>(
              label: 'Categoria',
              value: controller.selectedCategory,
              items: controller.categoryOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.changeCategory,
            ),
            const SizedBox(height: 8),
            _DropdownInputField<String>(
              label: 'Tipo',
              value: controller.selectedType,
              items: AddItemFormController.typeOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.changeType,
            ),
            const SizedBox(height: 8),
            _DropdownInputField<int>(
              label: 'Quantidade',
              value: controller.selectedQuantity,
              items: AddItemFormController.quantityOptions,
              itemLabelBuilder: (value) => value.toString(),
              onChanged: controller.changeQuantity,
            ),
            const SizedBox(height: 8),
            _DatePickerInputField(
              label: controller.selectedExpirationDate == null
                  ? 'Data de validade'
                  : _formatDate(controller.selectedExpirationDate!),
              onTap: () => _pickExpirationDate(context),
            ),
            const SizedBox(height: 16),
            ActionButton(
              label: controller.isSaving
                  ? 'Salvando...'
                  : 'Adiciona à despensa',
              onTap: controller.isSaving ? () {} : () => _handleSave(context),
            ),
          ],
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

class _TextInputField extends StatelessWidget {
  const _TextInputField({
    required this.label,
    required this.hintText,
    required this.controller,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.next,
        style: GoogleFonts.inter(
          fontSize: 18,
          color: Colors.black,
          height: 1.0,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: InputBorder.none,
          labelStyle: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
          hintStyle: GoogleFonts.inter(fontSize: 16, color: Colors.black38),
        ),
      ),
    );
  }
}

class _DropdownInputField<T> extends StatelessWidget {
  const _DropdownInputField({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T value) itemLabelBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
            size: 28,
          ),
          hint: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.black,
              height: 1.0,
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 18,
            color: Colors.black,
            height: 1.0,
          ),
          dropdownColor: AppColors.cardGray,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DatePickerInputField extends StatelessWidget {
  const _DatePickerInputField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: AppColors.cardGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
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
