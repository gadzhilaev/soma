// lib/auth/register.dart
import 'package:flutter/material.dart';
import 'package:soma/generated/l10n.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  final Function(Locale locale) onChangeLocale;
  final Locale currentLocale;

  const RegisterScreen({
    super.key,
    required this.onChangeLocale,
    required this.currentLocale,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final repeatPassController = TextEditingController();

  late Locale _currentLocale;
  bool showLanguageList = false;
  bool agreed = false;

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
  Widget build(BuildContext context) {
    final s = S.of(context);

    // локальные тексты (временно, пока не добавили в .arb)
    String tName() {
      switch (_currentLocale.languageCode) {
        case 'en':
          return 'Name';
        case 'es':
          return 'Nombre';
        default:
          return 'Имя';
      }
    }

    String tRepeatPassword() {
      switch (_currentLocale.languageCode) {
        case 'en':
          return 'Repeat password';
        case 'es':
          return 'Repite la contraseña';
        default:
          return 'Повторите пароль';
      }
    }

    String tAgreePrefix() {
      switch (_currentLocale.languageCode) {
        case 'en':
          return 'I agree with the terms of processing of ';
        case 'es':
          return 'Acepto los términos del procesamiento de ';
        default:
          return 'Я согласен(-на) с условиями обработки ';
      }
    }

    String tPersonalData() {
      switch (_currentLocale.languageCode) {
        case 'en':
          return 'personal data';
        case 'es':
          return 'datos personales';
        default:
          return 'персональных данных';
      }
    }

    String tRegisterAction() {
      switch (_currentLocale.languageCode) {
        case 'en':
          return 'Register';
        case 'es':
          return 'Registrarse';
        default:
          return 'Зарегистрироваться';
      }
    }

    String tHaveAccount() {
      switch (_currentLocale.languageCode) {
        case 'en':
          return 'I already have an account';
        case 'es':
          return 'Ya tengo una cuenta';
        default:
          return 'У меня уже есть аккаунт';
      }
    }

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
          // фон + контент
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
                                child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Имя
                            _Label(text: tName()),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: nameController,
                              hint: tName(),
                            ),
                            const SizedBox(height: 16),

                            // Электронная почта (берём из S)
                            _Label(text: s.emailLabel),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: emailController,
                              hint: s.emailHint,
                            ),
                            const SizedBox(height: 16),

                            // Пароль
                            _Label(text: s.passwordLabel),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: passController,
                              hint: s.passwordHint,
                              obscure: true,
                            ),
                            const SizedBox(height: 16),

                            // Повторите пароль
                            _Label(text: tRepeatPassword()),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: repeatPassController,
                              hint: tRepeatPassword(),
                              obscure: true,
                            ),

                            const SizedBox(height: 16),

                            // согласие с обработкой ПДн
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => agreed = !agreed),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(right: 12, top: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFFFFD580),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: agreed
                                        ? const Icon(Icons.check, size: 16, color: Color(0xFFFFD580))
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: tAgreePrefix(),
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              height: 1.4, // 140%
                                              letterSpacing: 0.52, // 4% от 13
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: tPersonalData(),
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              height: 1.4,
                                              letterSpacing: 0.52,
                                              color: Color(0xFFFFE0A0), // выделение
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Кнопка ЗАРЕГИСТРИРОВАТЬСЯ
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
                                  onPressed: () {
                                    // TODO: регистрация
                                  },
                                  child: Center(
                                    child: Text(
                                      tRegisterAction().toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.48, // 4% от 12
                                        color: Color(0xFF59523A),
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // У меня уже есть аккаунт
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(
                                        onChangeLocale: widget.onChangeLocale,
                                        currentLocale: _currentLocale,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  tHaveAccount(),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white,
                                    height: 1.7,
                                  ),
                                ),
                              ),
                            ),

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

          // ===== Кнопка выбора языка + список языков (как в login.dart) =====
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
                          .where((lang) => lang.locale.languageCode != _currentLocale.languageCode)
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
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Image.asset(lang.flagPath, width: 23, height: 23),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                GestureDetector(
                  onTap: () => setState(() => showLanguageList = !showLanguageList),
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
                        Image.asset(selectedLang.flagPath, width: 23, height: 23),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
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

// ===== Общие мелкие виджеты (как в login.dart) =====

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Color(0xB2FFFFFF),
          ),
        ),
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
        width: 353,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0x29FFFFFF), // #FFFFFF с ~16% прозрачности
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
            height: 1.0,
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