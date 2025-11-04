import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../settings/models.dart';

/// Элемент ежедневных рекомендаций
class DailyTile extends StatelessWidget {
  final DailyReco item;

  const DailyTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Картинка
        Container(
          width: 100,
          height: 80,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Текстовый блок
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle,
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.description,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.hourglass_empty, size: 14, color: AppColors.primaryDark),
                  const SizedBox(width: 4),
                  Text(
                    '${item.durationMinutes} минут',
                    style: AppTextStyles.meta,
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

