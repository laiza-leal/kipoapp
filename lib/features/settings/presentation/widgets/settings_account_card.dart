import 'package:flutter/material.dart';

import '../../domain/entities/user_profile.dart';

class SettingsAccountCard extends StatelessWidget {
  const SettingsAccountCard({
    super.key,
    required this.profile,
    required this.passwordDisplay,
    required this.onEditPressed,
  });

  final UserProfile profile;
  final String passwordDisplay;
  final VoidCallback onEditPressed;

  static const Color _cardColor = Color(0xFFDBE2E8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 149,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 22,
              right: 74,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.email,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Senha',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  passwordDisplay,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 21,
            right: 20,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onEditPressed,
              child: const SizedBox(
                width: 34,
                height: 34,
                child: _EditIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon();

  static const Color _editColor = Color(0xFF121A33);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 2,
          bottom: 2,
          child: Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              border: Border.all(
                color: _editColor,
                width: 2.6,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const Positioned(
          right: 0,
          top: 0,
          child: Icon(
            Icons.edit,
            size: 27,
            color: _editColor,
          ),
        ),
      ],
    );
  }
}