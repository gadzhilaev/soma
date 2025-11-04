import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/supabase.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/notification_service.dart';
import '../../generated/l10n.dart';
import '../../settings/repo.dart';
import '../../settings/models.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/dots.dart';
import '../../widgets/home/hero_card.dart';
import '../../widgets/home/daily_tile.dart';
import '../../widgets/home/for_you_card.dart';
import '../../widgets/home/article_tile.dart';
import '../article/articles_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
    _repo = HomeRepo(supa);

    _pageCtrl.addListener(() {
      final p = _pageCtrl.page;
      if (p == null) return;
      final delta = p - _virtualPage;
      final prog = delta.clamp(-1.0, 1.0);
      if (prog != _dotProgress) setState(() => _dotProgress = prog);
    });

    _startAutoplay(); // ← запуск сразу
    
    // Отправляем уведомление при первом открытии экрана
    _sendLoginNotification();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Когда приложение возвращается на передний план, отправляем уведомление
    if (state == AppLifecycleState.resumed) {
      _sendLoginNotification();
    }
  }
  
  void _sendLoginNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final s = S.of(context);
      NotificationService().showNotification(
        title: s.loginSuccessTitle,
        body: s.loginSuccessBody,
      );
    });
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
    WidgetsBinding.instance.removeObserver(this);
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
                : RefreshIndicator(
                    onRefresh: _load,
                    child: CustomScrollView(
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
                                    return HeroCard(
                                      slide: _slides[dataIndex],
                                      repo: _repo,
                                      lang: _lang,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Center(
                                child: DotsConveyor3(
                                  t: _dotProgress,
                                  active: AppColors.dotActive,
                                  inactive: AppColors.dotInactive,
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
                                style: AppTextStyles.sectionTitle,
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
                                    child: DailyTile(item: _daily[i]),
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
                                style: AppTextStyles.sectionTitleCompact,
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
                                    ForYouCard(item: _forYou[i]),
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
                                style: AppTextStyles.sectionTitle,
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
                                    child: ArticleTile(
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
                                      color: AppColors.accent,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    s.homeMoreArticles.toUpperCase(),
                                    style: AppTextStyles.button,
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

