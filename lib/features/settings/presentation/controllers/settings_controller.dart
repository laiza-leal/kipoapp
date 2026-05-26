import 'package:flutter/foundation.dart';

import '../state/settings_state.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({
    SettingsState? initialState,
  }) : _state = initialState ?? SettingsState.mock();

  SettingsState _state;

  SettingsState get state => _state;

  void toggleLightTheme(bool value) {
    _state = _state.copyWith(
      isLightThemeEnabled: value,
    );

    notifyListeners();
  }

  void editProfile() {
    // TODO: integrar com tela/modal de edição de perfil.
    //
    // Futuramente, esse método deve chamar um caso de uso, por exemplo:
    // updateUserProfileUseCase(...)
    //
    // A UI não deve atualizar Firebase diretamente.
  }

  void addDependent() {
    // TODO: integrar com fluxo de convite/cadastro de dependente.
    //
    // Futuramente, esse método pode abrir uma tela de adicionar dependente
    // ou chamar um caso de uso responsável por gerar convite.
  }

  Future<void> signOut() async {
    // TODO: integrar com FirebaseAuth através de repository/use case.
    //
    // Exemplo futuro:
    // await signOutUseCase();
    //
    // Não colocar FirebaseAuth.instance.signOut() direto no widget.
  }

  Future<void> deleteAccount() async {
    // TODO: integrar com fluxo seguro de exclusão de conta.
    //
    // Em produção, esta ação deve:
    // 1. pedir confirmação;
    // 2. exigir reautenticação se necessário;
    // 3. remover/anonimizar dados conforme regra do app;
    // 4. excluir a conta via camada de aplicação.
  }
}