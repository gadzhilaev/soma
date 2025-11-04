import 'package:flutter/material.dart';
import '../../core/app_text_styles.dart';

/// Капсула/бейдж для отображения меток
class Capsule extends StatelessWidget {
  final double width;
  final double height;
  final Color bg;
  final String text;

  const Capsule({
    super.key,
    required this.width,
    required this.height,
    required this.bg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(1000),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.capsule,
      ),
    );
  }
}

