import 'package:flutter/material.dart';

class SettingsPreferenceTile extends StatelessWidget {
  const SettingsPreferenceTile({
    super.key,
    required this.title,
    this.value,
    this.switchValue,
    this.onSwitchChanged,
  });

  final String title;
  final String? value;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  static const Color _cardColor = Color(0xFFDBE2E8);

  bool get _hasSwitch => switchValue != null && onSwitchChanged != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1,
              ),
            ),
          ),
          if (_hasSwitch)
            _SettingsSwitch(
              value: switchValue!,
              onChanged: onSwitchChanged!,
            )
          else
            Text(
              value ?? '',
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
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const Color _activeColor = Color(0xFF9BC23A);
  static const Color _inactiveColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 57,
        height: 34,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? _activeColor : _inactiveColor,
          borderRadius: BorderRadius.circular(17),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}