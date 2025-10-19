// lib/auth/register.dart
import 'package:flutter/material.dart';
import 'package:soma/generated/l10n.dart';
import 'login.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 👈
import '../core/supabase.dart'; // 👈 если файл core/supabase.dart создашь

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
                                child: Image.asset(
                                  'assets/logo/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Имя
                            _Label(text: s.nameLabel),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: nameController,
                              hint: s.nameHint,
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
                            _Label(text: s.repeatPasswordLabel),
                            const SizedBox(height: 12),
                            _InputField(
                              controller: repeatPassController,
                              hint: s.repeatPasswordLabel,
                              obscure: true,
                            ),

                            const SizedBox(height: 16),

                            // согласие с обработкой ПДн
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => agreed = !agreed),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(
                                      right: 12,
                                      top: 2,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: agreed
                                          ? const Color(0xFFFFD580)
                                          : Colors.transparent, // заливка
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFFFFD580),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: agreed
                                        ? const Icon(
                                            Icons.check,
                                            size:
                                                14, // чуть меньше, чтобы красиво влезало в 20x20
                                            color: Color(
                                              0xFF59523A,
                                            ), // цвет галочки
                                          )
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: s.agreePrefix,
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
                                            text: s.personalData,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              height: 1.4,
                                              letterSpacing: 0.52,
                                              color: Color(
                                                0xFFFFE0A0,
                                              ), // выделение
                                              decoration:
                                                  TextDecoration.underline,
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
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD580),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    elevation: 0,
                                    minimumSize: const Size(353, 56),
                                  ),
                                  onPressed: () async {
                                    final name = nameController.text.trim();
                                    final email = emailController.text.trim();
                                    final pass = passController.text.trim();
                                    final pass2 = repeatPassController.text
                                        .trim();

                                    if (name.isEmpty ||
                                        email.isEmpty ||
                                        pass.isEmpty ||
                                        pass2.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            S.of(context).emailHint,
                                          ),
                                        ), // можно свой текст
                                      );
                                      return;
                                    }
                                    if (pass != pass2) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Пароли не совпадают'),
                                        ),
                                      );
                                      return;
                                    }
                                    if (!agreed) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Подтверди согласие на обработку данных',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      // 1) Регистрация в auth
                                      final res = await supa.auth.signUp(
                                        email: email,
                                        password: pass,
                                        data: {
                                          'name': name,
                                        }, // метаданные (опционально)
                                      );

                                      final user = res.user;
                                      if (user == null) {
                                        throw 'Не удалось создать пользователя';
                                      }

                                      // 2) Профиль в таблицу users (id, name, email)
                                      await supa.from('users').upsert({
                                        'id': user
                                            .id, // важно: ключом делаем id из auth
                                        'name': name,
                                        'email': email,
                                      }).select(); // чтобы словить ошибки в dev

                                      // 3) Успех
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Регистрация прошла успешно',
                                          ),
                                        ),
                                      );

                                      // Вернёмся на экран логина
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreen(
                                            onChangeLocale:
                                                widget.onChangeLocale,
                                            currentLocale: _currentLocale,
                                          ),
                                        ),
                                      );
                                    } on AuthException catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.message)),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('Ошибка: $e')),
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      s.registerSubmit.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.48, // 4% от 12
                                        color: Color(0xFF59523A),
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
                                  s.haveAccount,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white,
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
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0x29FFFFFF), // #FFFFFF с ~16% прозрачности
          borderRadius: BorderRadius.circular(24),
        ),
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
