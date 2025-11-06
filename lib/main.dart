import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n.dart';
import 'auth/login.dart';
import 'windows/home/home_screen.dart';
import 'core/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yyxgdlbamxfedwyfbbxe.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5eGdkbGJhbXhmZWR3eWZiYnhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4MzU5OTUsImV4cCI6MjA3NjQxMTk5NX0.TYEEAXrafUBd4SIb6D8IN5yN2hJxV1YzgrbsCSzEoaA',
  );

  // Инициализируем сервис уведомлений
  await NotificationService().initialize();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static _MainAppState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();

  static _MainAppState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'MainApp state not found in context');
    return state!;
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;
  bool _ready = false;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
    // Слушаем изменения состояния авторизации
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        _checkSession();
      }
    });
  }

  Future<void> _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (mounted) {
      setState(() {
        _loggedIn = session != null;
        _ready = true;
      });
    }
  }

  void changeLocale(Locale locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),
      home: _loggedIn
          ? const HomeScreen() // если сессия есть → сразу на главный
          : LanguageScreen(onConfirmLocale: changeLocale),
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

  final _items = const [
    _LangItem('assets/icons/ru.png', Locale('ru')),
    _LangItem('assets/icons/en.png', Locale('en')),
    _LangItem('assets/icons/es.png', Locale('es')),
  ];

  @override
  void initState() {
    super.initState();

    final systemCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final idx = _items.indexWhere((it) => it.locale.languageCode == systemCode);
    selected = idx != -1 ? idx : 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onConfirmLocale(_items[selected!].locale);
    });
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
                  child: Image.asset(
                    'assets/logo/logo.png',
                    fit: BoxFit.contain,
                  ),
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
                        onTap: () {
                          setState(() => selected = i);
                          widget.onConfirmLocale(_items[i].locale);
                        },
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(
                                onChangeLocale: widget.onConfirmLocale,
                                currentLocale: locale,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD580),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    S.of(context).ok.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
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
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image.asset(
                item.flagPath,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.localizedTitle(context),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
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
        return locale.languageCode;
    }
  }
}
