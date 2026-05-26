import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = '/settings';

  static const Color _pageBackgroundColor = Color(0xFFEEEEEE);

  double _spacing({
    required bool isCompactHeight,
    required double regular,
    required double compact,
  }) {
    return isCompactHeight ? compact : regular;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompactHeight = constraints.maxHeight < 850;
            final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

            final horizontalPadding = constraints.maxWidth <= 360 ? 16.0 : 17.0;
            final rightPadding = constraints.maxWidth <= 360 ? 16.0 : 23.0;

            final topPadding = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 48,
              compact: 28,
            );

            final headerToProfileSpacing = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 32,
              compact: 22,
            );

            final profileToDependentsSpacing = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 21,
              compact: 14,
            );

            final sectionSpacing = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 21,
              compact: 16,
            );

            final preferenceSpacing = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 20,
              compact: 12,
            );

            final dangerTopSpacing = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 31,
              compact: 22,
            );

            final dangerActionSpacing = _spacing(
              isCompactHeight: isCompactHeight,
              regular: 45,
              compact: 26,
            );

            return Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: rightPadding,
                  top: topPadding,
                  bottom: bottomSafeArea + 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsHeader(
                      onBackPressed: () => Navigator.of(context).maybePop(),
                    ),
                    SizedBox(height: headerToProfileSpacing),
                    const Center(
                      child: _ProfileSummary(
                        initial: 'M',
                        name: 'Marta',
                      ),
                    ),
                    SizedBox(height: profileToDependentsSpacing),
                    const Text(
                      'Dependentes',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 13),
                    const _DependentsSection(),
                    SizedBox(height: sectionSpacing),
                    const _AccountCard(
                      email: 'marta@kipo.com',
                      passwordDisplay: '**************',
                    ),
                    SizedBox(height: sectionSpacing),
                    const _PreferenceTile(
                      title: 'Tema claro',
                      switchValue: true,
                    ),
                    SizedBox(height: preferenceSpacing),
                    const _PreferenceTile(
                      title: 'Idioma',
                      value: 'PT-BR',
                    ),
                    SizedBox(height: preferenceSpacing),
                    const _PreferenceTile(
                      title: 'Unidade de medida',
                      value: 'SI',
                    ),
                    SizedBox(height: dangerTopSpacing),
                    const Padding(
                      padding: EdgeInsets.only(left: 21),
                      child: _DangerAction(
                        icon: Icons.logout,
                        label: 'Sair da conta',
                      ),
                    ),
                    SizedBox(height: dangerActionSpacing),
                    Padding(
                      padding: const EdgeInsets.only(left: 21),
                      child: _DangerAction(
                        icon: Icons.cancel_outlined,
                        label: 'Excluir conta',
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir conta'),
          content: const Text(
            'Tem certeza que deseja excluir sua conta? Esta ação não poderá ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Excluir',
                style: TextStyle(
                  color: Color(0xFFF15D4F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBackPressed,
              child: const SizedBox(
                width: 42,
                height: 38,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back,
                    size: 31,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Configurações',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({
    required this.initial,
    required this.name,
  });

  final String initial;
  final String name;

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
            initial,
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
          name,
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

class _DependentsSection extends StatelessWidget {
  const _DependentsSection();

  static const Color _cardColor = Color(0xFFDBE2E8);

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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DependentAvatarItem(
            label: 'Laura',
            initial: 'L',
            avatarColor: Color(0xFF61A7D4),
          ),
          _DependentAvatarItem(
            label: 'Carlos',
            initial: 'C',
            avatarColor: Color(0xFFC9623B),
          ),
          _DependentAvatarItem(
            label: 'Adicionar',
            initial: '+',
            isAddAction: true,
          ),
        ],
      ),
    );
  }
}

class _DependentAvatarItem extends StatelessWidget {
  const _DependentAvatarItem({
    required this.label,
    required this.initial,
    this.avatarColor,
    this.isAddAction = false,
  });

  final String label;
  final String initial;
  final Color? avatarColor;
  final bool isAddAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
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

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.email,
    required this.passwordDisplay,
  });

  final String email;
  final String passwordDisplay;

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
                  email,
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
          const Positioned(
            top: 21,
            right: 20,
            child: SizedBox(
              width: 34,
              height: 34,
              child: _EditIcon(),
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

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.title,
    this.value,
    this.switchValue,
  });

  final String title;
  final String? value;
  final bool? switchValue;

  static const Color _cardColor = Color(0xFFDBE2E8);

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
          if (switchValue != null)
            _SettingsSwitch(value: switchValue!)
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
  const _SettingsSwitch({required this.value});

  final bool value;

  static const Color _activeColor = Color(0xFF9BC23A);
  static const Color _inactiveColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _DangerAction extends StatelessWidget {
  const _DangerAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

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
