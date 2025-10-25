import 'package:flutter/material.dart';
import '../home/home_repo.dart';
import '../models.dart';
import '../../generated/l10n.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final HomeRepo repo;
  final String lang;
  final String programId;          // это id слайда/программы
  final ProgramDetails? preload;   // можно передать превью (картинка/заголовок)

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
      final full = await widget.repo.getProgramById(widget.lang, widget.programId);
      if (!mounted) return;
      setState(() => _data = full);
      // просмотры — без ожидания UI
      // ignore: unawaited_futures
      widget.repo.incProgramView(widget.programId);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final s = S.of(context);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${s.minShort}';
    if (diff.inHours < 24) return '${diff.inHours} ${s.hourShort}';
    return '${diff.inDays} ${s.dayShort}';
  }

  @override
  Widget build(BuildContext context) {
    final a = _data;

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
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
                  ),
                  title: SizedBox(
                    width: 48,
                    height: 50,
                    child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
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
                            size: 24,
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

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Мета (просмотры / комментарии / давность)
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
                          a?.publishedAt != null ? _timeAgo(a!.publishedAt!) : '',
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
              ],
            ),
    );
  }
}