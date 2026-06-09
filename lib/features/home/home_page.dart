import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/home/home_stat_card.dart';
import '../pantry/pantry_page.dart';
import '../profile/consumption_profile_page.dart';
import '../profile/data/profile_store.dart';
import '../settings/settings_page.dart';
import '../shopping/shopping_list_page.dart';
import 'data/home_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final fullName = FirebaseAuth.instance.currentUser!.displayName!;
    final firstName = fullName.split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _Header(firstName: firstName),
            const SizedBox(height: 16),
            const _ExpiringSoonCard(),
            const SizedBox(height: 16),
            Text(
              'Resumo mensal',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 13),
            const _ScoreCard(),
            const SizedBox(height: 16),
            const _PantryCountCard(),
            const SizedBox(height: 16),
            const _ExpirationCards(),
            const SizedBox(height: 16),
            const _ShoppingCountCard(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.firstName});

  final String firstName;

  @override
  Widget build(BuildContext context) {
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $firstName!',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Vamos cuidar do que você já tem!',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
          child: const Icon(
            Icons.settings_outlined,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _ExpiringSoonCard extends StatelessWidget {
  const _ExpiringSoonCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: HomeStore.watchPantry(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final names = HomeStore.expiringSoonNames(snapshot.data!.docs);
        if (names.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
                size: 24,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Itens próximos à validade',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      names.join(', '),
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          Navigator.pushNamed(context, ConsumptionProfilePage.routeName),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: StreamBuilder(
          stream: ProfileStore.watchPantry(),
          builder: (context, snapshot) {
            final score = snapshot.hasData
                ? ProfileStore.score(snapshot.data!.docs)
                : 0;
            final good = score >= 50;
            final barColor = good ? AppColors.primary : AppColors.danger;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Seu score de Aproveitamento',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$score/100',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(
                      good
                          ? Icons.sentiment_satisfied
                          : Icons.sentiment_dissatisfied,
                      color: barColor,
                      size: 24,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.inactive,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: score / 100,
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PantryCountCard extends StatelessWidget {
  const _PantryCountCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pushNamed(context, PantryPage.routeName),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.cardBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 24),
            StreamBuilder(
              stream: HomeStore.watchPantry(),
              builder: (context, snapshot) {
                final total = snapshot.hasData
                    ? HomeStore.totalItems(snapshot.data!.docs)
                    : 0;
                final label = total == 1
                    ? 'Item na Despensa'
                    : 'Itens na Despensa';
                return _CountRow(number: total, label: label);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpirationCards extends StatelessWidget {
  const _ExpirationCards();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: HomeStore.watchPantry(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final expired = HomeStore.expiredCount(docs);
        final expiringSoon = HomeStore.expiringSoonCount(docs);

        return Row(
          children: [
            Expanded(
              child: HomeStatCard(
                icon: Icons.delete_outline,
                iconColor: AppColors.danger,
                number: '$expired',
                label: 'Itens estragaram',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: HomeStatCard(
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.textPrimary,
                number: '$expiringSoon',
                label: 'Itens próximos à validade',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShoppingCountCard extends StatelessWidget {
  const _ShoppingCountCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pushNamed(context, ShoppingListPage.routeName),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.cardGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 24),
            StreamBuilder(
              stream: HomeStore.watchShopping(),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];
                return _CountRow(
                  number: HomeStore.shoppingCount(docs),
                  label: 'Itens na Lista de Compras',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$number',
          style: GoogleFonts.inter(
            fontSize: 36,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
