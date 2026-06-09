import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth/auth_gradient_scaffold.dart';
import '../../widgets/auth/auth_primary_button.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/kippo_logo.dart';
import 'login_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => LoginController(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  static const double _designWidth = 393;
  static const double _designHeight = 852;

  Future<void> _login(BuildContext context) async {
    final LoginController controller = context.read<LoginController>();

    final LoginResult result = await controller.loginWithEmailAndPassword();

    if (!context.mounted) {
      return;
    }

    _handleLoginResult(context, result);
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    final LoginController controller = context.read<LoginController>();

    final LoginResult result = await controller.loginWithGoogle();

    if (!context.mounted) {
      return;
    }

    _handleLoginResult(context, result);
  }

  void _handleLoginResult(BuildContext context, LoginResult result) {
    switch (result.status) {
      case LoginResultStatus.success:
        Navigator.of(context).pushReplacementNamed('/');
        return;

      case LoginResultStatus.failure:
        _showMessage(
          context,
          result.message ?? 'Não foi possível realizar o login.',
        );
        return;

      case LoginResultStatus.cancelled:
        return;

      case LoginResultStatus.ignored:
        return;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToRegisterPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    final LoginController controller = context.watch<LoginController>();

    return AuthGradientScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double scaleX = constraints.maxWidth / _designWidth;
          final double scaleY = constraints.maxHeight / _designHeight;

          double w(double value) => value * scaleX;
          double h(double value) => value * scaleY;

          return Stack(
            children: [
              Positioned(
                top: h(165),
                left: 0,
                right: 0,
                child: Center(
                  child: KippoLogo(width: w(215), height: h(95)),
                ),
              ),
              Positioned(
                top: h(360),
                left: 0,
                right: 0,
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w(24),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: h(416),
                left: w(20),
                right: w(20),
                child: AuthTextField(
                  hintText: 'Email',
                  controller: controller.emailController,
                  height: h(48),
                  borderRadius: w(9),
                  fontSize: w(16),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Positioned(
                top: h(480),
                left: w(20),
                right: w(20),
                child: AuthTextField(
                  hintText: 'Senha',
                  controller: controller.passwordController,
                  height: h(48),
                  borderRadius: w(9),
                  fontSize: w(16),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Positioned(
                top: h(544),
                left: w(21),
                right: w(21),
                child: AuthPrimaryButton(
                  text: controller.isLoading ? 'Entrando...' : 'Entrar',
                  height: h(49),
                  borderRadius: w(9),
                  fontSize: w(17),
                  onPressed: () => _login(context),
                ),
              ),
              Positioned(
                top: h(604),
                left: 0,
                right: 0,
                child: _LoginTextLinkRow(
                  normalText: 'Esqueceu sua senha? ',
                  linkText: 'Redefinir senha',
                  fontSize: w(14),
                  onTap: () {},
                ),
              ),
              Positioned(
                top: h(645),
                left: 0,
                right: 0,
                child: _LoginTextLinkRow(
                  normalText: 'Não possui conta? Faça seu ',
                  linkText: 'Cadastro',
                  fontSize: w(14),
                  onTap: () => _goToRegisterPage(context),
                ),
              ),
              Positioned(
                top: h(691),
                left: w(31),
                right: w(31),
                child: Container(
                  height: h(1),
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              Positioned(
                top: h(715),
                left: w(21),
                right: w(21),
                child: AuthPrimaryButton(
                  text: controller.isLoading
                      ? 'Aguarde...'
                      : 'Entrar com o Google',
                  height: h(49),
                  borderRadius: w(9),
                  fontSize: w(17),
                  onPressed: () => _loginWithGoogle(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LoginTextLinkRow extends StatelessWidget {
  const _LoginTextLinkRow({
    required this.normalText,
    required this.linkText,
    required this.fontSize,
    required this.onTap,
  });

  final String normalText;
  final String linkText;
  final double fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            normalText,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              linkText,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
