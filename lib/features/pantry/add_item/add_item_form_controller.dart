import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_item_firestore_service.dart';

final class AddItemFormController extends ChangeNotifier {
  AddItemFormController({
    required this.addItemFirestoreService,
    FirebaseAuth? firebaseAuth,
    String? initialCategory,
    String? barcode,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       barcode = _normalizeText(barcode),
       categoryOptions = _buildCategoryOptions(initialCategory),
       selectedCategory = _normalizeText(initialCategory);

  final AddItemFirestoreService addItemFirestoreService;
  final FirebaseAuth _firebaseAuth;

  final TextEditingController nameController = TextEditingController();

  final String? barcode;
  final List<String> categoryOptions;

  String? selectedCategory;
  String selectedType = 'Unidade';
  int selectedQuantity = 1;
  DateTime? selectedExpirationDate;
  bool isSaving = false;

  static const List<String> _defaultCategoryOptions = [
    'Mercearia',
    'Açougue e Peixaria',
    'Frios e Laticínios',
    'Hortifruti',
    'Padaria e Confeitaria',
    'Bebidas',
    'Condimentos',
    'Industrializados e Congelados',
  ];

  static const List<String> typeOptions = [
    'Unidade',
    'Pacote',
    'Caixa',
    'Garrafa',
    'Lata',
    'Kg',
    'g',
    'Litro',
    'mL',
  ];

  static final List<int> quantityOptions = List<int>.unmodifiable(
    List<int>.generate(30, (index) => index + 1),
  );

  void changeCategory(String? value) {
    selectedCategory = _normalizeText(value);
    notifyListeners();
  }

  void changeType(String? value) {
    final normalizedType = _normalizeText(value);

    if (normalizedType == null) {
      return;
    }

    selectedType = normalizedType;
    notifyListeners();
  }

  void changeQuantity(int? value) {
    if (value == null || value <= 0) {
      return;
    }

    selectedQuantity = value;
    notifyListeners();
  }

  void changeExpirationDate(DateTime value) {
    selectedExpirationDate = DateTime(value.year, value.month, value.day);

    notifyListeners();
  }

  Future<AddManualItemResult> save() async {
    if (isSaving) {
      return const AddManualItemResult.failure(
        'Já existe um salvamento em andamento.',
      );
    }

    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return const AddManualItemResult.failure(
        'Faça login para adicionar itens à despensa.',
      );
    }

    final name = nameController.text.trim();

    if (name.isEmpty) {
      return const AddManualItemResult.failure('Informe o nome do item.');
    }

    final expiresAt = selectedExpirationDate;

    if (expiresAt == null) {
      return const AddManualItemResult.failure(
        'Informe a data de validade do item.',
      );
    }

    isSaving = true;
    notifyListeners();

    try {
      return await addItemFirestoreService.addManualItem(
        userId: user.uid,
        name: name,
        quantity: selectedQuantity,
        expiresAt: expiresAt,
        category: selectedCategory,
        type: selectedType,
        barcode: barcode,
      );
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  static List<String> _buildCategoryOptions(String? initialCategory) {
    final normalizedCategory = _normalizeText(initialCategory);

    if (normalizedCategory == null) {
      return _defaultCategoryOptions;
    }

    if (_defaultCategoryOptions.contains(normalizedCategory)) {
      return _defaultCategoryOptions;
    }

    return [normalizedCategory, ..._defaultCategoryOptions];
  }

  static String? _normalizeText(String? value) {
    if (value == null) {
      return null;
    }

    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
