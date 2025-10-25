import 'package:flutter/material.dart';
import '../windows/home/home_repo.dart';
import '../windows/models.dart';

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
  bool _loadingMore = false;
  String? _cursorIso;

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
        _cursorIso = res.isNotEmpty ? res.last.createdAt.toIso8601String() : null;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _cursorIso == null) return;
    setState(() => _loadingMore = true);
    try {
      final res = await widget.repo.getComments(
        targetType: _targetTypeStr,
        targetId: widget.targetId,
        limit: 20,
        cursorIso: _cursorIso,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(res);
        _cursorIso = res.isNotEmpty ? res.last.createdAt.toIso8601String() : null;
      });
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} минут назад';
    if (diff.inHours < 24) return '${diff.inHours} часов назад';
    return '${diff.inDays} дн. назад';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Комментарии отсутствуют',
          style: TextStyle(
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

    return Column(
      children: [
        for (int i = 0; i < _items.length; i++) ...[
          _CommentTile(
            c: _items[i],
            timeAgo: _timeAgo(_items[i].createdAt),
            onReport: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Спасибо! Мы рассмотрим жалобу.')),
              );
            },
          ),
          if (i != _items.length - 1) const SizedBox(height: 20),
        ],
        if (_cursorIso != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _loadMore,
              child: _loadingMore
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Показать ещё'),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    child: const Text(
                      'Пожаловаться',
                      style: TextStyle(
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
          ),
        ),
      ],
    );
  }
}