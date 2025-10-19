import 'dart:async';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../home/home_screen.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  Future<void> _fakePay(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    }
  }

  void _goFree(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8982FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Center(
                  child: SizedBox(
                    width: 48, height: 50,
                    child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 24),

                // Заголовки
                Text(
                  s.premiumTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 23/18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  s.premiumSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xB2FFFFFF), // #FFFFFFB2
                  ),
                ),
                const SizedBox(height: 16),

                // 3 фичи
                _FeatureCard(
                  icon: Icons.self_improvement,
                  title: s.feature1Title,
                  subtitle: s.feature1Desc,
                ),
                const SizedBox(height: 16),
                _FeatureCard(
                  icon: Icons.recommend,
                  title: s.feature2Title,
                  subtitle: s.feature2Desc,
                ),
                const SizedBox(height: 16),
                _FeatureCard(
                  icon: Icons.repeat,
                  title: s.feature3Title,
                  subtitle: s.feature3Desc,
                ),

                const SizedBox(height: 24),

                // ГОДОВОЙ тариф (выделенный)
                Container(
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFF938DFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFD580), width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Левый блок
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6), // 16 + 6 ≈ 22
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                s.yearly.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 23/16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    s.oldPriceYear, // "3 400 ₽"
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      height: 23/14,
                                      color: Color(0xFFCECECE),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    s.newPriceYear, // "1 999 ₽"
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      height: 23/14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Правый блок
                      Padding(
                        padding: const EdgeInsets.only(right: 6), // ~22 до края
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              s.mostPopular.toUpperCase(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                height: 23/12,
                                color: Color(0xFFFFD580),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // "166 ₽ в месяц"
                            RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: s.perMonthPrice, // "166 ₽ "
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      height: 23/14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: s.perMonthTail, // "в месяц"
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      height: 23/14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Ежемесячный
                Container(
                  height: 71,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF938DFF), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.monthly.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 23/14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: s.monthlyPrice, // "299 ₽ "
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 23/14,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: s.perMonthTail, // "в месяц"
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 23/14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Кнопка "Стать премиум участником"
                SizedBox(
                  height: 56, width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _fakePay(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD580),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      s.becomePremium.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.0,
                        letterSpacing: 0.48,
                        color: Color(0xFF59523A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // "Продолжить бесплатно"
                GestureDetector(
                  onTap: () => _goFree(context),
                  child: Text(
                    s.continueFree.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.0,
                      letterSpacing: 0.48,
                      color: Color(0xFFD6D3FF),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 6), // чтобы до текста набрать ≈22 слева
          SizedBox(
            width: 40, height: 40,
            child: Icon(icon, size: 40, color: const Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.3,
                      letterSpacing: -0.41,
                      color: Color(0xFF282828),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF9D9D9D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}