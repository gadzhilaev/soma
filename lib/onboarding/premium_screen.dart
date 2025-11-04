import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../generated/l10n.dart';
import '../windows/home/home_screen.dart';

// какой план выбран
enum _Plan { yearly, monthly }

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  // по умолчанию — годовой
  _Plan _selected = _Plan.yearly;

  Future<void> _fakePay() async {
  await Future.delayed(const Duration(seconds: 1));
  if (!mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const HomeScreen()),
    (_) => false,
  );
}

void _goFree() {
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
                    color: Color(0xB2FFFFFF),
                  ),
                ),
                const SizedBox(height: 16),

                // 3 фичи
                _FeatureCard(
                  iconPath: 'assets/icons/premium_icon_1.svg',
                  title: s.feature1Title,
                  subtitle: s.feature1Desc,
                ),
                const SizedBox(height: 16),
                _FeatureCard(
                  iconPath: 'assets/icons/premium_icon_2.svg',
                  title: s.feature2Title,
                  subtitle: s.feature2Desc,
                ),
                const SizedBox(height: 16),
                _FeatureCard(
                  iconPath: 'assets/icons/premium_icon_3.svg',
                  title: s.feature3Title,
                  subtitle: s.feature3Desc,
                ),

                const SizedBox(height: 24),

                // YEARLY (выбран по умолчанию)
                _PlanTile(
                  selected: _selected == _Plan.yearly,
                  height: 82,
                  leftTitle: s.yearly.toUpperCase(),
                  leftOldPrice: s.oldPriceYear,
                  leftNewPrice: s.newPriceYear,
                  rightBadge: s.mostPopular.toUpperCase(),
                  // добавил пробел между частями
                  rightPerMonth: '${s.perMonthPrice} ${s.perMonthTail}',
                  onTap: () => setState(() => _selected = _Plan.yearly),
                ),
                const SizedBox(height: 12),

                // MONTHLY
                _PlanTile(
                  selected: _selected == _Plan.monthly,
                  height: 71,
                  leftTitle: s.monthly.toUpperCase(),
                  leftOldPrice: null,
                  leftNewPrice: null,
                  rightBadge: null,
                  rightPerMonth: '${s.monthlyPrice} ${s.perMonthTail}',
                  onTap: () => setState(() => _selected = _Plan.monthly),
                ),

                const SizedBox(height: 24),

                // Кнопка "Стать премиум участником"
                SizedBox(
                  height: 56, width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _fakePay,
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

                GestureDetector(
                  onTap: _goFree,
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
  final String iconPath;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.iconPath,
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
            child: SvgPicture.asset(
              iconPath,
              width: 40,
              height: 40,
            ),
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

class _PlanTile extends StatelessWidget {
  final bool selected;
  final double height;
  final String leftTitle;
  final String? leftOldPrice;
  final String? leftNewPrice;
  final String? rightBadge;     // "MOST POPULAR" для годового
  final String rightPerMonth;   // "166 ₽ в месяц" / "299 ₽ в месяц"
  final VoidCallback onTap;

  const _PlanTile({
    required this.selected,
    required this.height,
    required this.leftTitle,
    required this.rightPerMonth,
    required this.onTap,
    this.leftOldPrice,
    this.leftNewPrice,
    this.rightBadge,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF938DFF) : Colors.transparent;
    final border = selected ? const Color(0xFFFFD580) : const Color(0xFF938DFF);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: height),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ЛЕВЫЙ столбец
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6), // визуально ≈22 до края
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Заголовок тарифа
                    Text(
                      leftTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 23/16,
                        color: Colors.white,
                      ),
                    ),
                    if (leftOldPrice != null && leftNewPrice != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              leftOldPrice!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 23/14,
                                color: Color(0xFFCECECE),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              leftNewPrice!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 23/14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ПРАВЫЙ столбец
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (rightBadge != null) ...[
                      Text(
                        rightBadge!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 11,        // чуть меньше, чтобы всегда влезало
                          height: 23/11,
                          color: Color(0xFFFFD580),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      rightPerMonth, // одна строка
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
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
            ),
          ],
        ),
      ),
    );
  }
}