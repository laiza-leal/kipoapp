import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'barcode_validator.dart';

enum AddItemByBarcodeResultType {
  success,
  manualRegistrationRequired,
  invalidBarcode,
  networkError,
  firebaseError,
  unknownError,
}

final class AddItemByBarcodeResult {
  const AddItemByBarcodeResult._({
    required this.type,
    required this.message,
    this.barcode,
    this.productName,
    this.error,
  });

  const AddItemByBarcodeResult.success({
    required String barcode,
    required String productName,
  }) : this._(
         type: AddItemByBarcodeResultType.success,
         message: 'Item adicionado à despensa.',
         barcode: barcode,
         productName: productName,
       );

  const AddItemByBarcodeResult.manualRegistrationRequired({
    required String barcode,
  }) : this._(
         type: AddItemByBarcodeResultType.manualRegistrationRequired,
         message:
             'Produto não encontrado automaticamente. Continue pelo cadastro manual.',
         barcode: barcode,
       );

  const AddItemByBarcodeResult.invalidBarcode({
    required String message,
    String? barcode,
  }) : this._(
         type: AddItemByBarcodeResultType.invalidBarcode,
         message: message,
         barcode: barcode,
       );

  const AddItemByBarcodeResult.networkError({
    required String message,
    Object? error,
  }) : this._(
         type: AddItemByBarcodeResultType.networkError,
         message: message,
         error: error,
       );

  const AddItemByBarcodeResult.firebaseError({
    required String message,
    Object? error,
  }) : this._(
         type: AddItemByBarcodeResultType.firebaseError,
         message: message,
         error: error,
       );

  const AddItemByBarcodeResult.unknownError({
    required String message,
    Object? error,
  }) : this._(
         type: AddItemByBarcodeResultType.unknownError,
         message: message,
         error: error,
       );

  final AddItemByBarcodeResultType type;
  final String message;
  final String? barcode;
  final String? productName;
  final Object? error;

  bool get isSuccess => type == AddItemByBarcodeResultType.success;

  bool get needsManualRegistration {
    return type == AddItemByBarcodeResultType.manualRegistrationRequired;
  }
}

final class AddItemByBarcodeService {
  AddItemByBarcodeService({FirebaseFirestore? firestore, Dio? dio})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              sendTimeout: const Duration(seconds: 8),
              headers: const {
                'User-Agent': 'KipoApp/1.0 (ann.francielly@souunit.com.br)',
              },
            ),
          );

  final FirebaseFirestore _firestore;
  final Dio _dio;

  static const String _productsCollection = 'products';
  static const String _usersCollection = 'users';
  static const String _itemsCollection = 'items';

  bool _isProcessing = false;

  Future<AddItemByBarcodeResult> addFromBarcode({
    required String rawBarcode,
    required String userId,
    int quantity = 1,
  }) async {
    if (_isProcessing) {
      return const AddItemByBarcodeResult.unknownError(
        message: 'Já existe uma leitura em processamento.',
      );
    }

    _isProcessing = true;

    try {
      final validationResult = BarcodeValidator.validate(rawBarcode);

      if (!validationResult.isValid) {
        return AddItemByBarcodeResult.invalidBarcode(
          message:
              validationResult.errorMessage ?? 'Código de barras inválido.',
          barcode: validationResult.normalizedValue,
        );
      }

      final barcode = validationResult.normalizedValue;

      final productRef = _firestore
          .collection(_productsCollection)
          .doc(barcode);

      final productSnapshot = await productRef.get();

      late final Map<String, dynamic> productData;

      if (productSnapshot.exists) {
        final existingProductData = productSnapshot.data();

        if (existingProductData == null) {
          return const AddItemByBarcodeResult.firebaseError(
            message:
                'Produto encontrado no Firebase, mas os dados estão vazios.',
          );
        }

        productData = existingProductData;
      } else {
        final externalProductData = await _fetchProductFromOpenFoodFacts(
          barcode,
        );

        if (externalProductData == null) {
          return AddItemByBarcodeResult.manualRegistrationRequired(
            barcode: barcode,
          );
        }

        productData = externalProductData;
      }

      final productName = _readString(productData['name']) ?? 'Produto';

      await _saveProductAndCreateOrIncrementItem(
        barcode: barcode,
        userId: userId,
        quantity: quantity,
        productData: productData,
      );

      return AddItemByBarcodeResult.success(
        barcode: barcode,
        productName: productName,
      );
    } on FirebaseException catch (error) {
      return AddItemByBarcodeResult.firebaseError(
        message: 'Erro ao salvar ou consultar dados no Firebase.',
        error: error,
      );
    } on DioException catch (error) {
      return AddItemByBarcodeResult.networkError(
        message: 'Erro ao consultar a API externa de produtos.',
        error: error,
      );
    } on Object catch (error) {
      return AddItemByBarcodeResult.unknownError(
        message: 'Erro inesperado ao adicionar item por código de barras.',
        error: error,
      );
    } finally {
      _isProcessing = false;
    }
  }

  Future<Map<String, dynamic>?> _fetchProductFromOpenFoodFacts(
    String barcode,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://world.openfoodfacts.org/api/v3/product/$barcode.json',
      queryParameters: const {
        'fields': 'product_name,product_name_pt,brands,categories,image_url',
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data = response.data;

    if (data == null) {
      return null;
    }

    final product = data['product'];

    if (product is! Map<String, dynamic>) {
      return null;
    }

    final name =
        _readString(product['product_name_pt']) ??
        _readString(product['product_name']);

    if (name == null || name.trim().isEmpty) {
      return null;
    }

    final now = FieldValue.serverTimestamp();

    return {
      'id': barcode,
      'barcode': barcode,
      'name': name.trim(),
      'brand': _readString(product['brands']),
      'description': null,
      'imageUrl': _readString(product['image_url']),
      'category': _readString(product['categories']),
      'source': 'open_food_facts',
      'createdAt': now,
      'updatedAt': now,
    };
  }

  Future<void> _saveProductAndCreateOrIncrementItem({
    required String barcode,
    required String userId,
    required int quantity,
    required Map<String, dynamic> productData,
  }) async {
    final productRef = _firestore.collection(_productsCollection).doc(barcode);

    final itemRef = _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_itemsCollection)
        .doc(barcode);

    await _firestore.runTransaction((transaction) async {
      final productSnapshot = await transaction.get(productRef);
      final itemSnapshot = await transaction.get(itemRef);

      final productName = productSnapshot.exists
          ? _readString(productSnapshot.data()?['name']) ?? 'Produto'
          : _readString(productData['name']) ?? 'Produto';

      if (!productSnapshot.exists) {
        transaction.set(productRef, productData);
      } else {
        transaction.update(productRef, {
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      if (itemSnapshot.exists) {
        transaction.update(itemRef, {
          'quantity': FieldValue.increment(quantity),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return;
      }

      transaction.set(itemRef, {
        'id': barcode,
        'userId': userId,
        'productId': barcode,
        'barcode': barcode,
        'name': productName,
        'quantity': quantity,
        'status': 'active',
        'notes': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  String? _readString(Object? value) {
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
