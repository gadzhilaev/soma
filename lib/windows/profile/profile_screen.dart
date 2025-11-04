import 'package:flutter/material.dart';
import '../../core/supabase.dart';
import '../../core/app_colors.dart';
import '../../generated/l10n.dart';
import '../../settings/repo.dart';
import '../../widgets/bottom_nav.dart';
import '../../onboarding/premium_screen.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final HomeRepo _repo;
  String _lang = 'en';
  bool _loading = true;
  String _userName = '';
  String? _avatarUrl;
  bool _isVip = false;
  bool _isAdmin = false;
  final int _notificationsCount = 0;

  @override
  void initState() {
    super.initState();
    _repo = HomeRepo(supa);
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final code = Localizations.localeOf(context).languageCode;
    const allowed = ['ru', 'en', 'es'];
    _lang = allowed.contains(code) ? code : 'en';
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final user = supa.auth.currentUser;
      if (user != null) {
        // Получаем данные пользователя из таблицы users
        final userRes = await supa
            .from('users')
            .select('name, photo, VIP, ADMIN')
            .eq('id', user.id)
            .maybeSingle();

        if (userRes != null) {
          setState(() {
            _userName = (userRes['name'] ?? '') as String;
            _avatarUrl = userRes['photo'] as String?;
            // Проверяем, что photo не пустая строка
            if (_avatarUrl != null && _avatarUrl!.isEmpty) {
              _avatarUrl = null;
            }
            _isVip = (userRes['VIP'] ?? false) as bool;
            // Проверяем админ статус из колонки ADMIN в таблице users
            _isAdmin = (userRes['ADMIN'] ?? false) as bool;
            // notifications_count не существует в таблице users, используем значение по умолчанию 0
          });
        } else {
          // Если пользователя нет в таблице, берем имя из auth
          setState(() {
            _userName = (user.userMetadata?['name'] ?? user.email ?? 'User') as String;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).errorPrefix} $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).profileLogout),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(S.of(context).profileLogout),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await supa.auth.signOut();
    if (!mounted) return;
    // Закрываем все экраны и возвращаемся к корню приложения
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    const double navBarHeight = 80.0;
    final double bottomSafe = MediaQuery.of(context).padding.bottom;
    final double listBottomPadding = navBarHeight + bottomSafe;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: _load,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: listBottomPadding),
                    sliver: _loading
                        ? const SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SliverList(
                            delegate: SliverChildListDelegate.fixed([
                              // Отступ сверху 16
                              const SizedBox(height: 16),
                              // Контент с боковыми отступами 16
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        // Картинка профиля и элементы вокруг
                                        SizedBox(
                                          height: 120,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Картинка профиля (width: 120, height: 120)
                                              Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: _avatarUrl != null && _avatarUrl!.isNotEmpty
                                                      ? DecorationImage(
                                                          image: NetworkImage(_avatarUrl!),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null,
                                                  color: _avatarUrl == null || _avatarUrl!.isEmpty
                                                      ? AppColors.grey300
                                                      : null,
                                                ),
                                                child: _avatarUrl == null || _avatarUrl!.isEmpty
                                                    ? const Icon(Icons.person, size: 60, color: AppColors.textSecondary)
                                                    : null,
                                              ),
                                              // VIP бейдж: правый нижний угол должен быть на границе аватарки
                                              // Аватарка: width 120px, height 120px, центр в Stack
                                              // VIP контейнер: width 39.55px, height 23.59px
                                              // Правый нижний угол аватарки: от центра Stack right: 60px, bottom: 60px
                                              // Правый нижний угол VIP: от центра Stack right: 60px - 39.55px = 20.45px, bottom: 60px - 23.59px = 36.41px
                                              // Но это не соответствует макету. В макете: top: 75px, left: 196.34px
                                              // Аватарка left: 120.34px, значит правый край на 120.34 + 120 = 240.34px
                                              // VIP left: 196.34px, width: 39.55px, значит правый край на 196.34 + 39.55 = 235.89px
                                              // Правый край VIP должен быть на границе аватарки: 240.34px
                                              // Значит left должен быть: 240.34 - 39.55 = 200.79px
                                              // Но в макете left: 196.34px, значит правый край на 235.89px, что не на границе
                                              
                                              // Пересчитываем: если правый нижний угол должен быть на границе
                                              // Аватарка: радиус 60px от центра, значит правый край на +60px по X
                                              // VIP контейнер: его правый край должен быть на +60px от центра
                                              // width VIP: 39.55px, значит left должен быть: 60 - 39.55 = 20.45px от центра
                                              // Но в макете left: 196.34px, а аватарка left: 120.34px
                                              // От левого края аватарки: 196.34 - 120.34 = 76px
                                              // Правый край аватарки: 120.34 + 120 = 240.34px
                                              // Правый край VIP: 196.34 + 39.55 = 235.89px
                                              // Чтобы правый край был на границе: left должен быть 240.34 - 39.55 = 200.79px
                                              // От левого края аватарки: 200.79 - 120.34 = 80.45px
                                              
                                              // В Stack аватарка центрирована, её правый край на +60px от центра
                                              // VIP правый край должен быть на +60px от центра
                                              // left VIP: 60 - 39.55 = 20.45px от центра
                                              // Но top: 75px от верха, bottom аватарки на +60px от центра
                                              // Чтобы нижний угол VIP был на границе: bottom должен быть на +60px
                                              // height VIP: 23.59px, значит top должен быть: 60 - 23.59 = 36.41px от центра (вниз)
                                              // Но в макете top: 75px от верха, а не от центра
                                              
                                              // Упростим: используем макет как есть, но скорректируем для правого нижнего угла
                                              // В макете: top: 75px, left: 196.34px
                                              // Аватарка: left: 120.34px, width: 120px (правый край на 240.34px)
                                              // Правый край VIP должен быть на 240.34px: left = 240.34 - 39.55 = 200.79px
                                              // От левого края аватарки в Stack: 200.79 - 120.34 = 80.45px
                                              // В Stack аватарка центрирована, её левый край на -60px
                                              // От центра Stack: -60 + 80.45 = 20.45px
                                              
                                              // Для bottom: аватарка height: 120px, нижний край на +60px от центра
                                              // VIP height: 23.59px, нижний край должен быть на +60px
                                              // top VIP: 60 - 23.59 = 36.41px от центра (вниз)
                                              // Но в макете top: 75px от верха, а не от центра
                                              // Аватарка top в Stack: -60px от центра (верх)
                                              // От верха аватарки: 75px, значит от центра Stack: -60 + 75 = 15px
                                              // Но нижний край VIP должен быть на +60px от центра
                                              // Значит top должен быть: 60 - 23.59 = 36.41px (но это не 75px от верха)
                                              
                                              // Используем макет: top: 75px от верха аватарки
                                              // В Stack аватарка центрирована, её верх на -60px от центра
                                              // top VIP: -60 + 75 = 15px от центра Stack
                                              // Но для правого нижнего угла на границе:
                                              // right должен быть 60px (правый край аватарки)
                                              // left = right - width = 60 - 39.55 = 20.45px
                                              // bottom должен быть 60px (нижний край аватарки)
                                              // top = bottom - height = 60 - 23.59 = 36.41px
                                              
                                              if (_isVip)
                                                Positioned(
                                                  bottom: 12, // Отступ 12px от низа картинки
                                                  right: 1,   // Правый край прижат к правой границе картинки
                                                  child: Transform.rotate(
                                                    angle: -15 * math.pi / 180, // angle: -15 deg
                                                    child: Container(
                                                      width: 39.552318039635665, // width согласно макету
                                                      height: 23.59456984173971, // height согласно макету
                                                      decoration: BoxDecoration(
                                                        color: AppColors.accent,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'VIP',
                                                          style: const TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 12,
                                                            height: 1.0,
                                                            letterSpacing: 0.05,
                                                            color: AppColors.primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                              const SizedBox(height: 16),
                              // Имя пользователя
                              Text(
                                _userName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 23 / 14,
                                  letterSpacing: 0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Кнопка подписки (если не VIP)
                              if (!_isVip) ...[
                                SizedBox(
                                  width: 361,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const PremiumScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10000),
                                      ),
                                      padding: const EdgeInsets.only(left: 18),
                                      minimumSize: const Size(double.infinity, 56),
                                      alignment: Alignment.centerLeft, // Выравнивание по левому краю
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start, // Выравнивание по левому краю
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 14),
                                        Text(
                                          s.profileSubscribe,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            height: 1.0,
                                            letterSpacing: 0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              // Кнопка Уведомления
                              _ProfileButton(
                                icon: Icons.notifications_outlined,
                                text: s.profileNotifications,
                                onTap: () {},
                                showBadge: true,
                                badgeCount: _notificationsCount,
                              ),
                              const SizedBox(height: 8),
                              // Кнопка Избранное
                              _ProfileButton(
                                icon: Icons.favorite_border,
                                text: s.profileFavorites,
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              // Кнопка Редактировать профиль
                              _ProfileButton(
                                icon: Icons.account_circle_outlined,
                                text: s.profileEdit,
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              // Кнопка Смена языка
                              _ProfileButton(
                                icon: Icons.translate,
                                text: s.profileLanguage,
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              // Кнопка Пользовательское соглашение
                              _ProfileButton(
                                icon: Icons.description_outlined,
                                text: s.profileTerms,
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              // Кнопка Написать в поддержку
                              _ProfileButton(
                                icon: Icons.contact_support_outlined,
                                text: s.profileSupport,
                                onTap: () {},
                              ),
                              // Кнопка Админ панель (если админ, в конце списка)
                              if (_isAdmin) ...[
                                const SizedBox(height: 8),
                                _ProfileButton(
                                  icon: Icons.admin_panel_settings_outlined,
                                  text: s.profileAdmin,
                                  onTap: () {},
                                ),
                              ],
                              const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  // Иконка logout (полностью справа от экрана, на высоте картинки)
                                  Positioned(
                                    top: 0,
                                    right: 16, // Отступ справа от края экрана
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 24,
                                      icon: const Icon(Icons.logout_outlined, color: AppColors.primary, size: 24),
                                      onPressed: _logout,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // BottomNavBar
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: BottomNavBar(index: 3, lang: _lang, repo: _repo),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool showBadge;
  final int badgeCount;

  const _ProfileButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.showBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 361,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10000),
          ),
          padding: EdgeInsets.only(
            left: 18,
            right: showBadge ? 8 : 18,
          ),
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0,
                  color: Colors.black,
                ),
              ),
            ),
            if (showBadge)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7E7E7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0.04,
                      color: Color(0xFFC5C5C5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

