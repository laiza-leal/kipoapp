import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SettingsUserPreferences {
  const SettingsUserPreferences({
    required this.isLightTheme,
    required this.languageCode,
    required this.measurementUnit,
  });

  const SettingsUserPreferences.defaults()
    : isLightTheme = true,
      languageCode = 'PT-BR',
      measurementUnit = 'SI';

  final bool isLightTheme;
  final String languageCode;
  final String measurementUnit;

  SettingsUserPreferences copyWith({
    bool? isLightTheme,
    String? languageCode,
    String? measurementUnit,
  }) {
    return SettingsUserPreferences(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      languageCode: languageCode ?? this.languageCode,
      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLightTheme': isLightTheme,
      'languageCode': languageCode,
      'measurementUnit': measurementUnit,
    };
  }

  factory SettingsUserPreferences.fromMap(Object? value) {
    if (value is! Map<String, dynamic>) {
      return const SettingsUserPreferences.defaults();
    }

    return SettingsUserPreferences(
      isLightTheme: value['isLightTheme'] is bool
          ? value['isLightTheme'] as bool
          : true,
      languageCode: _readString(value['languageCode'], fallback: 'PT-BR'),
      measurementUnit: _readString(value['measurementUnit'], fallback: 'SI'),
    );
  }

  static String _readString(Object? value, {required String fallback}) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return fallback;
    }

    return text;
  }
}

class SettingsUserProfile {
  const SettingsUserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.preferences,
  });

  final String id;
  final String name;
  final String email;
  final SettingsUserPreferences preferences;

  String get initial {
    final normalizedName = name.trim();

    if (normalizedName.isNotEmpty) {
      return String.fromCharCode(normalizedName.runes.first).toUpperCase();
    }

    final normalizedEmail = email.trim();

    if (normalizedEmail.isNotEmpty) {
      return String.fromCharCode(normalizedEmail.runes.first).toUpperCase();
    }

    return '?';
  }

  factory SettingsUserProfile.fromFirebaseUser(User user) {
    final displayName = user.displayName?.trim();
    final email = user.email?.trim() ?? '';

    return SettingsUserProfile(
      id: user.uid,
      name: displayName != null && displayName.isNotEmpty
          ? displayName
          : _fallbackNameFromEmail(email),
      email: email,
      preferences: const SettingsUserPreferences.defaults(),
    );
  }

  factory SettingsUserProfile.fromFirestore({
    required User user,
    required Map<String, dynamic>? data,
  }) {
    if (data == null) {
      return SettingsUserProfile.fromFirebaseUser(user);
    }

    final authEmail = user.email?.trim() ?? '';

    return SettingsUserProfile(
      id: _readString(data['id']) ?? user.uid,
      name:
          _readString(data['name']) ??
          _readString(user.displayName) ??
          _fallbackNameFromEmail(authEmail),
      email: _readString(data['email']) ?? authEmail,
      preferences: SettingsUserPreferences.fromMap(data['preferences']),
    );
  }

  static String? _readString(Object? value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static String _fallbackNameFromEmail(String email) {
    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      return 'Usuário';
    }

    return normalizedEmail.split('@').first;
  }
}

class SettingsDependent {
  const SettingsDependent({
    required this.id,
    required this.name,
    required this.avatarColorValue,
    this.email,
    this.relationship,
  });

  final String id;
  final String name;
  final String? email;
  final String? relationship;
  final int avatarColorValue;

  String get initial {
    final normalizedName = name.trim();

    if (normalizedName.isEmpty) {
      return '?';
    }

    return String.fromCharCode(normalizedName.runes.first).toUpperCase();
  }

  factory SettingsDependent.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return SettingsDependent(
      id: _readString(data['id']) ?? id,
      name: _readString(data['name']) ?? 'Dependente',
      email: _readString(data['email']),
      relationship: _readString(data['relationship']),
      avatarColorValue: _readInt(data['avatarColorValue']) ?? 0xFF8A8A8A,
    );
  }

  static String? _readString(Object? value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}

class AddDependentInput {
  const AddDependentInput({required this.name, this.email, this.relationship});

  final String name;
  final String? email;
  final String? relationship;
}

class SettingsStore {
  const SettingsStore._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _usersCollection = 'users';
  static const String _dependentsCollection = 'dependents';

  static User? get currentUser => _auth.currentUser;

  static Stream<SettingsUserProfile> watchCurrentUserProfile() async* {
    final user = _auth.currentUser;

    if (user == null) {
      yield const SettingsUserProfile(
        id: '',
        name: 'Usuário',
        email: 'E-mail não informado',
        preferences: SettingsUserPreferences.defaults(),
      );
      return;
    }

    yield SettingsUserProfile.fromFirebaseUser(user);

    try {
      await ensureCurrentUserDocument();
    } on Object catch (error) {
      debugPrint('[SETTINGS] Falha ao garantir documento do usuário: $error');
    }

    yield* _userDocument(user.uid).snapshots().map((snapshot) {
      return SettingsUserProfile.fromFirestore(
        user: user,
        data: snapshot.data(),
      );
    });
  }

  static Stream<List<SettingsDependent>> watchCurrentUserDependents() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(const <SettingsDependent>[]);
    }

    return _userDocument(
      user.uid,
    ).collection(_dependentsCollection).snapshots().map((snapshot) {
      final dependents = snapshot.docs.map((document) {
        return SettingsDependent.fromFirestore(
          id: document.id,
          data: document.data(),
        );
      }).toList();

      dependents.sort((first, second) => first.name.compareTo(second.name));

      return dependents;
    });
  }

  static Future<void> ensureCurrentUserDocument() async {
    final user = _requireAuthenticatedUser();
    final userRef = _userDocument(user.uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final now = FieldValue.serverTimestamp();

      final authName = user.displayName?.trim();
      final authEmail = user.email?.trim() ?? '';

      if (!snapshot.exists) {
        transaction.set(userRef, {
          'id': user.uid,
          'name': authName != null && authName.isNotEmpty
              ? authName
              : _fallbackNameFromEmail(authEmail),
          'email': authEmail,
          'preferences': const SettingsUserPreferences.defaults().toMap(),
          'createdAt': now,
          'updatedAt': now,
        });

        return;
      }

      final data = snapshot.data() ?? <String, dynamic>{};
      final updates = <String, dynamic>{};

      final currentName = _readString(data['name']);
      final currentEmail = _readString(data['email']);

      if (currentName == null && authName != null && authName.isNotEmpty) {
        updates['name'] = authName;
      }

      if (currentEmail != authEmail) {
        updates['email'] = authEmail;
      }

      if (data['preferences'] is! Map<String, dynamic>) {
        updates['preferences'] = const SettingsUserPreferences.defaults()
            .toMap();
      }

      if (updates.isEmpty) {
        return;
      }

      updates['updatedAt'] = now;

      transaction.set(userRef, updates, SetOptions(merge: true));
    });
  }

  static Future<void> updateCurrentUserPreferences(
    SettingsUserPreferences preferences,
  ) async {
    final user = _requireAuthenticatedUser();

    await ensureCurrentUserDocument();

    await _userDocument(user.uid).set({
      'preferences': preferences.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> addCurrentUserDependent(AddDependentInput input) async {
    final user = _requireAuthenticatedUser();

    final name = input.name.trim();

    if (name.isEmpty) {
      throw ArgumentError('O nome do dependente não pode ficar vazio.');
    }

    await ensureCurrentUserDocument();

    final dependentRef = _userDocument(
      user.uid,
    ).collection(_dependentsCollection).doc();

    await dependentRef.set({
      'id': dependentRef.id,
      'name': name,
      'email': _normalizeOptionalText(input.email),
      'relationship': _normalizeOptionalText(input.relationship),
      'avatarColorValue': _avatarColorForText(name),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static DocumentReference<Map<String, dynamic>> _userDocument(String userId) {
    return _firestore.collection(_usersCollection).doc(userId);
  }

  static User _requireAuthenticatedUser() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Nenhum usuário autenticado.');
    }

    return user;
  }

  static String? _normalizeOptionalText(String? value) {
    final normalizedValue = value?.trim();

    if (normalizedValue == null || normalizedValue.isEmpty) {
      return null;
    }

    return normalizedValue;
  }

  static String? _readString(Object? value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static String _fallbackNameFromEmail(String email) {
    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      return 'Usuário';
    }

    return normalizedEmail.split('@').first;
  }

  static int _avatarColorForText(String text) {
    const colors = <int>[
      0xFF61A7D4,
      0xFFC9623B,
      0xFF759746,
      0xFF9C6ADE,
      0xFF28829F,
      0xFFDF5C4B,
    ];

    final hash = text.codeUnits.fold<int>(
      0,
      (previous, codeUnit) => previous + codeUnit,
    );

    return colors[hash % colors.length];
  }
}
