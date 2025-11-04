// lib/onboarding/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../generated/l10n.dart';
import 'premium_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<void> _askAndNext(BuildContext context) async {
    try {
      // Запрашиваем разрешение на уведомления
      // На iOS и Android разрешение будет запрошено системой
      // Результат будет: granted, denied, permanentlyDenied и т.д.
      await Permission.notification.request();
      
      // Переходим на следующий экран независимо от результата
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PremiumScreen()),
        );
      }
    } catch (e) {
      // В случае ошибки все равно переходим дальше
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PremiumScreen()),
        );
      }
    }
  }

  Future<void> _skip(BuildContext context) async {
    // При нажатии "Нет" явно отказываем в разрешении (если возможно)
    try {
      // Можно явно отклонить разрешение, но это не всегда возможно
      // Просто переходим дальше без запроса
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PremiumScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PremiumScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8982FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 4),
                  Center(
                    child: SizedBox(
                      width: 48, height: 50,
                      child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 280,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s.notifTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 22/18,
                          letterSpacing: -0.41,
                          color: Color(0xFF282828),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        s.notifSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFF9D9D9D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 116, height: 32,
                            child: ElevatedButton(
                              onPressed: () => _askAndNext(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFD580),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                s.allow.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  height: 1.0,
                                  letterSpacing: 0.4,
                                  color: Color(0xFF59523A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 116, height: 32,
                            child: OutlinedButton(
                              onPressed: () => _skip(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFF1F1F1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                s.noBtn.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  height: 1.0,
                                  letterSpacing: 0.4,
                                  color: Color(0xFF59523A),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}