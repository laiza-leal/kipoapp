import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_user_model.dart'; // Este import garante que o serviço conheça os modelos

class SettingsFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<SettingsUserModel> streamUserSettings(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return SettingsUserModel.fromMap(uid, snapshot.data()!);
      }
      return SettingsUserModel(
        uid: uid,
        name: 'Usuário',
        email: '',
        isLightTheme: true,
        language: 'PT-BR',
        measurementUnit: 'SI',
      );
    });
  }

  Stream<List<DependentModel>> streamDependents(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('dependents')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DependentModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> updateSetting(String uid, String field, dynamic value) async {
    await _db.collection('users').doc(uid).update({field: value});
  }

  Future<void> addDependent(String uid, String name) async {
    await _db.collection('users').doc(uid).collection('dependents').add({
      'name': name,
    });
  }
}