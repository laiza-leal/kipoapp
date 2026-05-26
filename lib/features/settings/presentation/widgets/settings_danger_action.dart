import 'package:flutter/material.dart';

class SettingsDangerAction extends StatelessWidget {
  const SettingsDangerAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const Color _dangerColor = Color(0xFFF15D4F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 29,
              color: _dangerColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _dangerColor,
                decoration: TextDecoration.underline,
                decorationColor: _dangerColor,
                decorationThickness: 1.3,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}