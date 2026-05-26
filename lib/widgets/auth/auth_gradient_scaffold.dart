import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthGradientScaffold extends StatelessWidget {
  const AuthGradientScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  static const Color topColor = Color(0xFF44809C);
  static const Color middleColor = Color(0xFF5C9584);
  static const Color bottomColor = Color(0xFFA1C94A);

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: _AuthGradientBody(),
    );
  }
}

class _AuthGradientBody extends StatelessWidget {
  const _AuthGradientBody();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<AuthGradientScaffold>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AuthGradientScaffold.topColor,
              AuthGradientScaffold.middleColor,
              AuthGradientScaffold.bottomColor,
            ],
            stops: [
              0.0,
              0.46,
              1.0,
            ],
          ),
        ),
        child: parent!.child,
      ),
    );
  }
}