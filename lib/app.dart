import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/detail/detail_page.dart';
import 'features/home/home_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kipo',
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        DetailPage.routeName: (_) => const DetailPage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
      },
    );
  }
}