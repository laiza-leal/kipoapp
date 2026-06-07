import 'package:flutter/material.dart';

class KippoLogo extends StatelessWidget {
  const KippoLogo({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  static const String assetPath = 'assets/images/kipo.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}