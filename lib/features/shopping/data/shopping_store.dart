import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../pantry/pantry_firestore_service.dart';

class ShoppingStore {
  static CollectionReference<Map<String, dynamic>> _items() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('shopping');
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> watch() {
    return _items().orderBy('createdAt').snapshots();
  }

  static Future<void> add(String name) {
    final email = FirebaseAuth.instance.currentUser!.email;
    return _items().add({
      'name': name,
      'checked': false,
      'criado_por': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> toggle(String id, bool checked) {
    return _items().doc(id).update({'checked': !checked});
  }

  static Future<void> remove(String id) {
    return _items().doc(id).delete();
  }

  static Future<void> clearAll() async {
    final snapshot = await _items().get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Sugestões: itens da despensa que venceram, estão perto de vencer
  // (7 dias) ou acabaram (quantidade 0).
  static Future<List<ShoppingSuggestion>> pantrySuggestions() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .get();

    final hoje = DateTime.now();
    final hojeSoData = DateTime(hoje.year, hoje.month, hoje.day);
    final limite = hojeSoData.add(const Duration(days: 7));

    final sugestoes = <ShoppingSuggestion>[];
    for (final doc in snapshot.docs) {
      final item = PantryFirestoreItem.fromFirestore(doc);
      final validade = item.expiresAt;

      String? motivo;
      if (item.quantity <= 0) {
        motivo = 'Acabou';
      } else if (validade != null && validade.isBefore(hojeSoData)) {
        motivo = 'Vencido';
      } else if (validade != null && !validade.isAfter(limite)) {
        motivo = 'Vence em breve';
      }

      if (motivo != null) {
        sugestoes.add(ShoppingSuggestion(name: item.name, reason: motivo));
      }
    }
    return sugestoes;
  }
}

class ShoppingSuggestion {
  ShoppingSuggestion({required this.name, required this.reason});

  final String name;
  final String reason;
}
