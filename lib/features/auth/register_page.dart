import 'package:flutter/material.dart';

import '../../widgets/auth/auth_gradient_scaffold.dart';
import '../../widgets/auth/auth_primary_button.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/kippo_logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

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
                top: h(62),
                left: 0,
                right: 0,
                child: Center(
                  child: KippoLogo(
                    width: w(118),
                    height: h(50),
                  ),
                ),
              ),

              Positioned(
                top: h(183),
                left: w(20),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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

              Positioned(
                top: h(239),
                left: w(28),
                right: w(28),
                child: AuthTextField(
                  hintText: 'Nome',
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
                  text: 'Criar Conta',
                  height: h(49),
                  borderRadius: w(9),
                  fontSize: w(16.5),
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