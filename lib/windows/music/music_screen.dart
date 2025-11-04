import 'package:flutter/material.dart';
import '../../core/supabase.dart';
import '../../generated/l10n.dart';
import '../../settings/repo.dart';
import '../../widgets/bottom_nav.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late final HomeRepo _repo;
  String _lang = 'en';

  @override
  void initState() {
    super.initState();
    _repo = HomeRepo(supa);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = Localizations.localeOf(context).languageCode;
    const allowed = ['ru', 'en', 'es'];
    _lang = allowed.contains(code) ? code : 'en';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    const double navBarHeight = 80.0;
    final double bottomSafe = MediaQuery.of(context).padding.bottom;
    final double listBottomPadding = navBarHeight + bottomSafe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          MediaQuery.removePadding(
            context: context,
            removeTop: false,
            removeBottom: true,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Логотип
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: false,
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

                // Отступ после логотипа
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                SliverPadding(
                  padding: EdgeInsets.only(bottom: listBottomPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      // Боковые отступы 16
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Текст "Для сна"
                            Text(
                              s.musicForSleep,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xFF282828),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Картинки для сна
                            SizedBox(
                              height: 240,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5, // Примерное количество, можно изменить
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (_, i) => Container(
                                  width: 164,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[300],
                                  ),
                                  // TODO: Заменить на реальные изображения
                                  child: const Center(
                                    child: Icon(Icons.image, size: 48),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Текст "Для вдохновения"
                            Text(
                              s.musicForInspiration,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xFF282828),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Картинки для вдохновения
                            SizedBox(
                              height: 240,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5, // Примерное количество, можно изменить
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (_, i) => Container(
                                  width: 164,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[300],
                                  ),
                                  // TODO: Заменить на реальные изображения
                                  child: const Center(
                                    child: Icon(Icons.image, size: 48),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Текст "Для расслабления"
                            Text(
                              s.musicForRelaxation,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Color(0xFF282828),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Картинки для расслабления
                            SizedBox(
                              height: 240,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5, // Примерное количество, можно изменить
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (_, i) => Container(
                                  width: 164,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[300],
                                  ),
                                  // TODO: Заменить на реальные изображения
                                  child: const Center(
                                    child: Icon(Icons.image, size: 48),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // BottomNavBar
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: BottomNavBar(index: 2, lang: _lang, repo: _repo),
            ),
          ),
        ],
      ),
    );
  }
}

