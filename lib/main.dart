import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart'; // flutter_intl генерирует это

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        S.delegate, // из flutter_intl
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter', // подключите шрифт в pubspec.yaml
      ),
      home: LanguageScreen(
        onConfirmLocale: _setLocale,
      ),
    );
  }
}

class LanguageScreen extends StatefulWidget {
  final void Function(Locale locale) onConfirmLocale;
  const LanguageScreen({super.key, required this.onConfirmLocale});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int? selected;

  // без названий — только флаг и локаль
  final _items = const [
    _LangItem('assets/icons/ru.png', Locale('ru')),
    _LangItem('assets/icons/en.png', Locale('en')),
    _LangItem('assets/icons/es.png', Locale('es')),
  ];

  @override
  void initState() {
    super.initState();
    final systemCode = WidgetsBinding.instance.window.locale.languageCode;
    final idx = _items.indexWhere((it) => it.locale.languageCode == systemCode);
    selected = idx != -1 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8982FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 47),
              Center(
                child: SizedBox(
                  width: 112,
                  height: 118,
                  child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 87),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    for (int i = 0; i < _items.length; i++) ...[
                      _LanguageTile(
                        item: _items[i],
                        selected: selected == i,
                        onTap: () => setState(() => selected = i),
                      ),
                      if (i != _items.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 353,
                height: 56,
                child: ElevatedButton(
                  onPressed: selected == null
                      ? null
                      : () {
                          final locale = _items[selected!].locale;
                          widget.onConfirmLocale(locale);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD580),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    padding: const EdgeInsets.fromLTRB(114, 22, 114, 22),
                    elevation: 0,
                  ),
                  child: Text(
                    S.of(context).ok.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.0,
                      letterSpacing: 0.48,
                      color: Color(0xFF59523A),
                    ),
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

class _LanguageTile extends StatelessWidget {
  final _LangItem item;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF8E86FF) : Colors.transparent;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            const SizedBox(width: 16),
            SizedBox(
              width: 24,
              height: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Image.asset(item.flagPath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 6),
            // текст слева отцентрирован по высоте, без центрирования по строке
            Text(
              item.localizedTitle(context),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.0,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _LangItem {
  final String flagPath;
  final Locale locale;
  const _LangItem(this.flagPath, this.locale);

  String localizedTitle(BuildContext context) {
    final s = S.of(context);
    switch (locale.languageCode) {
      case 'ru':
        return s.languageRussian;
      case 'en':
        return s.languageEnglish;
      case 'es':
        return s.languageSpanish;
      default:
        return locale.languageCode; // fallback
    }
  }
}