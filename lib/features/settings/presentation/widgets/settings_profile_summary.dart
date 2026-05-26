import 'package:flutter/material.dart';

import '../../domain/entities/user_profile.dart';

class SettingsProfileSummary extends StatelessWidget {
  const SettingsProfileSummary({
    super.key,
    required this.profile,
  });

  final UserProfile profile;

  static const Color _avatarColor = Color(0xFF759746);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 61,
          height: 61,
          decoration: const BoxDecoration(
            color: _avatarColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            profile.initial,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 31,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile.name,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            height: 1,
          ),
        ),
      ],
    );
  }
}