import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../settings/models.dart';
import '../../settings/repo.dart';
import '../../windows/article/article_details_screen.dart';

/// Элемент статьи
class ArticleTile extends StatelessWidget {
  final ArticleItem item;
  final HomeRepo? repo;
  final String? lang;

  const ArticleTile({
    super.key,
    required this.item,
    this.repo,
    this.lang,
  });

  String _timeAgo() {
    final diff = DateTime.now().difference(item.publishedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} минут назад';
    if (diff.inHours < 24) return '${diff.inHours} часов назад';
    return '${diff.inDays} дн. назад';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (repo != null && lang != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticleDetailsScreen(
                repo: repo!,
                lang: lang!,
                articleId: item.id,
                preload: item,
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title.toUpperCase(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            item.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.description,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.primaryDark),
              const SizedBox(width: 4),
              Text(
                _timeAgo(),
                style: AppTextStyles.meta,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

