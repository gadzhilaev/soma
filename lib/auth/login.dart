// lib/auth/login.dart
import 'package:flutter/material.dart';
import 'package:soma/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase.dart';
import '../core/notification_service.dart';
import 'register.dart';
import 'restore.dart';
import '../onboarding/notifications_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale locale) onChangeLocale;
  final Locale currentLocale;

  const LoginScreen({
    super.key,
    required this.onChangeLocale,
    required this.currentLocale,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late Locale _currentLocale;
  bool showLanguageList = false;

  // 🔹 флаг загрузки — ДОЛЖЕН быть в State
  bool _loading = false;

  final _languages = const [
    _LangItem('assets/icons/ru.png', Locale('ru')),
    _LangItem('assets/icons/en.png', Locale('en')),
    _LangItem('assets/icons/es.png', Locale('es')),
  ];

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.currentLocale;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 🔹 логин — ДОЛЖЕН быть в State, чтобы видеть context/setState/mounted
  Future<void> _login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите почту и пароль')));
      return;
    }

    setState(() => _loading = true);
    try {
      await supa.auth.signInWithPassword(email: email, password: pass);
      // внутри try после успешного signInWithPassword
      if (!mounted) return;
      
      // Показываем уведомление о успешном входе
      final s = S.of(context);
      await NotificationService().showNotification(
        title: s.loginSuccessTitle,
        body: s.loginSuccessBody,
      );
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        (_) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      SnackBar(content: Text('${S.of(context).errorPrefix} $e'));
    } finally {
      // ❗ без return в finally
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final selectedLang = _languages.firstWhere(
      (l) => l.locale.languageCode == _currentLocale.languageCode,
      orElse: () => _languages.first,
    );

    final fullHeight = MediaQuery.of(context).size.height;
    final verticalPadding = MediaQuery.of(context).padding.vertical;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8982FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: fullHeight - verticalPadding,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 47),
                            Center(
                              child: SizedBox(
                                width: 112,
                                height: 118,
                                child: Image.asset(
                                  'assets/logo/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Email label
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  s.emailLabel,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xB2FFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: emailController,
                              hint: s.emailHint,
                            ),
                            const SizedBox(height: 16),

                            // Password label
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  s.passwordLabel,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xB2FFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: passwordController,
                              hint: s.passwordHint,
                              obscure: true,
                            ),

                            const SizedBox(height: 24),

                            // Кнопка Войти
                            Center(
                              child: SizedBox(
                                width: 353,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD580),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                    minimumSize: const Size(353, 56),
                                  ),
                                  onPressed: _loading ? null : _login,
                                  child: _loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF59523A),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            s.login.toUpperCase(),
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.48,
                                              color: Color(0xFF59523A),
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Кнопка Регистрация
                            Center(
                              child: SizedBox(
                                width: 353,
                                height: 56,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(353, 56),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterScreen(
                                          onChangeLocale: widget.onChangeLocale,
                                          currentLocale: _currentLocale,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      s.register.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.48,
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Забыли пароль?
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RestoreScreen(
                                        onChangeLocale: widget.onChangeLocale,
                                        currentLocale: _currentLocale,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  s.forgotPassword,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ===== Выбор языка (как было)
          Positioned(
            right: 20,
            bottom: 48,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showLanguageList)
                  Container(
                    width: 65,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9892FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _languages
                          .where(
                            (lang) =>
                                lang.locale.languageCode !=
                                _currentLocale.languageCode,
                          )
                          .map((lang) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                widget.onChangeLocale(lang.locale);
                                setState(() {
                                  _currentLocale = lang.locale;
                                  showLanguageList = false;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: SizedBox(
                                  width: 23,
                                  height: 23,
                                  // только флаг
                                  // Image.asset(lang.flagPath, width: 23, height: 23),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                GestureDetector(
                  onTap: () =>
                      setState(() => showLanguageList = !showLanguageList),
                  child: Container(
                    width: 65,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9892FF),
                      borderRadius: showLanguageList
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            )
                          : BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          selectedLang.flagPath,
                          width: 23,
                          height: 23,
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const _InputField({
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x29FFFFFF),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            contentPadding: const EdgeInsets.only(left: 20),
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.white70,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _LangItem {
  final String flagPath;
  final Locale locale;
  const _LangItem(this.flagPath, this.locale);
}
