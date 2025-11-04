import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/supabase.dart';
import '../../generated/l10n.dart';
import '../article/article_details_screen.dart';
import '../../settings/repo.dart';
import '../../settings/models.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/dots.dart';
import '../article/articles_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRepo _repo;
  bool _loading = true;
  String _lang = 'en';
  double _dotProgress = 0.0;

  List<HeroSlide> _slides = [];
  List<DailyReco> _daily = [];
  List<ForYouItem> _forYou = [];
  List<ArticleItem> _articles = [];

  final _pageCtrl = PageController(viewportFraction: 0.92);
  int _virtualPage = 0;

  Timer? _autoplay;
  Timer? _resumeTimer;
  bool _isTouching = false;
  bool _isAutoAnimating = false;

  @override
  void initState() {
    super.initState();
    _repo = HomeRepo(supa);

    _pageCtrl.addListener(() {
      final p = _pageCtrl.page;
      if (p == null) return;
      final delta = p - _virtualPage;
      final prog = delta.clamp(-1.0, 1.0);
      if (prog != _dotProgress) setState(() => _dotProgress = prog);
    });

    _startAutoplay(); // ← запуск сразу
  }

  void _startAutoplay() {
    _autoplay?.cancel();
    _autoplay = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted || _slides.length < 2 || !_pageCtrl.hasClients) return;
      if (_isTouching) return; // пользователь держит/листает
      if (_pageCtrl.position.isScrollingNotifier.value) return; // идёт скролл

      int nextPage = _virtualPage + 1;

      // возврат в «центр петли»
      if (nextPage > _slides.length * 2000) {
        nextPage = _slides.length * 1000;
        _pageCtrl.jumpToPage(nextPage);
        _virtualPage = nextPage;
        _dotProgress = 0.0;
        return;
      }

      _isAutoAnimating = true;
      _pageCtrl
          .animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          )
          .whenComplete(() => _isAutoAnimating = false);
    });
  }

  void _stopAutoplay() {
    _autoplay?.cancel();
    _autoplay = null;
  }

  void _pauseAutoplayForUser() {
    _isTouching = true;
    _resumeTimer?.cancel();
    _stopAutoplay();
  }

  void _resumeAutoplayDelayed() {
    _isTouching = false;
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 5), () {
      if (!_isTouching && mounted) _startAutoplay();
    });
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _resumeTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
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

    // выставляем стартовую виртуальную страницу как большое число-кратное длине
    if (mounted && _slides.isNotEmpty) {
      final start = _slides.length * 1000;
      _virtualPage = start;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageCtrl.hasClients) {
          _pageCtrl.jumpToPage(start); // <-- без await
          setState(() {
            _dotProgress = 0.0;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    const double navBarHeight = 80.0; // если у тебя другая — поставь свою

    // 2) safe area снизу (вырезы/жестовая панель)
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    // 3) паддинг у списка = высота навбара + safe area
    final double listBottomPadding = navBarHeight + bottomSafe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // === СКРОЛЛ-КОНТЕНТ ПОД БАРОМ ===
          MediaQuery.removePadding(
            context: context,
            removeTop: false,
            removeBottom: true,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // ===== СКРЫВАЕМЫЙ ПРИ СКРОЛЛЕ APP BAR =====
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        pinned: false, // 👈 уезжает при скролле вниз
                        floating: false,
                        snap: false,
                        centerTitle: true,
                        title: SizedBox(
                          width: 48,
                          height: 50,
                          child: Image.asset(
                            'assets/logo/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // отступ после логотипа
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      SliverPadding(
                        padding: EdgeInsets.only(bottom: listBottomPadding),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            // ===== HERO =====
                            SizedBox(
                              height: 200,
                              child: Listener(
                                onPointerDown: (_) => _pauseAutoplayForUser(),
                                onPointerUp: (_) => _resumeAutoplayDelayed(),
                                onPointerCancel: (_) =>
                                    _resumeAutoplayDelayed(),
                                child: PageView.builder(
                                  controller: _pageCtrl,
                                  // itemCount не задаём — бесконечная лента
                                  onPageChanged: (i) {
                                    setState(() => _virtualPage = i);

                                    // мягко вернуть индикатор к центру
                                    Future.delayed(
                                      const Duration(milliseconds: 150),
                                      () {
                                        if (!mounted) return;
                                        setState(() => _dotProgress = 0.0);
                                      },
                                    );

                                    // если это был ручной свайп — перезапустим автоплей через 5с
                                    if (!_isAutoAnimating) {
                                      _pauseAutoplayForUser();
                                      _resumeAutoplayDelayed();
                                    }
                                  },
                                  itemBuilder: (_, i) {
                                    if (_slides.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    final dataIndex = i % _slides.length;
                                    return _HeroCard(slide: _slides[dataIndex]);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Center(
                                child: DotsConveyor3(
                                  t: _dotProgress,
                                  active: const Color(0xFFEABC60),
                                  inactive: const Color(0xFFF1F1F1),
                                ),
                              ),
                            ),
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
                                    child: _ArticleTile(
                                      item: _articles[i],
                                      repo: _repo,
                                      lang: _lang,
                                    ),
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
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ArticlesScreen(
                                          lang: _lang,
                                          repo: _repo,
                                        ),
                                      ),
                                    );
                                  },
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
            child: SafeArea(
              // учтём нижний вырез только для бара
              top: false,
              left: false,
              right: false,
              child: BottomNavBar(index: 0, lang: _lang, repo: _repo),
            ),
          ),
        ],
      ),
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

// ===== DAILY ITEM (иконки фиолетовые) =====
class _DailyTile extends StatelessWidget {
  final DailyReco item;
  const _DailyTile({required this.item});

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF726AFF);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // 👈 дети ряда по ВЕРХУ
      children: [
        // КАРТИНКА прижата к верху контейнера
        Container(
          width: 100,
          height: 80,
          clipBehavior: Clip.hardEdge, // чтобы работал borderRadius
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter, // 👈 важное место
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ТЕКСТОВОЙ БЛОК
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
              const SizedBox(height: 8),
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
  final HomeRepo? repo;
  final String? lang;

  const _ArticleTile({required this.item, this.repo, this.lang});

  String _timeAgo() {
    final diff = DateTime.now().difference(item.publishedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} минут назад';
    if (diff.inHours < 24) return '${diff.inHours} часов назад';
    return '${diff.inDays} дн. назад';
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF726AFF);

    return InkWell(
      onTap: () {
        if (repo != null && lang != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticleDetailsScreen(
                repo: repo!,
                lang: lang!,
                articleId: item.id,
                preload: item,
              ),
            ),
          );
        }
      },
      child: Column(
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
      ),
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
