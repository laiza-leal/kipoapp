import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/home/home_stat_card.dart';
import '../pantry/pantry_firestore_service.dart';
import '../pantry/pantry_page.dart';
import '../profile/consumption_profile_page.dart';
import '../settings/settings_page.dart';
import '../shopping/shopping_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final PantryFirestoreService _pantryFirestoreService =
      PantryFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
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
                    'M',
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
                        'Olá, Marta!',
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
                  onTap: () {
                    Navigator.of(context).pushNamed(SettingsPage.routeName);
                  },
                  child: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _HomeExpiringSoonNotificationCard(
              pantryFirestoreService: _pantryFirestoreService,
            ),
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, ConsumptionProfilePage.routeName);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardGray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
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
                          '12/100',
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
                        const Icon(
                          Icons.sentiment_dissatisfied,
                          color: AppColors.danger,
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
                                widthFactor: 12 / 100,
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.danger,
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
                ),
              ),
            ),
            const SizedBox(height: 16),
            _HomePantrySummaryCard(
              pantryFirestoreService: _pantryFirestoreService,
            ),
            const SizedBox(height: 16),
            _HomeExpirationSummaryCards(
              pantryFirestoreService: _pantryFirestoreService,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, ShoppingListPage.routeName);
              },
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
                    Text(
                      '6',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        color: AppColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Itens na Lista de Compras',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

class _HomeExpiringSoonNotificationCard extends StatelessWidget {
  const _HomeExpiringSoonNotificationCard({
    required this.pantryFirestoreService,
  });

  final PantryFirestoreService pantryFirestoreService;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<PantryFirestoreItem>>(
      stream: pantryFirestoreService.watchUserItems(userId: user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final items = snapshot.data ?? const <PantryFirestoreItem>[];
        final expiringSoonItems = _findExpiringSoonItems(items);

        if (expiringSoonItems.isEmpty) {
          return const SizedBox.shrink();
        }

        final itemNames = expiringSoonItems
            .map((item) => item.name)
            .take(4)
            .join(', ');

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
                      itemNames,
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

  List<PantryFirestoreItem> _findExpiringSoonItems(
    List<PantryFirestoreItem> items,
  ) {
    final today = _dateOnly(DateTime.now());
    final expiringSoonLimit = today.add(const Duration(days: 7));

    final filteredItems = items.where((item) {
      final expiresAt = item.expiresAt;

      if (expiresAt == null) {
        return false;
      }

      final expirationDate = _dateOnly(expiresAt);

      if (expirationDate.isBefore(today)) {
        return false;
      }

      return !expirationDate.isAfter(expiringSoonLimit);
    }).toList();

    filteredItems.sort((first, second) {
      final firstDate = first.expiresAt;
      final secondDate = second.expiresAt;

      if (firstDate == null && secondDate == null) {
        return 0;
      }

      if (firstDate == null) {
        return 1;
      }

      if (secondDate == null) {
        return -1;
      }

      return firstDate.compareTo(secondDate);
    });

    return filteredItems;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

class _HomePantrySummaryCard extends StatelessWidget {
  const _HomePantrySummaryCard({required this.pantryFirestoreService});

  final PantryFirestoreService pantryFirestoreService;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushNamed(context, PantryPage.routeName);
      },
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
            if (user == null)
              const _HomePantryCountContent(count: 0)
            else
              StreamBuilder<List<PantryFirestoreItem>>(
                stream: pantryFirestoreService.watchUserItems(userId: user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const _HomePantryCountContent(count: 0);
                  }

                  final items = snapshot.data ?? const <PantryFirestoreItem>[];

                  final count = items.fold<int>(
                    0,
                    (total, item) => total + item.quantity,
                  );

                  return _HomePantryCountContent(count: count);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _HomePantryCountContent extends StatelessWidget {
  const _HomePantryCountContent({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count == 1 ? 'Item na Despensa' : 'Itens na Despensa';

    return Row(
      children: [
        Text(
          count.toString(),
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

class _HomeExpirationSummaryCards extends StatelessWidget {
  const _HomeExpirationSummaryCards({required this.pantryFirestoreService});

  final PantryFirestoreService pantryFirestoreService;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Row(
        children: [
          Expanded(
            child: HomeStatCard(
              icon: Icons.delete_outline,
              iconColor: AppColors.danger,
              number: '0',
              label: 'Itens estragaram',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: HomeStatCard(
              icon: Icons.calendar_today_outlined,
              iconColor: AppColors.textPrimary,
              number: '0',
              label: 'Itens próximos à validade',
            ),
          ),
        ],
      );
    }

    return StreamBuilder<List<PantryFirestoreItem>>(
      stream: pantryFirestoreService.watchUserItems(userId: user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Row(
            children: [
              Expanded(
                child: HomeStatCard(
                  icon: Icons.delete_outline,
                  iconColor: AppColors.danger,
                  number: '0',
                  label: 'Itens estragaram',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: HomeStatCard(
                  icon: Icons.calendar_today_outlined,
                  iconColor: AppColors.textPrimary,
                  number: '0',
                  label: 'Itens próximos à validade',
                ),
              ),
            ],
          );
        }

        final items = snapshot.data ?? const <PantryFirestoreItem>[];
        final summary = _calculateExpirationSummary(items);

        return Row(
          children: [
            Expanded(
              child: HomeStatCard(
                icon: Icons.delete_outline,
                iconColor: AppColors.danger,
                number: summary.expiredQuantity.toString(),
                label: 'Itens estragaram',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: HomeStatCard(
                icon: Icons.calendar_today_outlined,
                iconColor: AppColors.textPrimary,
                number: summary.expiringSoonQuantity.toString(),
                label: 'Itens próximos à validade',
              ),
            ),
          ],
        );
      },
    );
  }

  _HomeExpirationSummary _calculateExpirationSummary(
    List<PantryFirestoreItem> items,
  ) {
    final today = _dateOnly(DateTime.now());
    final expiringSoonLimit = today.add(const Duration(days: 7));

    var expiredQuantity = 0;
    var expiringSoonQuantity = 0;

    for (final item in items) {
      final expiresAt = item.expiresAt;

      if (expiresAt == null) {
        continue;
      }

      final expirationDate = _dateOnly(expiresAt);

      if (expirationDate.isBefore(today)) {
        expiredQuantity += item.quantity;
        continue;
      }

      if (!expirationDate.isAfter(expiringSoonLimit)) {
        expiringSoonQuantity += item.quantity;
      }
    }

    return _HomeExpirationSummary(
      expiredQuantity: expiredQuantity,
      expiringSoonQuantity: expiringSoonQuantity,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

final class _HomeExpirationSummary {
  const _HomeExpirationSummary({
    required this.expiredQuantity,
    required this.expiringSoonQuantity,
  });

  final int expiredQuantity;
  final int expiringSoonQuantity;
}
