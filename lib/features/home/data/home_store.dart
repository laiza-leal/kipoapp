import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef PantryDoc = QueryDocumentSnapshot<Map<String, dynamic>>;

class HomeStore {
  static Stream<QuerySnapshot<Map<String, dynamic>>> watchPantry() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .snapshots();
  }

  static int totalItems(List<PantryDoc> docs) {
    var total = 0;
    for (final doc in docs) {
      if (_isActive(doc)) total += _quantity(doc);
    }
    return total;
  }

  static int expiredCount(List<PantryDoc> docs) {
    final today = _today();
    var total = 0;
    for (final doc in docs) {
      final expiresAt = _expiresAt(doc);
      if (_isActive(doc) && expiresAt != null && expiresAt.isBefore(today)) {
        total += _quantity(doc);
      }
    }
    return total;
  }

  static int expiringSoonCount(List<PantryDoc> docs) {
    final today = _today();
    final limit = today.add(const Duration(days: 7));
    var total = 0;
    for (final doc in docs) {
      final expiresAt = _expiresAt(doc);
      if (_isActive(doc) &&
          expiresAt != null &&
          !expiresAt.isBefore(today) &&
          !expiresAt.isAfter(limit)) {
        total += _quantity(doc);
      }
    }
    return total;
  }

  static List<String> expiringSoonNames(List<PantryDoc> docs) {
    final today = _today();
    final limit = today.add(const Duration(days: 7));
    final soon = docs.where((doc) {
      final expiresAt = _expiresAt(doc);
      return _isActive(doc) &&
          expiresAt != null &&
          !expiresAt.isBefore(today) &&
          !expiresAt.isAfter(limit);
    }).toList();
    soon.sort((a, b) => _expiresAt(a)!.compareTo(_expiresAt(b)!));
    return soon.map(_name).take(4).toList();
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static bool _isActive(PantryDoc doc) {
    final status = doc.data()['status'];
    return status == null || status == 'active';
  }

  static int _quantity(PantryDoc doc) {
    final value = doc.data()['quantity'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _expiresAt(PantryDoc doc) {
    final value = doc.data()['expiresAt'];
    if (value is Timestamp) {
      final date = value.toDate();
      return DateTime(date.year, date.month, date.day);
    }
    return null;
  }

  static String _name(PantryDoc doc) {
    final value = doc.data()['name'];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return 'Produto sem nome';
  }
}
