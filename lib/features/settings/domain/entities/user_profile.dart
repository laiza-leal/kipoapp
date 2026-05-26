class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.hasPassword,
  });

  final String id;
  final String name;
  final String email;
  final bool hasPassword;

  String get initial {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName[0].toUpperCase();
  }
}