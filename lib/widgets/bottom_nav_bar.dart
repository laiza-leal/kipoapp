import 'package:flutter/material.dart';

import '../core/theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: BottomAppBar(
        color: AppColors.cardGray,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        height: 70,
        child: const SizedBox.shrink(),
      ),
    );
  }
}
