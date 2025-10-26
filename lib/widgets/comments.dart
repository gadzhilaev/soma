import 'package:flutter/material.dart';
import '../windows/home/home_repo.dart';
import '../windows/models.dart';
import '../../generated/l10n.dart';

enum CommentTarget { article, program }

class CommentsSection extends StatefulWidget {
  final HomeRepo repo;
  final CommentTarget target;
  final String targetId;

  const CommentsSection({
    super.key,
    required this.repo,
    required this.target,
    required this.targetId,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final _items = <AppComment>[];
  bool _loading = true;
  int _visibleCount = 3;

  String get _targetTypeStr =>
      widget.target == CommentTarget.article ? 'article' : 'program';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await widget.repo.getComments(
        targetType: _targetTypeStr,
        targetId: widget.targetId,
        limit: 20,
      );
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(res);
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMore() {
    setState(() {
      _visibleCount = (_visibleCount + 3).clamp(
        0,
        _items.length,
      ); // +3, но не больше длины списка
    });
  }

  String _timeAgo(BuildContext context, DateTime dt) {
    final s = S.of(context);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${s.minShort} ${s.ago}';
    if (diff.inHours < 24) return '${diff.inHours} ${s.hourShort} ${s.ago}';
    return '${diff.inDays} ${s.dayShort} ${s.ago}';
  }

  void _showReportDialog(BuildContext context, AppComment c) {
    final s = S.of(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          width: 280,
          height: 180,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.reportTitle, // "Внимание!"
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    height: 22 / 18,
                    letterSpacing: -0.41,
                    color: Color(0xFF282828),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  s.reportBody,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF9D9D9D),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(
                      width: 132,
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD580),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).complaintThanks)),
                          );
                        },
                        child: Text(
                          s.reportSubmit, // "ПОЖАЛОВАТЬСЯ"
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.0,
                            letterSpacing: 0.04,
                            color: Color(0xFF59523A),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F1F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          s.cancel.toUpperCase(), // локализованное "Отменить"
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.0,
                            letterSpacing: 0.04,
                            color: Color(0xFF59523A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          s.commentsEmpty, // "Комментарии отсутствуют"
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.4,
            color: Color(0xFF717171),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final visibleItems = _items.take(_visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < visibleItems.length; i++) ...[
          _CommentTile(
            c: visibleItems[i],
            timeAgo: _timeAgo(context, visibleItems[i].createdAt),
            onReport: () => _showReportDialog(context, visibleItems[i]),
          ),
          if (i != visibleItems.length - 1) const SizedBox(height: 20),
        ],
        if (_items.length > 3 && _visibleCount < _items.length) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _showMore,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF726AFF)),
              ),
              child: Text(
                s.showMore, // "Показать ещё"
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF726AFF),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final AppComment c;
  final String timeAgo;
  final VoidCallback onReport;

  const _CommentTile({
    required this.c,
    required this.timeAgo,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // аватарка сверху
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: c.userAvatar != null && c.userAvatar!.isNotEmpty
              ? Image.network(c.userAvatar!, width: 48, height: 48, fit: BoxFit.cover)
              : Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFFF1F1F1),
                  child: const Icon(Icons.person, color: Color(0xFFA3A3A3)),
                ),
        ),
        const SizedBox(height: 12),

        Text(
          c.userName,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.0,
            color: Color(0xFF282828),
          ),
        ),
        const SizedBox(height: 8),

        Text(
          c.body,
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
            const Icon(Icons.calendar_today, size: 14, color: Color(0xFF726AFF)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                timeAgo,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.0,
                  color: Color(0xFF717171),
                ),
              ),
            ),
            GestureDetector(
              onTap: onReport,
              child: Text(
                s.report, // "Пожаловаться"
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 17 / 12,
                  color: Color(0xFFC3C3C3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
