import '../../domain/entities/dependent.dart';
import '../../domain/entities/user_profile.dart';

enum SettingsStatus {
  initial,
  loading,
  ready,
  saving,
  failure,
}

class SettingsState {
  const SettingsState({
    required this.status,
    required this.profile,
    required this.dependents,
    required this.isLightThemeEnabled,
    required this.language,
    required this.measurementUnit,
    this.errorMessage,
  });

  final SettingsStatus status;
  final UserProfile profile;
  final List<Dependent> dependents;
  final bool isLightThemeEnabled;
  final String language;
  final String measurementUnit;
  final String? errorMessage;

  String get passwordDisplay {
    if (!profile.hasPassword) {
      return 'Não definida';
    }

    return '**************';
  }

  factory SettingsState.mock() {
    return const SettingsState(
      status: SettingsStatus.ready,
      profile: UserProfile(
        id: 'user_marta',
        name: 'Marta',
        email: 'marta@kipo.com',
        hasPassword: true,
      ),
      dependents: [
        Dependent(
          id: 'dependent_laura',
          name: 'Laura',
        ),
        Dependent(
          id: 'dependent_carlos',
          name: 'Carlos',
        ),
      ],
      isLightThemeEnabled: true,
      language: 'PT-BR',
      measurementUnit: 'SI',
    );
  }

  SettingsState copyWith({
    SettingsStatus? status,
    UserProfile? profile,
    List<Dependent>? dependents,
    bool? isLightThemeEnabled,
    String? language,
    String? measurementUnit,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      dependents: dependents ?? this.dependents,
      isLightThemeEnabled: isLightThemeEnabled ?? this.isLightThemeEnabled,
      language: language ?? this.language,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}