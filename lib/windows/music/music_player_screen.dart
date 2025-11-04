import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String audioUrl;

  const MusicPlayerScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.audioUrl,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final _player = AudioPlayer();

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration?>? _durSub;

  bool _fav = false; // звезда избранного

  @override
  void initState() {
    super.initState();
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

    // источник аудио
    if (widget.audioUrl.isNotEmpty) {
      await _player.setUrl(widget.audioUrl);
    }

    // подписки
    _posSub = _player.positionStream.listen(
      (d) => setState(() => _position = d),
    );
    _durSub = _player.durationStream.listen(
      (d) => setState(() => _duration = d ?? Duration.zero),
    );
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hh = d.inHours;
    if (hh > 0) return '${hh.toString().padLeft(2, '0')}:$mm:$ss';
    return '$mm:$ss';
  }

  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
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
                  color: AppColors.accent,
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
                // фон - картинка растянута под экран по центру
                if (widget.imageUrl.isNotEmpty)
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.music_note, size: 64, color: Colors.white70),
                      ),
                    ),
                  )
                else
                  Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.music_note, size: 64, color: Colors.white70),
                    ),
                  ),

                // общее легкое затемнение
                Container(color: const Color.fromRGBO(0, 0, 0, 0.2)),

                // затемнение снизу для читаемости текста
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 200,
                  child: IgnorePointer(
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
                                : Icons.play_arrow_outlined,
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
                              style: AppTextStyles.playerTime,
                            ),
                            const Spacer(),
                            Text(
                              _fmt(_duration),
                              style: AppTextStyles.playerTime,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Название музыки
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 56),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title.toUpperCase(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.playerTitle,
                          ),
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

