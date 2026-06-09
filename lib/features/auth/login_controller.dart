import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/auth_domain.dart';

enum LoginResultStatus { success, failure, cancelled, ignored }

class LoginResult {
  const LoginResult._({required this.status, this.message});

  final LoginResultStatus status;
  final String? message;

  const LoginResult.success() : this._(status: LoginResultStatus.success);

  const LoginResult.failure(String message)
    : this._(status: LoginResultStatus.failure, message: message);

  const LoginResult.cancelled() : this._(status: LoginResultStatus.cancelled);

  const LoginResult.ignored() : this._(status: LoginResultStatus.ignored);
}

class LoginController extends ChangeNotifier {
  LoginController({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<LoginResult> loginWithEmailAndPassword() async {
    if (_isLoading) {
      return const LoginResult.ignored();
    }

    return _runLoginAction(
      defaultErrorMessage: 'Não foi possível entrar.',
      action: () async {
        final String email = emailController.text.trim();
        final String password = passwordController.text;

        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final bool isAllowed = await isAllowedDomainOrSignOut();

        if (!isAllowed) {
          return const LoginResult.failure(domainErrorMessage);
        }

        return const LoginResult.success();
      },
    );
  }

  Future<LoginResult> loginWithGoogle() async {
    if (_isLoading) {
      return const LoginResult.ignored();
    }

    return _runLoginAction(
      defaultErrorMessage: 'Não foi possível entrar com o Google.',
      action: () async {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return const LoginResult.cancelled();
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);

        final bool isAllowed = await isAllowedDomainOrSignOut();

        if (!isAllowed) {
          return const LoginResult.failure(domainErrorMessage);
        }

        return const LoginResult.success();
      },
    );
  }

  Future<LoginResult> _runLoginAction({
    required Future<LoginResult> Function() action,
    required String defaultErrorMessage,
  }) async {
    _setLoading(true);

    try {
      return await action();
    } on FirebaseAuthException catch (exception) {
      return LoginResult.failure(exception.message ?? defaultErrorMessage);
    } catch (_) {
      return LoginResult.failure(defaultErrorMessage);
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
