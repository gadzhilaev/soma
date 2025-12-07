// lib/auth/restore.dart
import 'package:flutter/material.dart';
import 'package:soma/generated/l10n.dart';
import '../core/supabase.dart';
import 'login.dart';

class RestoreScreen extends StatefulWidget {
  final Function(Locale locale) onChangeLocale;
  final Locale currentLocale;

  const RestoreScreen({
    super.key,
    required this.onChangeLocale,
    required this.currentLocale,
  });

  @override
  State<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  final emailController = TextEditingController();
  bool _loading = false;

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
    _currentLocale = widget.currentLocale;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _restorePassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).emailHint)),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await supa.auth.resetPasswordForEmail(
        email,
        redirectTo: null, // Можно указать URL для сброса пароля
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).restorePass} - Проверьте вашу почту'),
        ),
      );
      // Возвращаемся на экран входа
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            onChangeLocale: widget.onChangeLocale,
            currentLocale: _currentLocale,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).errorPrefix} $e')),
      );
    } finally {
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

                            // Электронная почта (берём из S)
                            _Label(text: s.restoreLabel),
                            const SizedBox(height: 24),
                            _InputField(
                              controller: emailController,
                              hint: s.emailHint,
                            ),

                            const SizedBox(height: 16),

                            // Кнопка Восстановить пароль
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
                                  onPressed: _loading ? null : _restorePassword,
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
                                            s.restorePass.toUpperCase(),
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
                                  s.cancel,
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

// ===== Общие мелкие виджеты =====

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xB2FFFFFF),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  //final bool obscure;

  const _InputField({
    required this.controller,
    required this.hint,
    //this.obscure = false,
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
          //obscureText: obscure,
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
