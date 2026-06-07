class SettingsUserModel {
  final String uid;
  final String name;
  final String email;
  final bool isLightTheme;
  final String language;
  final String measurementUnit;

  SettingsUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.isLightTheme,
    required this.language,
    required this.measurementUnit,
  });

  // Converte o JSON do Firestore para o modelo Dart
  factory SettingsUserModel.fromMap(String uid, Map<String, dynamic> map) {
    return SettingsUserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isLightTheme: map['isLightTheme'] ?? true,
      language: map['language'] ?? 'PT-BR',
      measurementUnit: map['measurementUnit'] ?? 'SI',
    );
  }

  // Converte o modelo Dart para JSON antes de salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isLightTheme': isLightTheme,
      'language': language,
      'measurementUnit': measurementUnit,
    };
  }
}

class DependentModel {
  final String id;
  final String name;

  DependentModel({required this.id, required this.name});

  factory DependentModel.fromMap(String id, Map<String, dynamic> map) {
    return DependentModel(
      id: id,
      name: map['name'] ?? '',
    );
  }
}