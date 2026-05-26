import 'package:flutter/material.dart';

import '../widgets/auth_gradient_scaffold.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/kippo_logo.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  static const double _designWidth = 393;
  static const double _designHeight = 852;

  @override
  Widget build(BuildContext context) {
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
                  child: KippoLogo(
                    width: w(215),
                    height: h(95),
                  ),
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
                  text: 'Entrar',
                  height: h(49),
                  borderRadius: w(9),
                  fontSize: w(17),
                  onPressed: () {},
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
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
                  text: 'Entrar com o Google',
                  height: h(49),
                  borderRadius: w(9),
                  fontSize: w(17),
                  onPressed: () {},
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