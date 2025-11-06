import 'package:flutter/material.dart';

import '../../core/screen_utils.dart';
import '../../generated/l10n.dart';

class LanguagePickerScreen extends StatefulWidget {
  final void Function(Locale locale) onConfirmLocale;

  const LanguagePickerScreen({super.key, required this.onConfirmLocale});

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  late int _selected;

  final _items = const [
    _LangItem('assets/icons/ru.png', Locale('ru')),
    _LangItem('assets/icons/en.png', Locale('en')),
    _LangItem('assets/icons/es.png', Locale('es')),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context);
    final idx = _items.indexWhere(
      (it) => it.locale.languageCode == currentLocale.languageCode,
    );
    _selected = idx != -1 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

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
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 47)),
              Center(
                child: SizedBox(
                  width: ScreenUtils.adaptiveWidth(context, 112),
                  height: ScreenUtils.adaptiveHeight(context, 118),
                  child: Image.asset(
                    'assets/logo/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 87)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.adaptiveWidth(context, 20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _items.length; i++) ...[
                      _LanguageTile(
                        item: _items[i],
                        selected: _selected == i,
                        onTap: () {
                          setState(() => _selected = i);
                        },
                      ),
                      if (i != _items.length - 1)
                        SizedBox(
                          height: ScreenUtils.adaptiveHeight(context, 10),
                        ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: ScreenUtils.adaptiveHeight(context, 48)),
              SizedBox(
                width: ScreenUtils.adaptiveWidth(context, 353),
                height: ScreenUtils.adaptiveHeight(context, 56),
                child: ElevatedButton(
                  onPressed: () {
                    final locale = _items[_selected].locale;
                    widget.onConfirmLocale(locale);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD580),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ScreenUtils.adaptiveSize(context, 40),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    s.ok.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtils.adaptiveFontSize(context, 12),
                      letterSpacing: 0.48,
                      color: const Color(0xFF59523A),
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
        return locale.languageCode;
    }
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
        height: ScreenUtils.adaptiveHeight(context, 56),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(width: ScreenUtils.adaptiveWidth(context, 16)),
            ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image.asset(
                item.flagPath,
                width: ScreenUtils.adaptiveWidth(context, 24),
                height: ScreenUtils.adaptiveHeight(context, 24),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: ScreenUtils.adaptiveWidth(context, 6)),
            Text(
              item.localizedTitle(context),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtils.adaptiveFontSize(context, 16),
                color: Colors.white,
              ),
            ),
            const Spacer(),
            SizedBox(width: ScreenUtils.adaptiveWidth(context, 16)),
          ],
        ),
      ),
    );
  }
}
