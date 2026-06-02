final class BarcodeValidationResult {
  const BarcodeValidationResult._({
    required this.normalizedValue,
    required this.isValid,
    this.errorMessage,
  });

  const BarcodeValidationResult.valid(String normalizedValue)
      : this._(
          normalizedValue: normalizedValue,
          isValid: true,
        );

  const BarcodeValidationResult.invalid({
    required String normalizedValue,
    required String errorMessage,
  }) : this._(
          normalizedValue: normalizedValue,
          isValid: false,
          errorMessage: errorMessage,
        );

  final String normalizedValue;
  final bool isValid;
  final String? errorMessage;
}

final class BarcodeValidator {
  const BarcodeValidator._();

  static const Set<int> _acceptedLengths = {8, 12, 13, 14};

  static BarcodeValidationResult validate(String rawValue) {
    final normalizedValue = rawValue.trim();

    if (normalizedValue.isEmpty) {
      return const BarcodeValidationResult.invalid(
        normalizedValue: '',
        errorMessage: 'Código de barras vazio.',
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(normalizedValue)) {
      return BarcodeValidationResult.invalid(
        normalizedValue: normalizedValue,
        errorMessage: 'O código de barras deve conter apenas números.',
      );
    }

    if (!_acceptedLengths.contains(normalizedValue.length)) {
      return BarcodeValidationResult.invalid(
        normalizedValue: normalizedValue,
        errorMessage:
            'Código com tamanho inválido. Use EAN/GTIN com 8, 12, 13 ou 14 dígitos.',
      );
    }

    if (!_hasValidCheckDigit(normalizedValue)) {
      return BarcodeValidationResult.invalid(
        normalizedValue: normalizedValue,
        errorMessage: 'O dígito verificador do código de barras é inválido.',
      );
    }

    return BarcodeValidationResult.valid(normalizedValue);
  }

  static bool _hasValidCheckDigit(String value) {
    final digits = value.split('').map(int.parse).toList();
    final informedCheckDigit = digits.removeLast();

    var sum = 0;
    var multiplier = 3;

    for (var index = digits.length - 1; index >= 0; index--) {
      sum += digits[index] * multiplier;
      multiplier = multiplier == 3 ? 1 : 3;
    }

    final expectedCheckDigit = (10 - (sum % 10)) % 10;

    return expectedCheckDigit == informedCheckDigit;
  }
}