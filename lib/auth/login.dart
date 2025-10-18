// lib/auth/login.dart
import 'package:flutter/material.dart';
import 'package:soma/generated/l10n.dart';

import 'register.dart';

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

  final _languages = const [
    _LangItem('assets/icons/ru.png', Locale('ru')),
    _LangItem('assets/icons/en.png', Locale('en')),
    _LangItem('assets/icons/es.png', Locale('es')),
  ];

  @override
  void initState() {
    super.initState();
    // 🔹 ИНИЦИАЛИЗАЦИЯ state-локали из того, что пришло извне
    _currentLocale = widget.currentLocale;
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
      // делаем прозрачный фон у Scaffold, чтобы градиент контейнера покрывал весь экран
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
              // SafeArea + SingleChildScrollView, но гарантируем минимум высоты = экран
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

                            // Кнопка Войти (фиксированная высота)
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
                                  onPressed: () {},
                                  child: Center(
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
                              child: Text(
                                s.forgotPassword,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.white,
                                  height: 1.7,
                                ),
                              ),
                            ),

                            // заполнитель, чтобы колонка заняла всю высоту
                            const Spacer(),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ===== Кнопка выбора языка + список языков =====
          Positioned(
            right: 20,
            bottom: 48,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ===== Список языков (над кнопкой, без нижнего скругления) =====
                if (showLanguageList)
                  Container(
                    width: 65,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9892FF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        // нижние углы убраны — чтобы прилегал к кнопке
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      bottom: 1,
                    ), // 🔹 зазор 1 пиксель
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Image.asset(
                                  lang.flagPath,
                                  width: 23,
                                  height: 23,
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),

                // ===== Кнопка выбранного языка =====
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

  String _languageNameForLocale(BuildContext context, Locale locale) {
    final s = S.of(context);
    switch (locale.languageCode) {
      case 'ru':
        return s.languageRussian;
      case 'en':
        return s.languageEnglish;
      case 'es':
        return s.languageSpanish;
      default:
        return locale.languageCode;
    }
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
          color: const Color(0x29FFFFFF), // #FFFFFF29
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
            contentPadding: const EdgeInsets.only(left: 20), // слева 20
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
