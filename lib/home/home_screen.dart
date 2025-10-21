import 'dart:async';
import 'package:flutter/material.dart';
import '../core/supabase.dart';
import '../generated/l10n.dart';
import 'home_repo.dart';
import 'models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRepo _repo;
  bool _loading = true;
  String _lang = 'en';

  List<HeroSlide> _slides = [];
  List<DailyReco> _daily = [];
  List<ForYouItem> _forYou = [];
  List<ArticleItem> _articles = [];

  final _pageCtrl = PageController(viewportFraction: 0.92);
  int _page = 0;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _repo = HomeRepo(supa);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = Localizations.localeOf(context).languageCode;
    const allowed = ['ru','en','es'];
    _lang = allowed.contains(code) ? code : 'en';
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await Future.wait([
        _repo.getHeroSlides(_lang),
        _repo.getDailyRecos(_lang),
        _repo.getForYou(_lang),
        _repo.getArticles(_lang),
      ]);
      _slides  = r[0] as List<HeroSlide>;
      _daily   = r[1] as List<DailyReco>;
      _forYou  = r[2] as List<ForYouItem>;
      _articles= r[3] as List<ArticleItem>;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).errorPrefix} $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white, // ← белый фон везде
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeaderLogo()),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // ===== HERO SLIDER =====
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageCtrl,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemCount: _slides.length,
                        itemBuilder: (_, i) => _HeroCard(slide: _slides[i]),
                      ),
                    ),
                  ),

                  // ===== 3 фиксированных индикатора =====
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  const SliverToBoxAdapter(child: _StaticDots3()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // ===== DAILY TITLE =====
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        s.homeDaily,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 22/20,
                          letterSpacing: -0.41,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // ===== DAILY LIST =====
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: _daily.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (_, i) => _DailyTile(item: _daily[i]),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // ===== FOR YOU =====
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        s.homeForYou,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1.0,
                          letterSpacing: -0.41,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 240,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: _forYou.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => _ForYouCard(item: _forYou[i]),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // ===== ARTICLES =====
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        s.homeArticles,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1.4,
                          letterSpacing: -0.41,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: _articles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (_, i) => _ArticleTile(item: _articles[i]),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),

                  // ===== MORE BUTTON =====
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFFD580), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            s.homeMoreArticles.toUpperCase(),
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
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),

      // ===== NAV BAR =====
      bottomNavigationBar: _BottomNav(
        index: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Center(
          child: SizedBox(
            width: 48, height: 50,
            child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}

// ===== HERO CARD (теперь текст без абсолютных позиций) =====
class _HeroCard extends StatelessWidget {
  final HeroSlide slide;
  const _HeroCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(slide.radiusPx.toDouble()),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(slide.imageUrl, fit: BoxFit.cover),

            // бейдж "новое" (правый верх)
            Positioned(
              top: 16, right: 16,
              child: _Capsule(
                width: 60, height: 24,
                bg: _hex(slide.topBadgeBg),
                text: slide.topBadgeLabel.toUpperCase(),
              ),
            ),

            // Блок слева (chip → 8 → title → 4 → subtitle)
            Positioned(
              left: 16, right: 16, top: 16 + 24 + 54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Capsule(
                    width: 88, height: 24,
                    bg: _hex(slide.leftChipBg),
                    text: slide.leftChipLabel.toUpperCase(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 19/12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _hex(String hex) {
    final v = hex.replaceAll('#', '');
    if (v.length == 6) return Color(int.parse('FF$v', radix: 16));
    if (v.length == 8) return Color(int.parse(v, radix: 16));
    return const Color(0xFF33A6FF);
  }
}

// ===== 3 фиксированных точки =====
class _StaticDots3 extends StatelessWidget {
  const _StaticDots3();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _Dot(color: Color(0xFFF1F1F1)),
        SizedBox(width: 8),
        _Dot(color: Color(0xFFEABC60)),
        SizedBox(width: 8),
        _Dot(color: Color(0xFFF1F1F1)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12, height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ===== DAILY ITEM (заголовок теперь в 2+ строки при необходимости) =====
class _DailyTile extends StatelessWidget {
  final DailyReco item;
  const _DailyTile({required this.item});

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF726AFF); // ← цвет всех иконок
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(item.imageUrl, width: 100, height: 80, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // заголовок — допускаем 2 строки
              Text(
                item.title.toUpperCase(),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.0,
                  color: Color(0xFF282828),
                ),
              ),
              const SizedBox(height: 4),
              // описание (2–3 строки)
              Text(
                item.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF717171),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.hourglass_empty, size: 14, color: iconColor),
                  const SizedBox(width: 4),
                  Text(
                    '${item.durationMinutes} минут',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.0,
                      color: Color(0xFF717171),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===== FOR YOU CARD (иконки тут нет, остальное без изменений) =====
class _ForYouCard extends StatelessWidget {
  final ForYouItem item;
  const _ForYouCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164, height: 240,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 8, right: 8, top: 129,
            child: Text(
              item.title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.0,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 8, right: 8, top: 129 + 14 + 4,
            child: Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                height: 14/10,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 8, top: 200,
            child: _Capsule(
              width: 89, height: 24,
              bg: _HeroCard._hex(item.tagBg),
              text: item.tagLabel.toUpperCase(),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== ARTICLE ITEM (иконка календаря фиолетовая) =====
class _ArticleTile extends StatelessWidget {
  final ArticleItem item;
  const _ArticleTile({required this.item});

  String _timeAgo() {
    final diff = DateTime.now().difference(item.publishedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} минут назад';
    if (diff.inHours < 24) return '${diff.inHours} часов назад';
    return '${diff.inDays} дн. назад';
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF726AFF); // ← цвет иконки
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(item.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
        ),
        const SizedBox(height: 8),
        Text(
          item.title.toUpperCase(),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF282828),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.summary,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.4,
            color: Color(0xFF717171),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Text(
              _timeAgo(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.0,
                color: Color(0xFF717171),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ===== КАПСУЛА =====
class _Capsule extends StatelessWidget {
  final double width;
  final double height;
  final Color bg;
  final String text;
  const _Capsule({required this.width, required this.height, required this.bg, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(1000),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 10,
          height: 1.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ===== NAV BAR (белый, бордер 1px чёрный, 339x80, радиус 1000) =====
class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color itemColor(bool active) => active ? const Color(0xFF766DFF) : const Color(0xFF282828);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 96, // немного воздуха
        child: Center(
          child: Container(
            width: 339, height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(color: Colors.black, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItem(
                  icon: Icons.home,
                  label: 'дом',
                  color: itemColor(index == 0),
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.spa,
                  label: 'программы',
                  color: itemColor(index == 1),
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: Icons.headphones,
                  label: 'музыка',
                  color: itemColor(index == 2),
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Icons.account_circle,
                  label: 'профиль',
                  color: itemColor(index == 3),
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                height: 17/10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}