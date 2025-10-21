import 'package:supabase_flutter/supabase_flutter.dart';
import 'models.dart';

class HomeRepo {
  final SupabaseClient _sb;
  HomeRepo(this._sb);

  // язык: 'ru' | 'en' | 'es'
  Future<List<HeroSlide>> getHeroSlides(String lang) async {
    final res = await _sb
        .from('home_hero_slides')
        .select('''
          id,image_url,height_px,corner_radius_px,sort_index,
          i18n:home_hero_slides_i18n!inner(
            top_badge_label,top_badge_bg,left_chip_label,left_chip_bg,title,subtitle,language
          )
        ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('sort_index');

    final list = (res as List).map((e) {
      final i = (e['i18n'] as List).first;
      return HeroSlide(
        id: e['id'] as String,
        imageUrl: e['image_url'] as String,
        heightPx: (e['height_px'] ?? 200) as int,
        radiusPx: (e['corner_radius_px'] ?? 30) as int,
        sortIndex: (e['sort_index'] ?? 1) as int,
        topBadgeLabel: (i['top_badge_label'] ?? '') as String,
        topBadgeBg: (i['top_badge_bg'] ?? '#33A6FF') as String,
        leftChipLabel: (i['left_chip_label'] ?? '') as String,
        leftChipBg: (i['left_chip_bg'] ?? '#AB7AFF') as String,
        title: (i['title'] ?? '') as String,
        subtitle: (i['subtitle'] ?? '') as String,
      );
    }).toList();

    return list;
  }

  Future<List<DailyReco>> getDailyRecos(String lang) async {
    final res = await _sb
        .from('daily_recos')
        .select('''
          id,image_url,duration_minutes,sort_index,
          i18n:daily_recos_i18n!inner(title,description,language)
        ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('sort_index');

    return (res as List).map((e) {
      final i = (e['i18n'] as List).first;
      return DailyReco(
        id: e['id'] as String,
        imageUrl: e['image_url'] as String,
        durationMinutes: (e['duration_minutes'] ?? 0) as int,
        sortIndex: (e['sort_index'] ?? 1) as int,
        title: (i['title'] ?? '') as String,
        description: (i['description'] ?? '') as String,
      );
    }).toList();
  }

  Future<List<ForYouItem>> getForYou(String lang) async {
    final res = await _sb
        .from('for_you_items')
        .select('''
          id,image_url,tag_bg,sort_index,
          i18n:for_you_items_i18n!inner(title,description,tag_label,language)
        ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('sort_index');

    return (res as List).map((e) {
      final i = (e['i18n'] as List).first;
      return ForYouItem(
        id: e['id'] as String,
        imageUrl: e['image_url'] as String,
        tagBg: (e['tag_bg'] ?? '#33AB45') as String,
        sortIndex: (e['sort_index'] ?? 1) as int,
        title: (i['title'] ?? '') as String,
        description: (i['description'] ?? '') as String,
        tagLabel: (i['tag_label'] ?? '') as String,
      );
    }).toList();
  }

  Future<List<ArticleItem>> getArticles(String lang) async {
    final res = await _sb
        .from('articles')
        .select('''
          id,image_url,published_at,sort_index,
          i18n:articles_i18n!inner(title,summary,language)
        ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('sort_index')
        .order('published_at', ascending: false);

    return (res as List).map((e) {
      final i = (e['i18n'] as List).first;
      return ArticleItem(
        id: e['id'] as String,
        imageUrl: e['image_url'] as String,
        publishedAt: DateTime.parse(e['published_at'] as String),
        sortIndex: (e['sort_index'] ?? 1) as int,
        title: (i['title'] ?? '') as String,
        summary: (i['summary'] ?? '') as String,
      );
    }).toList();
  }
}