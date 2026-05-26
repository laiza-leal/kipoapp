class Dependent {
  const Dependent({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  String get initial {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    return trimmedName[0].toUpperCase();
  }
}