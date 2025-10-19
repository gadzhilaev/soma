// lib/onboarding/questions_screen.dart
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  bool q1 = false;
  bool q2 = false;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Немного вопросов',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Пример вопросов
                _QuestionTile(
                  title: 'Вопрос #1 (пример)',
                  value: q1,
                  onChanged: (v) => setState(() => q1 = v ?? false),
                ),
                const SizedBox(height: 12),
                _QuestionTile(
                  title: 'Вопрос #2 (пример)',
                  value: q2,
                  onChanged: (v) => setState(() => q2 = v ?? false),
                ),

                const Spacer(),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD580),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // тут можно сохранить ответы в БД, если нужно
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );
                    },
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.48,
                        color: Color(0xFF59523A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const _QuestionTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x29FFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        activeColor: const Color(0xFFFFD580), // фон чекбокса
        checkColor: const Color(0xFF59523A),  // цвет галочки
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}