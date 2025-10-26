import 'package:flutter/material.dart';
import '../home/home_repo.dart';
import '../models.dart';
import '../../generated/l10n.dart';
import 'article_details_screen.dart';

class ArticlesScreen extends StatefulWidget {
  final String lang;
  final HomeRepo repo;
  const ArticlesScreen({super.key, required this.lang, required this.repo});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<String> _tags = [];
  String _selectedTag = '';
  List<ArticleItem> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final tags = await widget.repo.getArticleTags(widget.lang);
      final firstTag = tags.isNotEmpty ? tags.first : '';
      final arts = await widget.repo.getArticlesByTag(widget.lang, tag: firstTag);
      if (!mounted) return;
      setState(() {
        _tags = tags;
        _selectedTag = firstTag;
        _articles = arts;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickTag(String tag) async {
    if (tag == _selectedTag) return;
    setState(() {
      _selectedTag = tag;
      _loading = true;
    });
    try {
      final arts = await widget.repo.getArticlesByTag(widget.lang, tag: tag);
      if (!mounted) return;
      setState(() => _articles = arts);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final s = S.of(context);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${s.minShort} ${s.ago}';
    if (diff.inHours < 24) return '${diff.inHours} ${s.hourShort} ${s.ago}';
    return '${diff.inDays} ${s.dayShort} ${s.ago}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : CustomScrollView(
              slivers: [
                // ===== СКРЫВАЕМЫЙ ПРИ СКРОЛЛЕ APP BAR =====
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: false,   // 👈 не закреплён — уезжает при скролле вниз
                  floating: false,
                  snap: false,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
                  ),
                  title: SizedBox(
                    width: 48,
                    height: 50,
                    child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
                  ),
                ),

                // после логотипа — отступ 16
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ХЭШТЕГИ (одна строка, высота 24, между 8)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _TagsRow(
                      tags: _tags,
                      selected: _selectedTag,
                      onSelect: _pickTag,
                    ),
                  ),
                ),

                // отступ 24 после чипов
                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Список статей по выбранному тегу
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  sliver: SliverList.separated(
                    itemCount: _articles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (_, i) {
                      final a = _articles[i];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailsScreen(
                              repo: widget.repo,
                              lang: widget.lang,
                              articleId: a.id,
                              preload: a,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                a.imageUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              a.title.toUpperCase(),
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
                              a.summary,
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
                                const Icon(Icons.visibility, size: 14, color: Color(0xFF726AFF)),
                                const SizedBox(width: 4),
                                Text(
                                  '${a.views}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.0,
                                    color: Color(0xFF717171),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Icon(Icons.chat, size: 14, color: Color(0xFF726AFF)),
                                const SizedBox(width: 4),
                                Text(
                                  '${a.comments}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.0,
                                    color: Color(0xFF717171),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Icon(Icons.calendar_today, size: 14, color: Color(0xFF726AFF)),
                                const SizedBox(width: 4),
                                Text(
                                  _timeAgo(a.publishedAt),
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
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
    );
  }
}

// чипы-хэштеги (высота 24, между 8, выбранный: #766DFF/белый, невыбранный: #F1F1F1/#A3A3A3)
class _TagsRow extends StatelessWidget {
  final List<String> tags;
  final String selected;
  final ValueChanged<String> onSelect;
  const _TagsRow({
    required this.tags,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final t = tags[i];
          final isSel = t == selected;
          return GestureDetector(
            onTap: () => onSelect(t),
            child: Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isSel ? const Color(0xFF766DFF) : const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(1000),
              ),
              alignment: Alignment.center,
              child: Text(
                '#${t.toUpperCase()}',
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 1.0,
                  color: isSel ? const Color(0xFFFFFFFF) : const Color(0xFFA3A3A3),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}