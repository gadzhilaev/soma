import 'package:flutter/material.dart';
import 'package:soma/generated/l10n.dart';

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

  bool showLanguageList = false;

  final _languages = const [
    _LangItem('assets/icons/ru.png', Locale('ru')),
    _LangItem('assets/icons/en.png', Locale('en')),
    _LangItem('assets/icons/es.png', Locale('es')),
  ];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final selectedLang = _languages.firstWhere(
      (l) => l.locale.languageCode == widget.currentLocale.languageCode,
      orElse: () => _languages.first,
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF8982FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 47),
                    Center(
                      child: SizedBox(
                        width: 112,
                        height: 118,
                        child: Image.asset('assets/logo/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // ===== Электронная почта =====
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
                            color: Color(0xB2FFFFFF), // #FFFFFFB2 => AARRGGBB
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

                    // ===== Пароль =====
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

                    // ===== Кнопка Войти =====
                    SizedBox(
                      width: 353,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD580),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 114,
                            vertical: 22,
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Text(
                          s.login.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.48,
                            color: Color(0xFF59523A),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== Кнопка Регистрация =====
                    SizedBox(
                      width: 353,
                      height: 56,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 128,
                            vertical: 22,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          s.register.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ===== Забыли пароль? =====
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
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),

          // ===== Выбор языка =====
          Positioned(
            right: 20,
            bottom: 48,
            child: GestureDetector(
              onTap: () => setState(() => showLanguageList = !showLanguageList),
              child: Container(
                width: 63,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF9892FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(selectedLang.flagPath, width: 23, height: 23),
                    const SizedBox(width: 10),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),

          if (showLanguageList)
            Positioned(
              right: 20,
              bottom: 90,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: _languages.map((lang) {
                    return InkWell(
                      onTap: () {
                        widget.onChangeLocale(lang.locale);
                        setState(() => showLanguageList = false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(lang.flagPath, width: 23, height: 23),
                      ),
                    );
                  }).toList(),
                ),
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
    return Container(
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
          contentPadding: const EdgeInsets.only(left: 20, bottom: 14),
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
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