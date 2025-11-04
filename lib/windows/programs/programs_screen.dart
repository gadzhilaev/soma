import 'package:flutter/material.dart';
import '../../settings/repo.dart';
import '../../settings/models.dart';
import '../../widgets/bottom_nav.dart';
import 'program_details_screen.dart';

class ProgramsScreen extends StatefulWidget {
  final String lang;
  final HomeRepo repo;
  const ProgramsScreen({super.key, required this.lang, required this.repo});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  bool _loading = true;

  List<ProgramCategory> _cats = [];
  String? _selectedKey; // ключ выбранной категории
  List<HeroSlide> _allSlides = []; // все слайды
  List<HeroSlide> _filtered = []; // отфильтрованные по категории (или == все)

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await Future.wait([
        widget.repo.getProgramCategories(widget.lang),
        widget.repo.getHeroSlides(widget.lang),
      ]);
      _cats = r[0] as List<ProgramCategory>;
      _allSlides = r[1] as List<HeroSlide>;

      // вставляем "Все" как первую категорию
      // вставляем "Все" как первую категорию (id и sortIndex — обязательны)
      _cats.insert(
        0,
        ProgramCategory(
          id: 'all', // любой строковый стабильный id
          key: 'all',
          colorHex: '#F1F1F1',
          sortIndex: 0, // чтобы шла первой
          label: widget.lang == 'ru'
              ? 'Все'
              : widget.lang == 'es'
              ? 'Todo'
              : 'All',
        ),
      );

      // по умолчанию — "Все"
      _selectedKey = 'all';
      _applyFilter();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    if (_selectedKey == 'all') {
      _filtered = List.of(_allSlides); // ← всегда всё
    } else if (_selectedKey != null &&
        _allSlides.any((s) => s.categoryKey != null)) {
      _filtered = _allSlides
          .where((s) => s.categoryKey == _selectedKey)
          .toList();
    } else {
      _filtered = List.of(_allSlides);
    }
    setState(() {});
  }

  bool _isNew(DateTime updatedAt) =>
      DateTime.now().difference(updatedAt).inHours < 24;

  @override
  Widget build(BuildContext context) {
    const double navBarHeight = 80.0;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final listBottomPadding = navBarHeight + bottomSafe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            RefreshIndicator(
              onRefresh: _load,
              child: CustomScrollView(
                slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: false,
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
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // 🔹 Чипы категорий (хэштеги)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 28,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _cats.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final c = _cats[i];
                          final selected = c.key == _selectedKey;

                          // теперь ВСЕ выбранные чипы одного цвета (#766DFF)
                          final bg = selected
                              ? const Color(0xFF766DFF)
                              : const Color(0xFFF1F1F1);
                          final fg = selected
                              ? Colors.white
                              : const Color(0xFFA3A3A3);

                          return InkWell(
                            borderRadius: BorderRadius.circular(1000),
                            onTap: () {
                              if (_selectedKey == c.key) return;
                              _selectedKey = c.key;
                              _applyFilter();
                            },
                            child: Container(
                              height: 28,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                c.label.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  height: 1.0,
                                  color: fg,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Карточки (отфильтрованные)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, listBottomPadding),
                  sliver: SliverList.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (_, i) {
                      final slide = _filtered[i];
                      final showNew = _isNew(slide.updatedAt);
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProgramDetailsScreen(
                                repo: widget.repo,
                                lang: widget.lang,
                                programId: slide.id,
                                preload: ProgramDetails(
                                  id: slide.id,
                                  imageUrl: slide.imageUrl,
                                  title: slide
                                      .title, // заголовок возьмём из слайда
                                  content: null, // подтянем внутри экрана
                                  views: 0,
                                  comments: 0,
                                  publishedAt:
                                      slide.updatedAt, // на первое время ок
                                ),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            slide.radiusPx.toDouble(),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                slide.imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              if (showNew)
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
                    },
                  ),
                ),
              ],
                ),
              ),

          // Навбар
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: BottomNavBar(
                index: 1,
                lang: widget.lang,
                repo: widget.repo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// — вспомогалки —
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

Color _hex(String hex) {
  final v = hex.replaceAll('#', '');
  if (v.length == 6) return Color(int.parse('FF$v', radix: 16));
  if (v.length == 8) return Color(int.parse(v, radix: 16));
  return const Color(0xFF33A6FF);
}
