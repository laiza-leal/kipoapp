import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/detail/detail_page.dart';
import 'features/home/home_page.dart';
import 'features/profile/consumption_profile_page.dart';
import 'features/settings/settings_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kipo',
      theme: buildAppTheme(),
      initialRoute: LoginPage.routeName,
      routes: {
        '/': (_) => const HomePage(),
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        DetailPage.routeName: (_) => const DetailPage(),
        ConsumptionProfilePage.routeName: (_) =>
            const ConsumptionProfilePage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
      },
    );
  }
}