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

  static Stream<QuerySnapshot<Map<String, dynamic>>> watchShopping() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('shopping')
        .snapshots();
  }

  static int shoppingCount(List<PantryDoc> docs) {
    return docs.length;
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
    var total = 0;
    for (final doc in docs) {
      if (_isExpiringSoon(doc)) total += _quantity(doc);
    }
    return total;
  }

  static List<String> expiringSoonNames(List<PantryDoc> docs) {
    final soon = docs.where(_isExpiringSoon).toList();
    soon.sort((a, b) => _expiresAt(a)!.compareTo(_expiresAt(b)!));
    return soon.map(_name).take(4).toList();
  }

  static bool _isExpiringSoon(PantryDoc doc) {
    final expiresAt = _expiresAt(doc);
    if (!_isActive(doc) || expiresAt == null) return false;
    final today = _today();
    final limit = today.add(const Duration(days: 7));
    return !expiresAt.isBefore(today) && !expiresAt.isAfter(limit);
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
    return (doc.data()['quantity']) ?? 0;
  }

  static DateTime? _expiresAt(PantryDoc doc) {
    final value = doc.data()['expiresAt'];
    if (value == null) return null;
    final date = value.toDate();
    return DateTime(date.year, date.month, date.day);
  }

  static String _name(PantryDoc doc) {
    return (doc.data()['name']) ?? 'Produto sem nome';
  }
}
