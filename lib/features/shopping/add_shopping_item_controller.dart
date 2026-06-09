import 'package:flutter/material.dart';

import 'data/shopping_store.dart';

enum AddShoppingItemResultStatus {
  successClose,
  successMessage,
  failure,
  ignored,
}

class AddShoppingItemResult {
  const AddShoppingItemResult._({required this.status, this.message});

  final AddShoppingItemResultStatus status;
  final String? message;

  const AddShoppingItemResult.successClose()
    : this._(status: AddShoppingItemResultStatus.successClose);

  const AddShoppingItemResult.successMessage(String message)
    : this._(
        status: AddShoppingItemResultStatus.successMessage,
        message: message,
      );

  const AddShoppingItemResult.failure(String message)
    : this._(status: AddShoppingItemResultStatus.failure, message: message);

  const AddShoppingItemResult.ignored()
    : this._(status: AddShoppingItemResultStatus.ignored);
}

class AddShoppingItemController extends ChangeNotifier {
  final TextEditingController itemNameController = TextEditingController();

  late final Future<List<ShoppingSuggestion>> pantrySuggestionsFuture =
      ShoppingStore.pantrySuggestions();

  bool _isSaving = false;

  bool get isSaving => _isSaving;

  Future<AddShoppingItemResult> saveTypedItem() async {
    if (_isSaving) {
      return const AddShoppingItemResult.ignored();
    }

    final String name = itemNameController.text.trim();

    if (name.isEmpty) {
      return const AddShoppingItemResult.failure('Informe o nome do item.');
    }

    return _runSavingAction(
      action: () async {
        await ShoppingStore.add(name);

        return const AddShoppingItemResult.successClose();
      },
      defaultErrorMessage: 'Não foi possível adicionar o item à lista.',
    );
  }

  Future<AddShoppingItemResult> addSuggestion(String name) async {
    if (_isSaving) {
      return const AddShoppingItemResult.ignored();
    }

    final String normalizedName = name.trim();

    if (normalizedName.isEmpty) {
      return const AddShoppingItemResult.failure('Item inválido.');
    }

    return _runSavingAction(
      action: () async {
        await ShoppingStore.add(normalizedName);

        return AddShoppingItemResult.successMessage(
          '"$normalizedName" adicionado à lista.',
        );
      },
      defaultErrorMessage: 'Não foi possível adicionar a sugestão à lista.',
    );
  }

  Future<AddShoppingItemResult> _runSavingAction({
    required Future<AddShoppingItemResult> Function() action,
    required String defaultErrorMessage,
  }) async {
    _setSaving(true);

    try {
      return await action();
    } catch (_) {
      return AddShoppingItemResult.failure(defaultErrorMessage);
    } finally {
      _setSaving(false);
    }
  }

  void _setSaving(bool value) {
    if (_isSaving == value) {
      return;
    }

    _isSaving = value;
    notifyListeners();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    super.dispose();
  }
}
