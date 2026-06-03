import 'package:cloud_firestore/cloud_firestore.dart';

final class PantryFirestoreItem {
  const PantryFirestoreItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.barcode,
    this.productId,
    this.category,
    this.imageUrl,
    this.status,
    this.expiresAt,
    this.createdAt,
  });

  final String id;
  final String name;
  final int quantity;
  final String? barcode;
  final String? productId;
  final String? category;
  final String? imageUrl;
  final String? status;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  factory PantryFirestoreItem.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    return PantryFirestoreItem(
      id: document.id,
      name: _readString(data['name']) ?? 'Produto sem nome',
      quantity: _readInt(data['quantity']),
      barcode: _readString(data['barcode']),
      productId: _readString(data['productId']),
      category: _readString(data['category']),
      imageUrl: _readString(data['imageUrl']),
      status: _readString(data['status']),
      expiresAt: _readDateTime(data['expiresAt']),
      createdAt: _readDateTime(data['createdAt']),
    );
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

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}

final class PantryExpirationSummary {
  const PantryExpirationSummary({
    required this.expiredQuantity,
    required this.expiringSoonQuantity,
  });

  final int expiredQuantity;
  final int expiringSoonQuantity;
}

extension PantryFirestoreItemsSummary on List<PantryFirestoreItem> {
  int get totalQuantity {
    return fold<int>(0, (total, item) => total + item.quantity);
  }

  PantryExpirationSummary expirationSummary({
    int expiringSoonDays = 7,
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final limitDate = today.add(Duration(days: expiringSoonDays));

    var expiredQuantity = 0;
    var expiringSoonQuantity = 0;

    for (final item in this) {
      final expiresAt = item.expiresAt;

      if (expiresAt == null) {
        continue;
      }

      final expirationDate = _dateOnly(expiresAt);

      if (expirationDate.isBefore(today)) {
        expiredQuantity += item.quantity;
        continue;
      }

      if (!expirationDate.isAfter(limitDate)) {
        expiringSoonQuantity += item.quantity;
      }
    }

    return PantryExpirationSummary(
      expiredQuantity: expiredQuantity,
      expiringSoonQuantity: expiringSoonQuantity,
    );
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

final class PantryFirestoreService {
  PantryFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<PantryFirestoreItem>> watchUserItems({required String userId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('items')
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs
              .map(PantryFirestoreItem.fromFirestore)
              .where((item) => item.status == null || item.status == 'active')
              .toList();

          items.sort((first, second) {
            final firstDate = first.createdAt;
            final secondDate = second.createdAt;

            if (firstDate == null && secondDate == null) {
              return 0;
            }

            if (firstDate == null) {
              return 1;
            }

            if (secondDate == null) {
              return -1;
            }

            return secondDate.compareTo(firstDate);
          });

          return items;
        });
  }
}
