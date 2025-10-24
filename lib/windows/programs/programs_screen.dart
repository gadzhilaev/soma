import 'package:flutter/material.dart';
import '../home/home_repo.dart';
import '../home/home_screen.dart';
import '../models.dart';
import '../../widgets/bottom_nav.dart';

class ProgramsScreen extends StatefulWidget {
  final String lang;
  final HomeRepo repo;
  const ProgramsScreen({super.key, required this.lang, required this.repo});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  List<HeroSlide> _slides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final slides = await widget.repo.getHeroSlides(widget.lang);
      if (!mounted) return;
      setState(() => _slides = slides);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
          // Контент как у тебя в ProgramsTab
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: false,
                floating: false,
                snap: false,
                centerTitle: true,
                title: SizedBox(
                  width: 48, height: 50,
                  child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // «тексты вместо хэштегов»
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 24,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        const texts = ['Meditation', 'Focus', 'Sleep'];
                        return Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            texts[i].toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              height: 1.0,
                              color: Color(0xFFA3A3A3),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Список карточек «как HeroCard»
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, listBottomPadding),
                sliver: SliverList.separated(
                  itemCount: _slides.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (_, i) {
                    final slide = _slides[i];
                    final showNew = _isNew(slide.updatedAt);

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(slide.radiusPx.toDouble()),
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
                    );
                  },
                ),
              ),
            ],
          ),

          // Общий BottomNav поверх контента
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: BottomNavBar(
                index: 1, // ← на экране программ подсвечиваем «программы»
                onTap: (i) {
                  if (i == 1) return; // уже тут
                  if (i == 0) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                  // другие вкладки добавишь по аналогии
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// — вспомогалки — такие же как в Home
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