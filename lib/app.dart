import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/add_item/add_item_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/categories/categories_page.dart';
import 'features/detail/detail_page.dart';
import 'features/home/home_page.dart';
import 'features/pantry/pantry_page.dart';
import 'features/shopping/add_shopping_item_page.dart';
import 'features/shopping/shopping_list_page.dart';
import 'features/profile/consumption_profile_page.dart';
import 'features/settings/settings_page.dart';

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
        PantryPage.routeName: (_) => const PantryPage(),
        CategoriesPage.routeName: (_) => const CategoriesPage(),
        AddItemPage.routeName: (_) => const AddItemPage(),
        ShoppingListPage.routeName: (_) => const ShoppingListPage(),
        AddShoppingItemPage.routeName: (_) => const AddShoppingItemPage(),
        ConsumptionProfilePage.routeName: (_) =>
            const ConsumptionProfilePage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
      },
    );
  }
}