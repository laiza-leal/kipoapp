import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/auth_domain.dart';

enum RegisterResultStatus { success, failure, ignored }

class RegisterResult {
  const RegisterResult._({required this.status, this.message});

  final RegisterResultStatus status;
  final String? message;

  const RegisterResult.success() : this._(status: RegisterResultStatus.success);

  const RegisterResult.failure(String message)
    : this._(status: RegisterResultStatus.failure, message: message);

  const RegisterResult.ignored() : this._(status: RegisterResultStatus.ignored);
}

class RegisterController extends ChangeNotifier {
  RegisterController({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<RegisterResult> register() async {
    if (_isLoading) {
      return const RegisterResult.ignored();
    }

    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;
    final String repeatPassword = repeatPasswordController.text;

    if (name.isEmpty) {
      return const RegisterResult.failure('Informe seu nome.');
    }

    if (email.isEmpty) {
      return const RegisterResult.failure('Informe seu email.');
    }

    if (password.isEmpty) {
      return const RegisterResult.failure('Informe sua senha.');
    }

    if (password != repeatPassword) {
      return const RegisterResult.failure('As senhas não são iguais.');
    }

    return _runRegisterAction(
      defaultErrorMessage: 'Não foi possível criar a conta.',
      action: () async {
        final UserCredential credential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        await credential.user?.updateDisplayName(name);

        final bool isAllowed = await isAllowedDomainOrSignOut();

        if (!isAllowed) {
          return const RegisterResult.failure(domainErrorMessage);
        }

        return const RegisterResult.success();
      },
    );
  }

  Future<RegisterResult> _runRegisterAction({
    required Future<RegisterResult> Function() action,
    required String defaultErrorMessage,
  }) async {
    _setLoading(true);

    try {
      return await action();
    } on FirebaseAuthException catch (exception) {
      return RegisterResult.failure(exception.message ?? defaultErrorMessage);
    } catch (_) {
      return RegisterResult.failure(defaultErrorMessage);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }
}
