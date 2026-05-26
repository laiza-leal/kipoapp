import 'package:flutter/material.dart';

import '../../domain/entities/dependent.dart';
import '../controllers/settings_controller.dart';
import '../widgets/dependents_section.dart';
import '../widgets/settings_account_card.dart';
import '../widgets/settings_danger_action.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_preference_tile.dart';
import '../widgets/settings_profile_summary.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.controller,
  });

  static const String routeName = '/settings';

  final SettingsController? controller;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _controller;
  late final bool _shouldDisposeController;

  static const Color _pageBackgroundColor = Color(0xFFEEEEEE);

  @override
  void initState() {
    super.initState();

    _shouldDisposeController = widget.controller == null;
    _controller = widget.controller ?? SettingsController();
  }

  @override
  void dispose() {
    if (_shouldDisposeController) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _handleBackPressed() {
    Navigator.of(context).maybePop();
  }

  void _handleDependentTap(Dependent dependent) {
    // TODO: futuramente abrir detalhes/edição do dependente.
  }

  Future<void> _handleSignOut() async {
    await _controller.signOut();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Função de sair da conta ainda está mockada.'),
      ),
    );
  }

  Future<void> _handleDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir conta'),
          content: const Text(
            'Tem certeza que deseja excluir sua conta? Esta ação não poderá ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
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

    if (shouldDelete != true) {
      return;
    }

    await _controller.deleteAccount();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Função de excluir conta ainda está mockada.'),
      ),
    );
  }

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

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final state = _controller.state;

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
                        SettingsHeader(
                          onBackPressed: _handleBackPressed,
                        ),
                        SizedBox(height: headerToProfileSpacing),
                        Center(
                          child: SettingsProfileSummary(
                            profile: state.profile,
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
                        DependentsSection(
                          dependents: state.dependents,
                          onDependentTap: _handleDependentTap,
                          onAddDependent: _controller.addDependent,
                        ),
                        SizedBox(height: sectionSpacing),
                        SettingsAccountCard(
                          profile: state.profile,
                          passwordDisplay: state.passwordDisplay,
                          onEditPressed: _controller.editProfile,
                        ),
                        SizedBox(height: sectionSpacing),
                        SettingsPreferenceTile(
                          title: 'Tema claro',
                          switchValue: state.isLightThemeEnabled,
                          onSwitchChanged: _controller.toggleLightTheme,
                        ),
                        SizedBox(height: preferenceSpacing),
                        SettingsPreferenceTile(
                          title: 'Idioma',
                          value: state.language,
                        ),
                        SizedBox(height: preferenceSpacing),
                        SettingsPreferenceTile(
                          title: 'Unidade de medida',
                          value: state.measurementUnit,
                        ),
                        SizedBox(height: dangerTopSpacing),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: SettingsDangerAction(
                            icon: Icons.logout,
                            label: 'Sair da conta',
                            onTap: _handleSignOut,
                          ),
                        ),
                        SizedBox(height: dangerActionSpacing),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: SettingsDangerAction(
                            icon: Icons.cancel_outlined,
                            label: 'Excluir conta',
                            onTap: _handleDeleteAccount,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}