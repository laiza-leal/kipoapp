import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_page.dart';
// Importações das camadas de dados que criamos nas devidas pastas
import 'settings_controller.dart';
import 'settings_user_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = '/settings';

  static const Color _pageBackgroundColor = Color(0xFFEEEEEE);

  // Instancia estável do controlador reativo para a página stateless
  static final SettingsController _controller = SettingsController();

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

            // Escuta as configurações do usuário no Firestore em tempo real
            return StreamBuilder<SettingsUserModel>(
              stream: _controller.userSettingsStream,
              builder: (context, userSnapshot) {
                final userData = userSnapshot.data;
                final name = userData?.name ?? 'Marta';
                final email = userData?.email ?? 'marta@kipo.com';
                final isLightTheme = userData?.isLightTheme ?? true;
                final language = userData?.language ?? 'PT-BR';
                final measurementUnit = userData?.measurementUnit ?? 'SI';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : 'M';

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
                        Center(
                          child: _ProfileSummary(
                            initial: initial,
                            name: name,
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
                        
                        // Passamos a stream e a ação de clique para a seção de dependentes
                        _DependentsSection(
                          dependentsStream: _controller.dependentsStream,
                          onAddTap: () => _showAddDependentDialog(context),
                        ),
                        
                        SizedBox(height: sectionSpacing),
                        _AccountCard(
                          email: email,
                          passwordDisplay: '**************',
                        ),
                        SizedBox(height: sectionSpacing),
                        _PreferenceTile(
                          title: 'Tema claro',
                          switchValue: isLightTheme,
                          onChanged: (value) => _controller.toggleTheme(value),
                        ),
                        SizedBox(height: preferenceSpacing),
                        _PreferenceTile(
                          title: 'Idioma',
                          value: language,
                          onTap: () {
                            _controller.updateLanguage(language == 'PT-BR' ? 'EN-US' : 'PT-BR');
                          },
                        ),
                        SizedBox(height: preferenceSpacing),
                        _PreferenceTile(
                          title: 'Unidade de medida',
                          value: measurementUnit,
                          onTap: () {
                            _controller.updateMeasurementUnit(measurementUnit == 'SI' ? 'Imperial' : 'SI');
                          },
                        ),
                        SizedBox(height: dangerTopSpacing),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: _DangerAction(
                            icon: Icons.logout,
                            label: 'Sair da conta',
                            onTap: () => _logout(context),
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
              }
            );
          },
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await _controller.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginPage.routeName,
      (route) => false,
    );
  }

  void _showAddDependentDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Dependente'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Nome do dependente"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  _controller.addNewDependent(textController.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
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
  final Stream<List<DependentModel>> dependentsStream;
  final VoidCallback onAddTap;

  const _DependentsSection({
    required this.dependentsStream,
    required this.onAddTap,
  });

  static const Color _cardColor = Color(0xFFDBE2E8);

  static const List<Color> _avatarColors = [
    Color(0xFF61A7D4),
    Color(0xFFC9623B),
    Color(0xFF759746),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: StreamBuilder<List<DependentModel>>(
        stream: dependentsStream,
        builder: (context, snapshot) {
          final dependents = snapshot.data ?? [];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: dependents.length + 1,
            itemBuilder: (context, index) {
              if (index == dependents.length) {
                return GestureDetector(
                  onTap: onAddTap,
                  child: const _DependentAvatarItem(
                    label: 'Adicionar',
                    initial: '+',
                    isAddAction: true,
                  ),
                );
              }

              final dep = dependents[index];
              final colorIndex = index % _avatarColors.length;
              final initial = dep.name.isNotEmpty ? dep.name[0].toUpperCase() : '?';

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _DependentAvatarItem(
                  label: dep.name,
                  initial: initial,
                  avatarColor: _avatarColors[colorIndex],
                ),
              );
            },
          );
        },
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
        mainAxisAlignment: MainAxisAlignment.center,
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
    this.onChanged,
    this.onTap,
  });

  final String title;
  final String? value;
  final bool? switchValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  static const Color _cardColor = Color(0xFFDBE2E8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: switchValue == null ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              GestureDetector(
                onTap: () {
                  if (onChanged != null) onChanged!(!switchValue!);
                },
                child: _SettingsSwitch(value: switchValue!),
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