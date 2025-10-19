// lib/onboarding/questions_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase.dart';
import '../home/home_screen.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _sb = supa;

  bool _loading = true;
  bool _saving = false;

  // вопросы и текущий индекс
  List<_Question> _questions = [];
  int _idx = 0;

  // кэш опций по questionId
  final Map<String, List<_Option>> _options = {};

  // выбранная опция для текущего вопроса
  String? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _loading = true);
    try {
      final res = await _sb
          .from('questions')
          .select('id,title,created_at')
          .eq('is_active', true)
          .order('created_at', ascending: true);

      _questions = (res as List)
          .map(
            (e) => _Question(
              id: e['id'] as String,
              title: (e['title'] ?? '') as String,
            ),
          )
          .toList();

      if (_questions.isEmpty) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
        return;
      }

      await _loadOptions(_questions.first.id);
    } catch (e) {
      _show('Ошибка загрузки вопросов: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadOptions(String questionId) async {
    if (_options.containsKey(questionId)) return; // уже есть
    try {
      final res = await _sb
          .from('question_options')
          .select('id,label,value,sort_index')
          .eq('question_id', questionId)
          .order('sort_index', ascending: true);

      _options[questionId] = (res as List)
          .map(
            (e) => _Option(
              id: e['id'] as String,
              label: (e['label'] ?? '') as String,
              value: (e['value'] ?? '') as String,
            ),
          )
          .toList();
    } catch (e) {
      _show('Ошибка загрузки вариантов: $e');
      _options[questionId] = const [];
    }
  }

  Future<void> _saveAndNext() async {
    if (_questions.isEmpty) return;
    final user = _sb.auth.currentUser;
    if (user == null) {
      _show('Нет активной сессии пользователя');
      return;
    }
    final q = _questions[_idx];
    if (_selectedOptionId == null) {
      _show('Выберите один из вариантов');
      return;
    }

    setState(() => _saving = true);
    try {
      await _sb.from('user_answers').insert({
        'user_id': user.id,
        'question_id': q.id,
        'option_id': _selectedOptionId,
        // 'free_text': null, // если когда-нибудь появится поле "Другое → введите"
      });

      // следующий вопрос или на главную
      if (_idx + 1 < _questions.length) {
        final nextIdx = _idx + 1;
        final nextQ = _questions[nextIdx];
        await _loadOptions(nextQ.id);

        if (!mounted) return;
        setState(() {
          _idx = nextIdx;
          _selectedOptionId = null;
        });
      } else {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } catch (e) {
      _show('Не удалось сохранить ответ: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // фон — как в register.dart
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
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _questions.isEmpty
              ? _EmptyState(
                  onToHome: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false,
                    );
                  },
                )
              : _QuestionView(
                  question: _questions[_idx],
                  options: _options[_questions[_idx].id] ?? const [],
                  selectedOptionId: _selectedOptionId,
                  onSelect: (id) => setState(() => _selectedOptionId = id),
                  onNext: _saving ? null : _saveAndNext,
                  saving: _saving,
                ),
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  final _Question question;
  final List<_Option> options;
  final String? selectedOptionId;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;
  final bool saving;

  const _QuestionView({
    required this.question,
    required this.options,
    required this.selectedOptionId,
    required this.onSelect,
    required this.onNext,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // отступ сверху 4
        const SizedBox(height: 4),
        // логотип по центру, размер 48x50
        Center(
          child: SizedBox(
            width: 48,
            height: 50,
            child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
          ),
        ),
        // после лого 24
        const SizedBox(height: 24),

        // текст вопроса: по центру, макс 3 строки, горизонтальные отступы 30
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            question.title,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.2,
              color: Color(0xB2FFFFFF),
            ),
          ),
        ),

        // после вопроса 16
        const SizedBox(height: 16),

        // список вариантов
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (int i = 0; i < options.length; i++) ...[
                  _OptionTile(
                    option: options[i],
                    selected: selectedOptionId == options[i].id,
                    onTap: () => onSelect(options[i].id),
                  ),
                  if (i != options.length - 1) const SizedBox(height: 16),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // кнопка "ДАЛЕЕ"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD580),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
              ),
              child: saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF59523A),
                      ),
                    )
                  : const Text(
                      'ДАЛЕЕ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.48, // 4%
                        color: Color(0xFF59523A),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final _Option option;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0x29FFFFFF), // #FFFFFF29
          borderRadius: BorderRadius.circular(1000),
        ),
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            // текст слева
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // чек справа при выбранном
            if (selected) ...[
              const SizedBox(width: 16),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.transparent, // без фона
                  border: Border.all(
                    color: const Color(0xFFFFD580), // обводка
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Color(0xFFFFD580), // сама галочка
                ),
              ),
              const SizedBox(width: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onToHome;
  const _EmptyState({required this.onToHome});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Нет активных вопросов',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD580),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'НА ГЛАВНУЮ',
                  style: TextStyle(color: Color(0xFF59523A)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String id;
  final String title;
  const _Question({required this.id, required this.title});
}

class _Option {
  final String id;
  final String label;
  final String value;
  const _Option({required this.id, required this.label, required this.value});
}
