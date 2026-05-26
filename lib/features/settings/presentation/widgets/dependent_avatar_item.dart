import 'package:flutter/material.dart';

class DependentAvatarItem extends StatelessWidget {
  const DependentAvatarItem({
    super.key,
    required this.label,
    required this.initial,
    required this.onTap,
    this.avatarColor,
    this.isAddAction = false,
  });

  final String label;
  final String initial;
  final Color? avatarColor;
  final bool isAddAction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AvatarCircle(
              initial: initial,
              avatarColor: avatarColor,
              isAddAction: isAddAction,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.initial,
    required this.avatarColor,
    required this.isAddAction,
  });

  final String initial;
  final Color? avatarColor;
  final bool isAddAction;

  @override
  Widget build(BuildContext context) {
    if (isAddAction) {
      return Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB7B7B7),
              Color(0xFF6F6F6F),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          '+',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 43,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 1,
          ),
        ),
      );
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: avatarColor ?? const Color(0xFF8A8A8A),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 26,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}