import 'package:firebase_auth/firebase_auth.dart';
// Certifique-se de importar o modelo e o serviço separadamente
import 'settings_user_model.dart';
import 'settings_firestore_service.dart';

class SettingsController {
  final SettingsFirestoreService _service = SettingsFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser?.uid ?? '';

  Stream<SettingsUserModel> get userSettingsStream => _service.streamUserSettings(currentUid);
  Stream<List<DependentModel>> get dependentsStream => _service.streamDependents(currentUid);

  void toggleTheme(bool value) {
    _service.updateSetting(currentUid, 'isLightTheme', value);
  }

  void updateLanguage(String lang) {
    _service.updateSetting(currentUid, 'language', lang);
  }

  void updateMeasurementUnit(String unit) {
    _service.updateSetting(currentUid, 'measurementUnit', unit);
  }

  void addNewDependent(String name) {
    if (name.isNotEmpty) {
      _service.addDependent(currentUid, name);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}