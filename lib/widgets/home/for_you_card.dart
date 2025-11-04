import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../settings/models.dart';
import 'capsule.dart';

/// Карточка "Для вас"
class ForYouCard extends StatelessWidget {
  final ForYouItem item;

  const ForYouCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 240,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final textMaxWidth = constraints.maxWidth - 16;
          final titlePainter = TextPainter(
            text: TextSpan(
              text: item.title.toUpperCase(),
              style: AppTextStyles.cardTitleWhite,
            ),
            textDirection: TextDirection.ltr,
            maxLines: 2,
          )..layout(maxWidth: textMaxWidth);

          final computedLines = (titlePainter.size.height / (14 * 1.1))
              .ceil()
              .clamp(1, 2);
          final titleTop = (computedLines > 1) ? 110.0 : 122.0;
          final titleHeightPx = 14 * 1.1 * computedLines;
          final descTop = titleTop + titleHeightPx + 4;

          return Stack(
            children: [
              // Затемнение для читаемости текста
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
              Positioned(
                left: 8,
                right: 8,
                top: titleTop,
                child: Text(
                  item.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitleWhite,
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: descTop,
                child: Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.capsuleSmall,
                ),
              ),
              Positioned(
                left: 8,
                bottom: 12,
                child: Capsule(
                  width: 89,
                  height: 24,
                  bg: AppColors.fromHex(item.tagBg),
                  text: item.tagLabel.toUpperCase(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

