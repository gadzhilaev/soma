import 'package:flutter/material.dart';
import 'home_repo.dart';
import 'models.dart';
import '../generated/l10n.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final HomeRepo repo;
  final String lang;
  final String articleId;
  final ArticleItem? preload; // чтобы сразу что-то показать

  const ArticleDetailsScreen({
    super.key,
    required this.repo,
    required this.lang,
    required this.articleId,
    this.preload,
  });

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  ArticleItem? _data; // с content
  bool _loading = true;
  bool _fav = false; // состояние звезды

  @override
  void initState() {
    super.initState();
    _data = widget.preload;
    _load();
  }

  Future<void> _load() async {
    try {
      final full = await widget.repo.getArticleById(widget.lang, widget.articleId);
      if (!mounted) return;
      setState(() => _data = full);
      // увеличим просмотры (без ожидания интерфейс)
      // ignore: unawaited_futures
      widget.repo.incArticleView(widget.articleId);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${S.of(context).minShort}';
    if (diff.inHours < 24) return '${diff.inHours} ${S.of(context).hourShort}';
    return '${diff.inDays} ${S.of(context).dayShort}';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final a = _data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
        ),
        title: SizedBox(
          width: 48, height: 50,
          child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => setState(() => _fav = !_fav),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: _fav ? const Color(0xFFFFD580) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD580), width: 1.5),
                ),
                child: Icon(
                  _fav ? Icons.star : Icons.star_border,
                  size: 20,
                  color: _fav ? Colors.white : const Color(0xFFFFD580),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading && a == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // картинка
                  if (a?.imageUrl.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            a!.imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // заголовок (верхний регистр, 18, 150%)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        (a?.title ?? '').toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          height: 1.5,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // контент (по ТЗ те же параметры; если хочешь обычный текст — поменяй стиль)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        (a?.content ?? ''),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // хэштеги в одну строку, отступы между 16, цвет #726AFF, medium 14
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 24,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: (a?.tags ?? const <String>[]).map((t) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  '#${t}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 17 / 14,
                                    color: Color(0xFF726AFF),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Мета: просмотры → комменты → время
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility, size: 14, color: Color(0xFF726AFF)),
                          const SizedBox(width: 4),
                          Text(
                            '${a?.views ?? 0}',
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
                            '${a?.comments ?? 0}',
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
                            a != null ? _timeAgo(a.publishedAt) : '',
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
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // "Комментарии"
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        s.articleComments,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1.4,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),

                  // пока пусто
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // "Оставить комментарий"
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        s.articleLeaveComment,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 1.4,
                          color: Color(0xFF282828),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
      ),
    );
  }
}