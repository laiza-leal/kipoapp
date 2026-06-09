import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth/auth_gradient_scaffold.dart';
import '../../widgets/auth/auth_primary_button.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/kippo_logo.dart';
import 'register_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterController>(
      create: (_) => RegisterController(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  static const double _designWidth = 393;
  static const double _designHeight = 852;

  Future<void> _register(BuildContext context) async {
    final RegisterController controller = context.read<RegisterController>();

    final RegisterResult result = await controller.register();

    if (!context.mounted) {
      return;
    }

    _handleRegisterResult(context, result);
  }

  void _handleRegisterResult(BuildContext context, RegisterResult result) {
    switch (result.status) {
      case RegisterResultStatus.success:
        Navigator.of(context).pushReplacementNamed('/');
        return;

      case RegisterResultStatus.failure:
        _showMessage(
          context,
          result.message ?? 'Não foi possível criar a conta.',
        );
        return;

      case RegisterResultStatus.ignored:
        return;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = context.watch<RegisterController>();

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
                top: h(62),
                left: 0,
                right: 0,
                child: Center(
                  child: KippoLogo(width: w(118), height: h(50)),
                ),
              ),

              Positioned(
                top: h(183),
                left: w(20),
                child: IconButton(
                  onPressed: () => _goBack(context),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: w(44),
                    minHeight: h(44),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF020923),
                    size: w(29),
                  ),
                ),
              ),

              Positioned(
                top: h(184),
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Text(
                    'Cadastro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF020923),
                      fontSize: w(24),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: h(239),
                left: w(28),
                right: w(28),
                child: AuthTextField(
                  hintText: 'Nome',
                  controller: controller.nameController,
                  height: h(49),
                  borderRadius: w(10),
                  fontSize: w(15.5),
                  textInputAction: TextInputAction.next,
                ),
              ),

              Positioned(
                top: h(304),
                left: w(28),
                right: w(28),
                child: AuthTextField(
                  hintText: 'Email',
                  controller: controller.emailController,
                  height: h(49),
                  borderRadius: w(10),
                  fontSize: w(15.5),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),

              Positioned(
                top: h(368),
                left: w(28),
                right: w(28),
                child: AuthTextField(
                  hintText: 'Senha',
                  controller: controller.passwordController,
                  height: h(49),
                  borderRadius: w(10),
                  fontSize: w(15.5),
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
              ),

              Positioned(
                top: h(433),
                left: w(28),
                right: w(28),
                child: AuthTextField(
                  hintText: 'Repetir senha',
                  controller: controller.repeatPasswordController,
                  height: h(49),
                  borderRadius: w(10),
                  fontSize: w(15.5),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
              ),

              Positioned(
                top: h(506),
                left: w(28),
                right: w(28),
                child: AuthPrimaryButton(
                  text: controller.isLoading
                      ? 'Criando conta...'
                      : 'Criar Conta',
                  height: h(49),
                  borderRadius: w(9),
                  fontSize: w(16.5),
                  onPressed: () => _register(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
