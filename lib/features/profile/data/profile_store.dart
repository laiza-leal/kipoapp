import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsumerProfile {
  const ConsumerProfile({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.insight,
  });

  final String title;
  final String subtitle;
  final String image;
  final String rating;
  final String insight;
}

class ProfileStore {
  static Stream<QuerySnapshot<Map<String, dynamic>>> watchPantry() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .snapshots();
  }

  static int score(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final today = _today();
    var usedInTime = 0;
    var wasted = 0;

    for (final doc in docs) {
      final data = doc.data();
      if (data['status'] == 'used') {
        if (data['usedInTime'] == true) {
          usedInTime++;
        } else {
          wasted++;
        }
      } else {
        final expiresAt = _expiresAt(doc);
        if (expiresAt != null && expiresAt.isBefore(today)) {
          wasted++;
        }
      }
    }

    final total = usedInTime + wasted;
    if (total == 0) return 0;
    return ((usedInTime / total) * 100).round();
  }

  static ConsumerProfile profileFor(int score) {
    if (score >= 75) {
      return const ConsumerProfile(
        title: 'O Mestre do Aproveitamento',
        subtitle: 'Você aproveita quase tudo que compra',
        image: 'assets/images/consumption-profile-master.png',
        rating: 'Excelente',
        insight: 'Parabéns! Quase nada se perde na sua despensa.',
      );
    }
    if (score >= 50) {
      return const ConsumerProfile(
        title: 'O Planejador',
        subtitle: 'Você planeja bem suas compras',
        image: 'assets/images/consumption-profile-planner.png',
        rating: 'Bom',
        insight: 'Bom aproveitamento, mas ainda dá pra melhorar.',
      );
    }
    if (score >= 25) {
      return const ConsumerProfile(
        title: 'O Sobrevivente do Dia a Dia',
        subtitle: 'Você resolve no improviso, dia a dia',
        image: 'assets/images/consumption-profile-survivor.png',
        rating: 'Razoável',
        insight: 'Atenção: parte dos seus alimentos está se perdendo.',
      );
    }
    return const ConsumerProfile(
      title: 'O Consumista',
      subtitle: 'Você compra sem planejar',
      image: 'assets/images/consumption-profile-consumist.png',
      rating: 'Muito baixo',
      insight: 'Tente utilizar seus alimentos antes de estragarem.',
    );
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime? _expiresAt(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final value = doc.data()['expiresAt'];
    if (value is Timestamp) {
      final date = value.toDate();
      return DateTime(date.year, date.month, date.day);
    }
    return null;
  }
}
