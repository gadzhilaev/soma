import 'package:flutter/material.dart';
import '../../settings/models.dart';

class ProgramPlayerScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final List<ProgramStep> steps;      // может быть пустым => одна дорожка «программы»
  final int initialStepIndex;         // если запущен конкретный шаг

  const ProgramPlayerScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    this.steps = const [],
    this.initialStepIndex = 0,
  });

  @override
  State<ProgramPlayerScreen> createState() => _ProgramPlayerScreenState();
}

class _ProgramPlayerScreenState extends State<ProgramPlayerScreen> {
  late final PageController _pageCtrl;
  late int _currentIndex;

  bool _isPlaying = false;
  double _progress = 0.0;       // 0..1
  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 12); // заглушка длительности

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget.steps.isEmpty)
        ? 0
        : widget.initialStepIndex.clamp(0, widget.steps.length - 1);
    _pageCtrl = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  // формат времени mm:ss
  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hh = d.inHours;
    if (hh > 0) {
      return '${hh.toString().padLeft(2, '0')}:$mm:$ss';
    }
    return '$mm:$ss';
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _prev() {
    if (widget.steps.isEmpty) {
      // одиночная дорожка — можно перемотать прогрессом
      setState(() {
        _progress = (_progress - 0.05).clamp(0.0, 1.0);
        _position = _duration * _progress;
      });
    } else if (_currentIndex > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _next() {
    if (widget.steps.isEmpty) {
      setState(() {
        _progress = (_progress + 0.05).clamp(0.0, 1.0);
        _position = _duration * _progress;
      });
    } else if (_currentIndex < widget.steps.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSteps = widget.steps.isNotEmpty;

    // цвета по ТЗ
    const overlay40 = Color(0x66000000); // #0000004D (около 30%), но возьмем 40% = 0x66
    const trackBg = Color(0x33000000);   // #00000033
    const filled = Color(0xFFC3C3C3);    // заполненная часть
    const thumb = Color(0xFFEDEDED);     // кружок ползунка

    final title = widget.title.toUpperCase();
    final step = hasSteps ? widget.steps[_currentIndex] : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF282828)),
        ),
        title: SizedBox(
          width: 48,
          height: 50,
          child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
        ),
        actions: const [
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // фоновая картинка
          Image.network(widget.imageUrl, fit: BoxFit.cover),

          // затемняющий слой слегка, чтобы контролы были читаемы
          Container(color: Colors.black.withOpacity(0.15)),

          // Контент
          SafeArea(
            child: LayoutBuilder(
              builder: (ctx, cons) {

                return Column(
                  children: [
                    // центр: кнопки ← • ▶ • →
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // левый кружок 40
                        _CircleButton(
                          size: 40,
                          bg: overlay40,
                          icon: Icons.skip_previous,
                          iconSize: 24,
                          iconColor: Colors.white,
                          onTap: _prev,
                        ),
                        const SizedBox(width: 20),
                        // центральный 80
                        _CircleButton(
                          size: 80,
                          bg: overlay40,
                          icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                          iconSize: 32,
                          iconColor: Colors.white,
                          onTap: _togglePlay,
                        ),
                        const SizedBox(width: 20),
                        // правый кружок 40
                        _CircleButton(
                          size: 40,
                          bg: overlay40,
                          icon: Icons.skip_next,
                          iconSize: 24,
                          iconColor: Colors.white,
                          onTap: _next,
                        ),
                      ],
                    ),

                    // ползунок (отступ 84)
                    const SizedBox(height: 84),

                    // кастомный слайдер (с отступами по 40)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          inactiveTrackColor: trackBg,
                          activeTrackColor: filled,
                          thumbColor: thumb,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8, // диаметр ≈16
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                          trackShape: const _RoundedTrackShape(),
                        ),
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: _progress,
                          onChanged: (v) {
                            setState(() {
                              _progress = v;
                              _position = _duration * _progress;
                            });
                            // TODO: перемотка плеера
                          },
                        ),
                      ),
                    ),

                    // время (отступ 12)
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Text(
                            _fmt(_position),
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.0,
                              color: Colors.white, // текст белый
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _fmt(_duration),
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // отступ 131
                    const SizedBox(height: 131),

                    // Заголовок программы
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // если есть шаги — показываем текущий
                    if (hasSteps) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _StepCard(step: step!),
                      ),
                      const SizedBox(height: 16),
                      // пагинация по шагам (точки) + перелистывание
                      SizedBox(
                        height: 8 + 12, // немножко высоты под точки
                        child: Center(
                          child: _Dots(
                            count: widget.steps.length,
                            index: _currentIndex,
                            active: const Color(0xFFEABC60),
                            inactive: const Color(0xFFF1F1F1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // скрытый PageView (для свайпа между шагами)
                      SizedBox(
                        height: 0, // невидим, но держит логику свайпа
                        child: PageView.builder(
                          controller: _pageCtrl,
                          onPageChanged: (i) {
                            setState(() {
                              _currentIndex = i;
                              // TODO: при смене шага — подменять аудио
                              _isPlaying = false;
                              _progress = 0;
                              _position = Duration.zero;
                            });
                          },
                          itemCount: widget.steps.length,
                          itemBuilder: (_, __) => const SizedBox.shrink(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Виджет круглой кнопки
class _CircleButton extends StatelessWidget {
  final double size;
  final Color bg;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.size,
    required this.bg,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

// ——— Одна карточка шага (как в details, только на прозрачном фоне)
class _StepCard extends StatelessWidget {
  final ProgramStep step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            step.imageUrl,
            width: 113,
            height: 116,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                step.description,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ——— скруглённый трек под слайдер
class _RoundedTrackShape extends RoundedRectSliderTrackShape {
  const _RoundedTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

// ——— простые точки пагинации
class _Dots extends StatelessWidget {
  final int count;
  final int index;
  final Color active;
  final Color inactive;

  const _Dots({
    required this.count,
    required this.index,
    required this.active,
    required this.inactive,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(count, (i) {
        final color = i == index ? active : inactive;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }),
    );
  }
}