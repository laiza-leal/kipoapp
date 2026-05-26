import 'package:flutter/material.dart';

import '../../domain/entities/dependent.dart';
import 'dependent_avatar_item.dart';

class DependentsSection extends StatelessWidget {
  const DependentsSection({
    super.key,
    required this.dependents,
    required this.onDependentTap,
    required this.onAddDependent,
  });

  final List<Dependent> dependents;
  final ValueChanged<Dependent> onDependentTap;
  final VoidCallback onAddDependent;

  static const Color _cardColor = Color(0xFFDBE2E8);

  static const List<Color> _dependentColors = [
    Color(0xFF61A7D4),
    Color(0xFFC9623B),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 138,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 24,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var index = 0; index < dependents.length; index++)
            DependentAvatarItem(
              label: dependents[index].name,
              initial: dependents[index].initial,
              avatarColor: _dependentColors[index % _dependentColors.length],
              onTap: () => onDependentTap(dependents[index]),
            ),
          DependentAvatarItem(
            label: 'Adicionar',
            initial: '+',
            isAddAction: true,
            onTap: onAddDependent,
          ),
        ],
      ),
    );
  }
}