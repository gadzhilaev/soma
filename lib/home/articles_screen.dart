import 'package:flutter/material.dart';
import '../home/home_repo.dart';
import '../home/models.dart';

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
      final arts = await widget.repo.getArticlesByTag(
        widget.lang,
        tag: firstTag,
      );
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
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин';
    if (diff.inHours < 24) return '${diff.inHours} ч';
    return '${diff.inDays} дн';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // тот же фон
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
        ),
        title: SizedBox(
          width: 48,
          height: 50,
          child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // после логотипа — отступ 16
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // ХЭШТЕГИ (отступы по бокам 16, высота 24, стили строго по ТЗ)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _TagsWrap(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: _articles.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 20), // между постами 20
                      itemBuilder: (_, i) {
                        final a = _articles[i];
                        return GestureDetector(
                          onTap: () => widget.repo.incArticleView(a.id),
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

                              // Мета: просмотры → комментарии → время
                              Row(
                                children: [
                                  const Icon(
                                    Icons.visibility,
                                    size: 14,
                                    color: Color(0xFF726AFF),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${a.views}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500, // Medium
                                      fontSize: 14,
                                      height: 1.0, // line-height 100%
                                      color: Color(0xFF717171),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Icon(
                                    Icons.chat,
                                    size: 14,
                                    color: Color(0xFF726AFF),
                                  ),
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
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Color(0xFF726AFF),
                                  ),
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
      ),
    );
  }
}

// чипы-хэштеги (высота 24, между 8, выбранный: #766DFF/белый, невыбранный: #F1F1F1/#A3A3A3)
class _TagsWrap extends StatelessWidget {
  final List<String> tags;
  final String selected;
  final ValueChanged<String> onSelect;
  const _TagsWrap({
    required this.tags,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // между контейнерами 8
      runSpacing: 8,
      children: tags.map((t) {
        final isSel = t == selected;
        return GestureDetector(
          onTap: () => onSelect(t),
          child: Container(
            height: 24,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ), // ширина по тексту
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
                height: 1.0, // line-height 100%
                letterSpacing: 0,
                color: isSel
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFFA3A3A3),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
