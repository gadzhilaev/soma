class DailyReco {
  final String id;
  final String imageUrl;
  final int durationMinutes;
  final int sortIndex;
  final String title;
  final String description;

  DailyReco({
    required this.id,
    required this.imageUrl,
    required this.durationMinutes,
    required this.sortIndex,
    required this.title,
    required this.description,
  });
}

class ForYouItem {
  final String id;
  final String imageUrl;
  final String tagBg;
  final int sortIndex;
  final String title;
  final String description;
  final String tagLabel;

  ForYouItem({
    required this.id,
    required this.imageUrl,
    required this.tagBg,
    required this.sortIndex,
    required this.title,
    required this.description,
    required this.tagLabel,
  });
}

class ArticleItem {
  final String id;
  final String imageUrl;
  final DateTime publishedAt;
  final String title;
  final String summary;
  final List<String> tags;
  final int views;
  final int comments;

  /// Полный текст статьи. Может быть `null`, если загружали список без контента.
  final String? content;

  ArticleItem({
    required this.id,
    required this.imageUrl,
    required this.publishedAt,
    required this.title,
    required this.summary,
    required this.tags,
    required this.views,
    required this.comments,
    this.content, // ← добавили
  });

  factory ArticleItem.fromJson(Map<String, dynamic> j) => ArticleItem(
    id: j['id'] as String,
    imageUrl: j['image_url'] as String,
    publishedAt: DateTime.parse(j['published_at'] as String),
    title: j['title'] as String,
    summary: j['summary'] as String,
    tags: (j['tags'] as List<dynamic>).cast<String>(),
    views: (j['views_count'] as num).toInt(),
    comments: (j['comments_count'] as num).toInt(),
    content: j['content'] as String?, // если будет в JSON — подхватится
  );

  ArticleItem copyWith({
    String? id,
    String? imageUrl,
    DateTime? publishedAt,
    String? title,
    String? summary,
    List<String>? tags,
    int? views,
    int? comments,
    String? content,
  }) {
    return ArticleItem(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      tags: tags ?? this.tags,
      views: views ?? this.views,
      comments: comments ?? this.comments,
      content: content ?? this.content,
    );
  }
}

class HeroSlide {
  final String id;
  final String imageUrl;
  final int heightPx;
  final int radiusPx;
  final int sortIndex;

  // i18n
  final String topBadgeLabel;
  final String topBadgeBg;
  final String leftChipLabel;
  final String leftChipBg;
  final String title;
  final String subtitle;

  // 🆕 для «НОВОЕ»
  final DateTime updatedAt;

  HeroSlide({
    required this.id,
    required this.imageUrl,
    required this.heightPx,
    required this.radiusPx,
    required this.sortIndex,
    required this.topBadgeLabel,
    required this.topBadgeBg,
    required this.leftChipLabel,
    required this.leftChipBg,
    required this.title,
    required this.subtitle,
    required this.updatedAt, // 🆕
  });
}
