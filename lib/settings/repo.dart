import 'package:supabase_flutter/supabase_flutter.dart';
import 'models.dart';

class HomeRepo {
  final SupabaseClient _sb;
  HomeRepo(this._sb);

  // ===== HERO =====
  Future<List<HeroSlide>> getHeroSlides(String lang) async {
    final res = await _sb
        .from('home_hero_slides')
        .select('''
      id,
      image_url,
      height_px,
      corner_radius_px,
      sort_index,
      updated_at,
      category_key,
      i18n:home_hero_slides_i18n!inner(
        top_badge_label,
        top_badge_bg,
        left_chip_label,
        left_chip_bg,
        title,
        subtitle,
        language
      )
    ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('sort_index');

    return (res as List).map((e) {
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
        updatedAt: DateTime.parse(e['updated_at'] as String),
        categoryKey: e['category_key'] as String?,
      );
    }).toList();
  }

  // ===== DAILY =====
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

  // ===== FOR YOU =====
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

  // ===== ARTICLES (главный экран: последние 3) =====
  Future<List<ArticleItem>> getArticles(String lang) async {
    final res = await _sb
        .from('articles')
        .select('''
          id,image_url,published_at,views_count,comments_count,
          i18n:articles_i18n!inner(title,summary,tags,language)
        ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('published_at', ascending: false)
        .limit(3);

    return _mapArticlesFromMainSelect(res as List, lang);
  }

  // ===== СПИСОК ВСЕХ ТЕГОВ (по языку) =====
  Future<List<String>> getArticleTags(String lang) async {
    final res = await _sb
        .from('articles_i18n')
        .select('tags')
        .eq('language', lang);

    final set = <String>{};
    for (final row in (res as List)) {
      final tags = (row['tags'] as List?)?.cast<String>() ?? const <String>[];
      set.addAll(tags.where((t) => t.trim().isNotEmpty));
    }
    final list = set.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  // ===== СТАТЬИ ПО ТЕГУ (экран «Больше статей») =====
  Future<List<ArticleItem>> getArticlesByTag(
    String lang, {
    required String tag,
  }) async {
    if (tag.isEmpty) {
      // если тега нет — вернём просто все статьи этого языка
      final all = await _sb
          .from('articles')
          .select('''
            id,image_url,published_at,views_count,comments_count,
            i18n:articles_i18n!inner(title,summary,tags,language)
          ''')
          .eq('is_active', true)
          .eq('i18n.language', lang)
          .order('published_at', ascending: false);
      return _mapArticlesFromMainSelect(all as List, lang);
    }

    // 1) найдём article_id по языку и наличию тега в массиве tags
    final i18nRows = await _sb
        .from('articles_i18n')
        .select('article_id')
        .eq('language', lang)
        .contains('tags', [tag]); // PostgREST array contains

    final ids = (i18nRows as List)
        .map((e) => (e['article_id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toList();

    if (ids.isEmpty) return <ArticleItem>[];

    // 2) подтянем статьи + i18n для этого языка
    final byIds = await _sb
        .from('articles')
        .select('''
          id,image_url,published_at,views_count,comments_count,
          i18n:articles_i18n!inner(title,summary,tags,language)
        ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .inFilter('id', ids)
        .order('published_at', ascending: false);

    return _mapArticlesFromMainSelect(byIds as List, lang);
  }

  // =====+1 VIEW =====
  Future<void> incArticleView(String articleId) async {
    try {
      // у тебя функция называется article_inc_view(p_article uuid)
      await _sb.rpc('article_inc_view', params: {'p_article': articleId});
    } catch (_) {
      // без падения UI
    }
  }

  // ===== helper mapper =====
  List<ArticleItem> _mapArticlesFromMainSelect(List rows, String lang) {
    return rows.map((e) {
      final i = (e['i18n'] as List).first;
      final tags = (i['tags'] as List?)?.cast<String>() ?? const <String>[];
      return ArticleItem(
        id: (e['id'] ?? '') as String,
        imageUrl: (e['image_url'] ?? '') as String,
        publishedAt: DateTime.parse(e['published_at'] as String),
        title: (i['title'] ?? '') as String,
        summary: (i['summary'] ?? '') as String,
        tags: tags,
        views: (e['views_count'] ?? 0) as int,
        comments: (e['comments_count'] ?? 0) as int,
        // content: null по умолчанию
      );
    }).toList();
  }

  // одна статья с контентом
  Future<ArticleItem> getArticleById(String lang, String id) async {
    final res = await _sb
        .from('articles')
        .select('''
        id,image_url,published_at,views_count,comments_count,
        i18n:articles_i18n!inner(title,summary,content,tags,language)
      ''')
        .eq('id', id)
        .eq('i18n.language', lang)
        .limit(1);

    final row = (res as List).first;
    final i = (row['i18n'] as List).first;

    return ArticleItem(
      id: row['id'] as String,
      imageUrl: (row['image_url'] ?? '') as String,
      publishedAt: DateTime.parse(row['published_at'] as String),
      title: (i['title'] ?? '') as String,
      summary: (i['summary'] ?? '') as String,
      tags: (i['tags'] as List?)?.cast<String>() ?? const <String>[],
      views: (row['views_count'] ?? 0) as int,
      comments: (row['comments_count'] ?? 0) as int,
      content: (i['content'] ?? '') as String, // ← сюда кладём полный текст
    );
  }

  Future<List<ProgramCategory>> getProgramCategories(String lang) async {
    final res = await _sb
        .from('program_categories')
        .select('''
        id,key,color_hex,sort_index,
        i18n:program_categories_i18n!inner(label,language)
      ''')
        .eq('is_active', true)
        .eq('i18n.language', lang)
        .order('sort_index');

    return (res as List).map((e) {
      final i = (e['i18n'] as List).first;
      return ProgramCategory(
        id: e['id'] as String,
        key: e['key'] as String,
        colorHex: (e['color_hex'] ?? '#AB7AFF') as String,
        sortIndex: (e['sort_index'] ?? 1) as int,
        label: (i['label'] ?? '') as String,
      );
    }).toList();
  }

  // Модель тянется из models.dart (см. ниже)
  Future<ProgramDetails> getProgramById(String lang, String id) async {
    // Основная программа
    final res = await _sb
        .from('home_hero_slides')
        .select('''
        id,image_url,published_at,views_count,comments_count,
        i18n:home_hero_slides_i18n!inner(title,content,language)
      ''')
        .eq('id', id)
        .eq('i18n.language', lang)
        .limit(1);

    if (res.isEmpty) throw Exception('Program not found');
    final row = (res as List).first;
    final i = (row['i18n'] as List).first;

    // 🧠 Загружаем шаги (если есть)
    final stepsRes = await _sb
        .from('program_steps')
        .select('''
        id,image_url,sort_index,
        i18n:program_steps_i18n!inner(title,description,language)
      ''')
        .eq('program_id', id)
        .eq('i18n.language', lang)
        .order('sort_index');
    final steps = (stepsRes as List?)?.map((e) {
      final i18n = (e['i18n'] as List).first;
      return ProgramStep(
        id: e['id'] as String,
        imageUrl: e['image_url'] as String,
        title: i18n['title'] as String,
        description: i18n['description'] as String,
      );
    }).toList();

    return ProgramDetails(
      id: row['id'] as String,
      imageUrl: (row['image_url'] ?? '') as String,
      title: (i['title'] ?? '') as String,
      content: (i['content'] ?? '') as String?,
      views: (row['views_count'] ?? 0) as int,
      comments: (row['comments_count'] ?? 0) as int,
      publishedAt: row['published_at'] != null
          ? DateTime.parse(row['published_at'] as String)
          : null,
      steps: steps,
    );
  }

  Future<void> incProgramView(String programId) async {
    try {
      await _sb.rpc('program_inc_view', params: {'p_program': programId});
    } catch (_) {}
  }

  // ===== COMMENTS =====
  Future<List<AppComment>> getComments({
    required String targetType, // 'article' | 'program'
    required String targetId,
    int limit = 20,
    String? cursorIso, // пагинация по дате: загрузить СТАРШЕ этой даты
  }) async {
    var q = _sb
        .from('app_comments')
        .select()
        .eq('target_type', targetType)
        .eq('target_id', targetId);

    if (cursorIso != null && cursorIso.isNotEmpty) {
      q = q.lt('inserted_at', cursorIso);
    }

    final res = await q.order('inserted_at', ascending: false).limit(limit);
    return (res as List)
        .map((e) => AppComment.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addComment({
    required String targetType, // 'article' | 'program'
    required String targetId,
    required String userName,
    String? userAvatar,
    required String body,
  }) async {
    await _sb.from('app_comments').insert({
      'target_type': targetType,
      'target_id': targetId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'body': body,
    });
  }
}
