import 'package:flutter/material.dart';
import '../windows/home/home_repo.dart';
import 'comments.dart';

class LeaveCommentBox extends StatefulWidget {
  final HomeRepo repo;
  final CommentTarget target;
  final String targetId;

  const LeaveCommentBox({
    super.key,
    required this.repo,
    required this.target,
    required this.targetId,
  });

  @override
  State<LeaveCommentBox> createState() => _LeaveCommentBoxState();
}

class _LeaveCommentBoxState extends State<LeaveCommentBox> {
  final _controller = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || text.length < 12) {
      _showValidationDialog();
      return;
    }

    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await widget.repo.addComment(
        targetType: widget.target == CommentTarget.article
            ? 'article'
            : 'program',
        targetId: widget.targetId,
        userName: 'Гость',
        userAvatar: null,
        body: text,
      );

      if (!mounted) return;
      _controller.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Комментарий отправлен')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            // ← жёсткий размер
            width: 280,
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ← не растягиваемся
                children: [
                  const Text(
                    'Внимание!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 22 / 18,
                      letterSpacing: -0.41,
                      color: Color(0xFF282828),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Сообщение не может быть пустым или содержать менее 12 символов в своем теле',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF9D9D9D),
                    ),
                  ),
                  const Spacer(), // В ЭТОМ варианте можно оставить, т.к. высота фиксированная
                  SizedBox(
                    width: 116,
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'ОК',
                        style: TextStyle(
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
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              'Введите сообщение',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.0,
                color: Color(0xFFC5C5C5),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Поле ввода комментария
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFF1F1F1),
            ),
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
            alignment: Alignment.topLeft,
            child: TextField(
              controller: _controller,
              maxLines: null,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.3,
                color: Color(0xFF282828),
              ),
              decoration: const InputDecoration(
                hintText: 'Ваше сообщение',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.3,
                  color: Color(0xFFC5C5C5),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Кнопка "Отправить"
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD580),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.zero, // чтобы не расширяла
              ),
              onPressed: _busy ? null : _send,
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'ОТПРАВИТЬ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 4 / 100,
                        height: 1.0,
                        color: Color(0xFF59523A),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
