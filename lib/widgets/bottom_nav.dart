// lib/widgets/bottom_nav.dart
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const BottomNavBar({super.key, required this.index, required this.onTap});

  Color _itemColor(bool active) =>
      active ? const Color(0xFF766DFF) : const Color(0xFF282828);

  @override
  Widget build(BuildContext context) {
    // сам бар — по центру, поверх контента
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10), // ← строго 10 пикселей
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
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.spa,
                  label: 'программы',
                  color: _itemColor(index == 1),
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: Icons.headphones,
                  label: 'музыка',
                  color: _itemColor(index == 2),
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Icons.account_circle,
                  label: 'профиль',
                  color: _itemColor(index == 3),
                  onTap: () => onTap(3),
                ),
              ],
            ),
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
