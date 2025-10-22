import 'dart:async';
import 'package:flutter/material.dart';
import '../core/supabase.dart';
import '../generated/l10n.dart';
import 'home_repo.dart';
import 'models.dart';
import '../widgets/bottom_nav.dart'; // ← вынесли nav bar

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
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _slides.isEmpty) return;
      final next = (_page + 1) % _slides.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = Localizations.localeOf(context).languageCode;
    const allowed = ['ru', 'en', 'es'];
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
      _slides = r[0] as List<HeroSlide>;
      _daily = r[1] as List<DailyReco>;
      _forYou = r[2] as List<ForYouItem>;
      _articles = r[3] as List<ArticleItem>;
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

    // точная «подложка» под плавающий навбар + желанные 20 px после кнопки
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final bottomScrollPadding = 50 + bottomSafe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // === СКРОЛЛ-КОНТЕНТ ПОД БАРОМ ===
          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: bottomScrollPadding),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            _buildHeaderLogo(),
                            const SizedBox(height: 20),

                            // ===== HERO =====
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                controller: _pageCtrl,
                                onPageChanged: (i) => setState(() => _page = i),
                                itemCount: _slides.length,
                                itemBuilder: (_, i) =>
                                    _HeroCard(slide: _slides[i]),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const _StaticDots3(),
                            const SizedBox(height: 24),

                            // ===== DAILY TITLE =====
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                s.homeDaily,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  height: 22 / 20,
                                  letterSpacing: -0.41,
                                  color: Color(0xFF282828),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ===== DAILY LIST =====
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: List.generate(_daily.length, (i) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: i == _daily.length - 1 ? 0 : 20,
                                    ),
                                    child: _DailyTile(item: _daily[i]),
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ===== FOR YOU =====
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 240,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: _forYou.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (_, i) =>
                                    _ForYouCard(item: _forYou[i]),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ===== ARTICLES =====
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: List.generate(_articles.length, (i) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: i == _articles.length - 1
                                          ? 0
                                          : 20,
                                    ),
                                    child: _ArticleTile(item: _articles[i]),
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // ===== MORE BUTTON =====
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFFFD580),
                                      width: 2,
                                    ),
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

                            const SizedBox(
                              height: 20,
                            ), // ← в самом конце строго 20
                          ]),
                        ),
                      ),
                    ],
                  ),
          ),

          // === ПЛАВАЮЩИЙ NAV BAR СВЕРХУ КОНТЕНТА ===
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              index: _tab,
              onTap: (i) => setState(() => _tab = i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Center(
          child: SizedBox(
            width: 48,
            height: 50,
            child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}

// ===== HERO CARD без изменений визуально (кроме выравнивания текста) =====
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

            // бейдж "новое"
            Positioned(
              top: 16,
              right: 16,
              child: _Capsule(
                width: 60,
                height: 24,
                bg: _hex(slide.topBadgeBg),
                text: slide.topBadgeLabel.toUpperCase(),
              ),
            ),

            // блок слева: chip → 8 → title → 4 → subtitle
            Positioned(
              left: 16,
              right: 16,
              top: 16 + 24 + 54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Capsule(
                    width: 88,
                    height: 24,
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
                      height: 19 / 12,
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

// ===== точки под слайдером (3 фикс.) =====
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
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ===== DAILY ITEM (иконки фиолетовые) =====
class _DailyTile extends StatelessWidget {
  final DailyReco item;
  const _DailyTile({required this.item});

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF726AFF);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.imageUrl,
            width: 100,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.1,
                  color: Color(0xFF282828),
                ),
              ),
              const SizedBox(height: 4),
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
              const SizedBox(height: 8), // было 12 → меньше
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

class _ForYouCard extends StatelessWidget {
  final ForYouItem item;
  const _ForYouCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 240,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          // доступная ширина для текста (слева/справа по 8)
          final textMaxWidth = constraints.maxWidth - 16;

          // меряем, в одну или две строки пойдёт заголовок
          final titlePainter = TextPainter(
            text: TextSpan(
              text: item.title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.1,
                color: Colors.white,
              ),
            ),
            textDirection: TextDirection.ltr,
            maxLines: 2,
          )..layout(maxWidth: textMaxWidth);

          final didOverflow =
              titlePainter.didExceedMaxLines; // true => точно >1 строки?
          // если не overflow, всё равно может быть 2 строки при длинном слове — проверим по height
          final computedLines = (titlePainter.size.height / (14 * 1.1))
              .ceil()
              .clamp(1, 2);

          // если 2 строки — поднимаем блок выше
          final titleTop = (computedLines > 1) ? 110.0 : 122.0;
          final titleHeightPx = 14 * 1.1 * computedLines;
          final descTop = titleTop + titleHeightPx + 4;

          return Stack(
            children: [
              Positioned(
                left: 8,
                right: 8,
                top: titleTop,
                child: Text(
                  item.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: descTop,
                child: Text(
                  item.description,
                  maxLines: 2, // чтобы не врезалось в бейдж
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 12,
                child: _Capsule(
                  width: 89,
                  height: 24,
                  bg: _HeroCard._hex(item.tagBg),
                  text: item.tagLabel.toUpperCase(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ===== ARTICLE ITEM =====
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
    const iconColor = Color(0xFF726AFF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            item.imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
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

// ===== капсула =====
class _Capsule extends StatelessWidget {
  final double width;
  final double height;
  final Color bg;
  final String text;
  const _Capsule({
    required this.width,
    required this.height,
    required this.bg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
