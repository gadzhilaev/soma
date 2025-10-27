import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../../settings/models.dart';
import '../../generated/l10n.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ProgramPlayerScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final List<ProgramStep> steps;
  final int initialStepIndex;

  // доп. параметр на случай, если шагов нет: аудио всей программы
  final String? programAudioUrl;

  const ProgramPlayerScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    this.steps = const [],
    this.initialStepIndex = 0,
    this.programAudioUrl,
  });

  @override
  State<ProgramPlayerScreen> createState() => _ProgramPlayerScreenState();
}

class _ProgramPlayerScreenState extends State<ProgramPlayerScreen> {
  final _player = AudioPlayer();
  late final PageController _pageCtrl;
  late int _currentIndex;

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration?>? _durSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<SequenceState?>? _seqSub;

  bool get _hasSteps => widget.steps.isNotEmpty;

  bool _fav = false; // звезда избранного
  double _dotProgress = 0.0; // прогресс для анимации точек (как на Home)

  @override
  void initState() {
    super.initState();
    _currentIndex = _hasSteps
        ? widget.initialStepIndex.clamp(0, widget.steps.length - 1)
        : 0;
    _pageCtrl = PageController(initialPage: _currentIndex);

    // прогресс для анимации точек
    _pageCtrl.addListener(() {
      final p = _pageCtrl.page;
      if (p == null) return;
      final delta = p - _currentIndex; // -1..+1 между соседними страницами
      final prog = delta.clamp(-1.0, 1.0);
      if (prog != _dotProgress) setState(() => _dotProgress = prog);
    });

    _initAudio();
  }

  Future<void> _initAudio() async {
    // безопасная конфигурация аудио-сессии только там, где плагин есть
    try {
      if (!kIsWeb &&
          (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.music());
      }
    } catch (_) {
      // проглатываем: на неподдержанных платформах/в раннем старте может бросить
    }

    // источник(и) аудио
    if (_hasSteps) {
      final children = <AudioSource>[];
      for (final s in widget.steps) {
        final url = s.audioUrl;
        if (url != null && url.isNotEmpty) {
          children.add(AudioSource.uri(Uri.parse(url)));
        }
      }
      if (children.isNotEmpty) {
        await _player.setAudioSource(
          ConcatenatingAudioSource(children: children),
        );
        await _player.seek(Duration.zero, index: _currentIndex);
      }
    } else {
      final url = widget.programAudioUrl;
      if (url != null && url.isNotEmpty) {
        await _player.setUrl(url);
      }
    }

    // подписки
    _posSub = _player.positionStream.listen(
      (d) => setState(() => _position = d),
    );
    _durSub = _player.durationStream.listen(
      (d) => setState(() => _duration = d ?? Duration.zero),
    );
    _stateSub = _player.playerStateStream.listen((st) {
      setState(
        () => _isPlaying =
            st.playing && st.processingState == ProcessingState.ready,
      );
    });
    _seqSub = _player.sequenceStateStream.listen((seq) {
      if (_hasSteps &&
          seq?.currentIndex != null &&
          seq!.currentIndex != _currentIndex) {
        setState(() => _currentIndex = seq.currentIndex);
        if (_pageCtrl.hasClients) _pageCtrl.jumpToPage(_currentIndex);
      }
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _seqSub?.cancel();
    _player.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hh = d.inHours;
    if (hh > 0) return '${hh.toString().padLeft(2, '0')}:$mm:$ss';
    return '$mm:$ss';
  }

  Future<void> _ensureIndexSelected() async {
    if (_hasSteps) {
      final curr = _player.sequenceState?.currentIndex;
      if (curr != _currentIndex) {
        await _player.seek(Duration.zero, index: _currentIndex);
      }
    }
  }

  Future<void> _playCurrent() async {
    await _ensureIndexSelected();
    await _player.play();
  }

  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _playCurrent(); // ← только по кнопке начинаем воспроизведение
    }
  }

  Future<void> _rewind() async {
    // перемотка на 10 сек назад
    final newPos = _position - const Duration(seconds: 10);
    await _player.seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  Future<void> _forward() async {
    // перемотка на 10 сек вперёд
    final total = _duration.inMilliseconds == 0 ? null : _duration;
    final target = _position + const Duration(seconds: 10);
    if (total != null && target > total) {
      await _player.seek(total);
    } else {
      await _player.seek(target);
    }
  }

  Future<void> _seekToSlider(double v) async {
    if (_duration.inMilliseconds == 0) return;
    final target = _duration * v;
    await _player.seek(target);
  }

  @override
  Widget build(BuildContext context) {
    const overlay40 = Color(0x66000000);
    const trackBg = Color(0x33000000);
    const filled = Color(0xFFC3C3C3);
    const thumb = Color(0xFFEDEDED);

    final title = widget.title.toUpperCase();
    final currStep = _hasSteps ? widget.steps[_currentIndex] : null;

    final sliderValue = (_duration.inMilliseconds == 0)
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return Scaffold(
      backgroundColor: Colors.white, // ← фон экрана полностью белый
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tight(Size(32, 32)),
                splashRadius: 32,
                onPressed: () => setState(() => _fav = !_fav),
                icon: Icon(
                  _fav ? Icons.star : Icons.star_border,
                  size: 32,
                  color: const Color(0xFFFFD580),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // отступ после белого бара
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // фон
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),

                // 2) легкое общее затемнение
                Container(color: Colors.black.withOpacity(0.2)),

                // 3) НИЖНИЙ ГРАДИЕНТ-ФОН (НЕ участвует в лейауте)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  // подберите высоту, чтобы накрыть область шагов + точки
                  height: 360,
                  child: IgnorePointer(
                    // чтобы не перехватывал жесты
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                            Colors.black87,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Контент
                SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      const Spacer(),

                      // ← • ▶ • →
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CircleButton(
                            size: 40,
                            bg: const Color(0x66000000),
                            icon: Icons.replay_10,
                            iconSize: 24,
                            iconColor: Colors.white,
                            onTap: _rewind,
                          ),
                          const SizedBox(width: 20),
                          _CircleButton(
                            size: 80,
                            bg: const Color(0x66000000),
                            icon: _player.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            iconSize: 32,
                            iconColor: Colors.white,
                            onTap: _togglePlay,
                          ),
                          const SizedBox(width: 20),
                          _CircleButton(
                            size: 40,
                            bg: const Color(0x66000000),
                            icon: Icons.forward_10,
                            iconSize: 24,
                            iconColor: Colors.white,
                            onTap: _forward,
                          ),
                        ],
                      ),

                      const SizedBox(height: 84),

                      // Слайдер
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            inactiveTrackColor: const Color(0x33000000),
                            activeTrackColor: const Color(0xFFC3C3C3),
                            thumbColor: const Color(0xFFEDEDED),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: SliderComponentShape.noOverlay,
                            trackShape: const _RoundedTrackShape(),
                          ),
                          child: Slider(
                            min: 0,
                            max: 1,
                            value: (_duration.inMilliseconds == 0)
                                ? 0.0
                                : (_position.inMilliseconds /
                                          _duration.inMilliseconds)
                                      .clamp(0.0, 1.0),
                            onChanged: (v) => _seekToSlider(v),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Время
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
                                color: Colors.white,
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

                      const SizedBox(height: 131),

                      // Заголовок программы
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title.toUpperCase(),
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
                      ),

                      // === ШАГИ: свайпается ТОЛЬКО эта зона ===
                      // === ШАГИ: свайпается ТОЛЬКО эта зона ===
                      if (_hasSteps) ...[
                        const SizedBox(height: 16),

                        // фиксируем высоту зоны карточки шага
                        SizedBox(
                          height:
                              220, // под 113x116 + тексты; при необходимости подправьте
                          child: PageView.builder(
                            controller: _pageCtrl,
                            physics: const PageScrollPhysics(),
                            itemCount: widget.steps.length,
                            onPageChanged: (i) {
                              setState(() {
                                _currentIndex = i;
                                _dotProgress = 0.0;
                              });
                              // НИЧЕГО НЕ ВОСПРОИЗВОДИМ автоматически
                            },
                            itemBuilder: (_, i) {
                              final step = widget.steps[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: _StepCard(
                                  step: step,
                                  index: i,
                                  onListen: () async {
                                    if (_currentIndex != i)
                                      setState(() => _currentIndex = i);
                                    await _playCurrent(); // play только по нажатию
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // точки прогресса шагов (анимация как в Home)
                        Center(
                          child: _DotsConveyor(
                            t: _dotProgress,
                            active: const Color(0xFFEABC60),
                            inactive: const Color(0xFF333333),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
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

// ——— круглая кнопка
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
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}

// ——— карточка шага: с номером «Шаг N» и кнопкой «Слушать»
class _StepCard extends StatelessWidget {
  final ProgramStep step;
  final int index;
  final VoidCallback onListen;

  const _StepCard({
    required this.step,
    required this.index,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //index
        // Шаг N (как в details)
        Text(
          s.stepN(index + 1), // ← локализация "Шаг N"
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 22 / 14, // 22px line-height
            letterSpacing: -0.41,
            color: Color(0xFFBABABA),
          ),
        ),
        const SizedBox(height: 12),

        // Row: картинка слева + текст справа (как в details)
        Row(
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
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onListen,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_outline,
                          size: 24,
                          color: Color(0xFF766DFF),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          s.listen, // ← локализовано
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 19 / 14, // 19px
                            color: Color(0xFF766DFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    final double th = sliderTheme.trackHeight ?? 4;
    final double left = offset.dx;
    final double top = offset.dy + (parentBox.size.height - th) / 2;
    final double width = parentBox.size.width;
    return Rect.fromLTWH(left, top, width, th);
  }
}

// ——— точки
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

class _DotsConveyor extends StatelessWidget {
  final double t; // -1..+1
  final Color active;
  final Color inactive;
  const _DotsConveyor({
    required this.t,
    required this.active,
    required this.inactive,
  });

  double _lerp(double a, double b, double u) => a + (b - a) * u;

  @override
  Widget build(BuildContext context) {
    const dot = 12.0;
    const gap = 8.0;
    const totalW = dot * 3 + gap * 2; // 52
    const leftPos = 0.0;
    const centerPos = dot + gap; // 20
    const rightPos = centerPos + dot + gap; // 40

    final u = t.abs().clamp(0.0, 1.0);
    final dir = t >= 0 ? 1 : -1;

    late double xCurr, xNeighbor, xDepart, xIncoming;
    late Color colCurr, colNeighbor;
    late double aDepart, aIncoming;

    if (dir > 0) {
      // вправо
      xCurr = _lerp(centerPos, leftPos, u);
      xNeighbor = _lerp(rightPos, centerPos, u);
      xDepart = leftPos;
      xIncoming = rightPos;
      colCurr = Color.lerp(active, inactive, u)!;
      colNeighbor = Color.lerp(inactive, active, u)!;
      aDepart = 1.0 - u;
      aIncoming = u;
    } else {
      // влево
      xCurr = _lerp(centerPos, rightPos, u);
      xNeighbor = _lerp(leftPos, centerPos, u);
      xDepart = rightPos;
      xIncoming = leftPos;
      colCurr = Color.lerp(active, inactive, u)!;
      colNeighbor = Color.lerp(inactive, active, u)!;
      aDepart = 1.0 - u;
      aIncoming = u;
    }

    return SizedBox(
      width: totalW,
      height: dot,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: xDepart,
            top: 0,
            child: Opacity(
              opacity: aDepart,
              child: _Dot(color: inactive),
            ),
          ),
          Positioned(
            left: xCurr,
            top: 0,
            child: _Dot(color: colCurr),
          ),
          Positioned(
            left: xNeighbor,
            top: 0,
            child: _Dot(color: colNeighbor),
          ),
          Positioned(
            left: xIncoming,
            top: 0,
            child: Opacity(
              opacity: aIncoming,
              child: _Dot(color: inactive),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
