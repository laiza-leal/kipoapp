import 'package:cloud_firestore/cloud_firestore.dart';

final class AddManualItemResult {
  const AddManualItemResult._({
    required this.success,
    required this.message,
  });

  const AddManualItemResult.success()
      : this._(
          success: true,
          message: 'Item adicionado à despensa.',
        );

  const AddManualItemResult.failure(String message)
      : this._(
          success: false,
          message: message,
        );

  final bool success;
  final String message;
}

final class AddItemFirestoreService {
  AddItemFirestoreService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<AddManualItemResult> addManualItem({
    required String userId,
    required String name,
    required int quantity,
    required DateTime expiresAt,
    String? category,
    String? type,
    String? barcode,
  }) async {
    final normalizedName = name.trim();
    final normalizedBarcode = barcode?.trim();
    final normalizedExpirationDate = _normalizeDateOnly(expiresAt);
    final expirationDateKey = _buildDateKey(normalizedExpirationDate);

    if (normalizedName.isEmpty) {
      return const AddManualItemResult.failure(
        'Informe o nome do item.',
      );
    }

    if (quantity <= 0) {
      return const AddManualItemResult.failure(
        'Informe uma quantidade válida.',
      );
    }

    try {
      final now = FieldValue.serverTimestamp();

      final hasBarcode =
          normalizedBarcode != null && normalizedBarcode.isNotEmpty;

      final productRef = hasBarcode
          ? _firestore.collection('products').doc(normalizedBarcode)
          : _firestore.collection('products').doc();

      final productId = productRef.id;

      final itemId = '${productId}_$expirationDateKey';

      final itemRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .doc(itemId);

      await _firestore.runTransaction((transaction) async {
        final productSnapshot = await transaction.get(productRef);
        final itemSnapshot = await transaction.get(itemRef);

        if (!productSnapshot.exists) {
          transaction.set(productRef, {
            'id': productId,
            'barcode': hasBarcode ? normalizedBarcode : null,
            'name': normalizedName,
            'brand': null,
            'description': type,
            'imageUrl': null,
            'category': category,
            'source': hasBarcode ? 'barcode' : 'manual',
            'createdAt': now,
            'updatedAt': now,
          });
        } else {
          transaction.update(productRef, {
            'name': normalizedName,
            'category': category,
            'description': type,
            'updatedAt': now,
          });
        }

        if (itemSnapshot.exists) {
          transaction.update(itemRef, {
            'quantity': FieldValue.increment(quantity),
            'updatedAt': now,
          });

          return;
        }

        transaction.set(itemRef, {
          'id': itemId,
          'userId': userId,
          'productId': productId,
          'barcode': hasBarcode ? normalizedBarcode : null,
          'name': normalizedName,
          'quantity': quantity,
          'category': category,
          'type': type,
          'expiresAt': Timestamp.fromDate(normalizedExpirationDate),
          'expirationDateKey': expirationDateKey,
          'status': 'active',
          'notes': null,
          'createdAt': now,
          'updatedAt': now,
        });
      });

      return const AddManualItemResult.success();
    } on FirebaseException catch (error) {
      return AddManualItemResult.failure(
        'Erro ao salvar no Firebase: ${error.message ?? error.code}',
      );
    } on Object catch (_) {
      return const AddManualItemResult.failure(
        'Erro inesperado ao adicionar item.',
      );
    }
  }

  DateTime _normalizeDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _buildDateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year$month$day';
  }
}