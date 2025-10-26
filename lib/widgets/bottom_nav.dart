// lib/widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import '../core/supabase.dart';
import '../windows/home/home_screen.dart';
import '../settings/repo.dart';
import '../windows/programs/programs_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int index; // текущая вкладка
  final String lang;
  final HomeRepo repo;

  const BottomNavBar({
    super.key,
    required this.index,
    required this.lang,
    required this.repo,
  });

  Color _itemColor(bool active) =>
      active ? const Color(0xFF766DFF) : const Color(0xFF282828);

  void _handleTap(BuildContext context, int i) {
    if (i == index) return;

    Widget target;
    switch (i) {
      case 0:
        target = const HomeScreen();
        break;
      case 1:
        target = ProgramsScreen(lang: lang, repo: repo);
        break;
      case 2:
        target = const PlaceholderScreen(title: 'Музыка');
        break;
      case 3:
        target = const PlaceholderScreen(title: 'Профиль');
        break;
      default:
        target = const HomeScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => target,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 339,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(color: Colors.black, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'дом',
                color: _itemColor(index == 0),
                onTap: () => _handleTap(context, 0),
              ),
              _NavItem(
                icon: Icons.spa,
                label: 'программы',
                color: _itemColor(index == 1),
                onTap: () => _handleTap(context, 1),
              ),
              _NavItem(
                icon: Icons.headphones,
                label: 'музыка',
                color: _itemColor(index == 2),
                onTap: () => _handleTap(context, 2),
              ),
              _NavItem(
                icon: Icons.account_circle,
                label: 'профиль',
                color: _itemColor(index == 3),
                onTap: () => _handleTap(context, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                height: 17 / 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Заглушки для будущих экранов
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(child: Text(title, style: const TextStyle(fontSize: 22))),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              index: _indexForTitle(title),
              lang: 'en',
              repo: HomeRepo(supa), // теперь создаётся без Supabase напрямую
            ),
          ),
        ],
      ),
    );
  }

  static int _indexForTitle(String t) =>
      t == 'Музыка' ? 2 : t == 'Профиль' ? 3 : 0;
}