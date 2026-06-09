import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'data/profile_store.dart';

class ConsumptionProfilePage extends StatelessWidget {
  static const routeName = '/consumption-profile';

  const ConsumptionProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Meu Perfil de Consumo',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              StreamBuilder(
                stream: ProfileStore.watchPantry(),
                builder: (context, snapshot) {
                  final score = snapshot.hasData
                      ? ProfileStore.score(snapshot.data!.docs)
                      : 0;
                  final good = score >= 50;
                  final profile = ProfileStore.profileFor(score);

                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          profile.image,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
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
                                  color: good
                                      ? AppColors.primary
                                      : AppColors.danger,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: score / 100,
                                        child: Container(
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: good
                                                ? AppColors.primary
                                                : AppColors.danger,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              profile.rating,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              profile.insight,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardGray,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Insight principal',
                              style: GoogleFonts.dmSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              profile.insight,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.home_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
