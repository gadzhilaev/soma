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
  });
}

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
  final int sortIndex;
  final String title;
  final String summary;

  ArticleItem({
    required this.id,
    required this.imageUrl,
    required this.publishedAt,
    required this.sortIndex,
    required this.title,
    required this.summary,
  });
}