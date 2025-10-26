import 'package:flutter/material.dart';
import '../../settings/repo.dart';
import '../../settings/models.dart';
import '../../widgets/comments.dart';
import '../../generated/l10n.dart';
import '../../widgets/leave_comment_box.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final HomeRepo repo;
  final String lang;
  final String programId; // это id слайда/программы
  final ProgramDetails? preload; // можно передать превью (картинка/заголовок)

  const ProgramDetailsScreen({
    super.key,
    required this.repo,
    required this.lang,
    required this.programId,
    this.preload,
  });

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  ProgramDetails? _data; // с content
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
      final full = await widget.repo.getProgramById(
        widget.lang,
        widget.programId,
      );
      if (!mounted) return;
      setState(() => _data = full);
      // просмотры — без ожидания UI
      // ignore: unawaited_futures
      widget.repo.incProgramView(widget.programId);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = _data;
    final s = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading && a == null
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: false,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF282828),
                    ),
                  ),
                  title: SizedBox(
                    width: 48,
                    height: 50,
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(32, 32)),
                          splashRadius: 32,
                          onPressed: () => setState(() => _fav = !_fav),
                          icon: Icon(
                            _fav ? Icons.star : Icons.star_border,
                            size: 32,
                            color: const Color(0xFFFFD580),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                if ((a?.imageUrl ?? '').isNotEmpty)
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

                // Заголовок
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

                // Контент
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

                // Если есть шаги — показываем их
                if ((a?.steps ?? []).isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          for (int i = 0; i < a!.steps!.length; i++) ...[
                            Text(
                              s.stepN(i + 1), // ← локализация "Шаг N"
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 22 / 14, // 22px line-height
                                letterSpacing: -0.41,
                                color: Color(0xFF282828),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    a.steps![i].imageUrl,
                                    width: 113,
                                    height: 116,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a.steps![i].title.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          height: 1.4, // 140%
                                          color: Color(0xFF282828),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        a.steps![i].description,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          height: 1.5, // 150%
                                          color: Color(0xFF717171),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.play_circle,
                                            size: 24,
                                            color: Color(0xFF766DFF),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            s.listen, // ← локализовано
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              height: 19 / 14, // 19px
                                              color: Color(0xFF766DFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (i != a.steps!.length - 1)
                              const SizedBox(height: 20), // между шагами 20
                          ],
                        ],
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Мета (просмотры / комментарии / давность)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: Color(0xFF726AFF),
                        ),
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
                        const Icon(
                          Icons.chat,
                          size: 14,
                          color: Color(0xFF726AFF),
                        ),
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
                      ],
                    ),
                  ),
                ),

                // Если шагов нет — одна большая кнопка "Слушать" ПОСЛЕ меты
                if ((a?.steps ?? []).isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 68,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFFFD580,
                                ), // FFD580
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.play_circle,
                                    size: 24,
                                    color: Color(0xFF59523A),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    s.listenUpper, // ← локализовано
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 1.0, // 100%
                                      letterSpacing: 0.48, // 4% от 12px = 0.48
                                      color: Color(0xFF59523A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // «Комментарии»
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CommentsSection(
                      repo: widget.repo,
                      target: CommentTarget.program,
                      targetId: widget.programId,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // «Оставить комментарий»
                SliverToBoxAdapter(
                  child: LeaveCommentBox(
                    repo: widget.repo,
                    target: CommentTarget.program,
                    targetId: widget.programId,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
    );
  }
}
