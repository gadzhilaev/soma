import 'package:flutter/material.dart';
import '../../core/supabase.dart';
import '../../core/app_text_styles.dart';
import '../../generated/l10n.dart';
import '../../settings/repo.dart';
import '../../settings/models.dart';
import 'music_player_screen.dart';
import '../../widgets/bottom_nav.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late final HomeRepo _repo;
  String _lang = 'en';
  bool _loading = true;
  Map<String, List<MusicTrack>> _tracksByCategory = {};
  List<MusicCategory> _categories = [];

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
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final categories = await _repo.getMusicCategories(_lang);
      final tracks = await _repo.getAllMusicTracks(_lang);
      if (mounted) {
        setState(() {
          _categories = categories;
          _tracksByCategory = tracks;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).errorPrefix} $e')),
      );
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: RefreshIndicator(
              onRefresh: _load,
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
                  sliver: _loading
                      ? const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            // Боковые отступы 16
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int catIndex = 0;
                                      catIndex < _categories.length;
                                      catIndex++) ...[
                                    // Заголовок категории
                                    Text(
                                      _categories[catIndex].label,
                                      style: AppTextStyles.sectionTitle,
                                    ),
                                    const SizedBox(height: 20),

                                    // Картинки категории
                                    SizedBox(
                                      height: 240,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _tracksByCategory[
                                                    _categories[catIndex].key]!
                                                .length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (_, i) {
                                          final track = _tracksByCategory[
                                              _categories[catIndex].key]![i];
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      MusicPlayerScreen(
                                                    title: track.title,
                                                    imageUrl: track.imageUrl,
                                                    audioUrl: track.audioUrl,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: _MusicCard(track: track),
                                          );
                                        },
                                      ),
                                    ),

                                    if (catIndex < _categories.length - 1)
                                      const SizedBox(height: 32),
                                  ],

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

// Карточка музыки с названием и описанием
class _MusicCard extends StatelessWidget {
  final MusicTrack track;

  const _MusicCard({required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 240,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: track.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(track.imageUrl),
                fit: BoxFit.cover,
              )
            : null,
        color: track.imageUrl.isEmpty ? Colors.grey[300] : null,
      ),
      child: track.imageUrl.isEmpty
          ? const Center(child: Icon(Icons.image, size: 48))
          : Stack(
              children: [
                // Затемнение для читаемости текста (как в дизайне)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.3712, 0.9813],
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.0953825),
                            Color.fromRGBO(0, 0, 0, 0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Текст внутри картинки
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Название (сверху)
                      Text(
                        track.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.musicTitle,
                      ),
                      const SizedBox(height: 8),
                      // Описание (внизу)
                      Text(
                        track.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.musicDescription,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

