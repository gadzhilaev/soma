import 'package:flutter/material.dart';

/// Анимированные точки для прогресса страниц (как на экране программы)
class DotsConveyor extends StatefulWidget {
  final double t; // от -1 до +1
  final Color active;
  final Color inactive;

  const DotsConveyor({
    super.key,
    required this.t,
    required this.active,
    required this.inactive,
  });

  @override
  State<DotsConveyor> createState() => _DotsConveyorState();
}

class _DotsConveyorState extends State<DotsConveyor> {
  int _lastDir = 1;
  static const double _eps = 0.08;

  int _stickyDir(double t) {
    if (t.abs() >= _eps) {
      _lastDir = t >= 0 ? 1 : -1;
    }
    return _lastDir;
  }

  double _lerp(double a, double b, double u) => a + (b - a) * u;

  @override
  Widget build(BuildContext context) {
    const dot = 12.0;
    const gap = 8.0;
    const totalW = dot * 3 + gap * 2;
    const leftPos = 0.0;
    const centerPos = dot + gap;
    const rightPos = centerPos + dot + gap;

    final u = widget.t.abs().clamp(0.0, 1.0);
    final dir = _stickyDir(widget.t);

    late double xCurr, xNeighbor;
    if (dir > 0) {
      // движемся вправо
      xCurr = _lerp(centerPos, leftPos, u);
      xNeighbor = _lerp(rightPos, centerPos, u);
    } else {
      // движемся влево
      xCurr = _lerp(centerPos, rightPos, u);
      xNeighbor = _lerp(leftPos, centerPos, u);
    }

    final colCurr = Color.lerp(widget.active, widget.inactive, u)!;
    final colNeighbor = Color.lerp(widget.inactive, widget.active, u)!;

    return SizedBox(
      width: totalW,
      height: dot,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(left: leftPos, top: 0, child: Dot(color: Colors.transparent)),
          const Positioned(left: rightPos, top: 0, child: Dot(color: Colors.transparent)),
          Positioned(left: xCurr, top: 0, child: Dot(color: colCurr)),
          Positioned(left: xNeighbor, top: 0, child: Dot(color: colNeighbor)),
        ],
      ),
    );
  }
}

/// Отдельная точка (круг)
class Dot extends StatelessWidget {
  final Color color;
  const Dot({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class DotsConveyor3 extends StatefulWidget {
  final double t; // -1..+1
  final Color active;
  final Color inactive;

  const DotsConveyor3({
    super.key,
    required this.t,
    required this.active,
    required this.inactive,
  });

  @override
  State<DotsConveyor3> createState() => _DotsConveyor3State();
}

class _DotsConveyor3State extends State<DotsConveyor3> {
  // липкое направление + небольшая мёртвая зона, чтобы не дёргалось около 0
  int _lastDir = 1;
  static const double _eps = 0.08;

  int _stickyDir(double t) {
    if (t.abs() >= _eps) _lastDir = t >= 0 ? 1 : -1;
    return _lastDir;
  }

  // плавная интерполяция + сглаживание прогресса (smoothstep)
  double _lerp(double a, double b, double u) => a + (b - a) * u;
  double _smooth(double u) => u * u * (3 - 2 * u); // без задержек на старте/финише

  @override
  Widget build(BuildContext context) {
    // геометрия как в 2-точечной версии: ●─gap─●─gap─●
    const double dot = 12.0;
    const double gap = 8.0;
    const double leftPos   = 0.0;
    const double centerPos = dot + gap;              // 20
    const double rightPos  = centerPos + dot + gap;  // 40
    const double totalW    = rightPos + dot;         // 52

    final int dir  = _stickyDir(widget.t);         // +1 вправо, -1 влево
    final double u = _smooth(widget.t.abs().clamp(0.0, 1.0));

    // Двигаются две точки: центр -> край и край -> центр.
    late double xFromCenterToEdge, xFromEdgeToCenter;
    // Край, где точка «исчезает»
    late double departEdgeX;
    // Противоположный край, где «появляется» новая неактивная точка
    late double appearEdgeX;

    if (dir > 0) {
      // свайп вправо: центр -> ЛЕВО, правая -> ЦЕНТР
      xFromCenterToEdge = _lerp(centerPos, leftPos,  u);
      xFromEdgeToCenter = _lerp(rightPos,  centerPos, u);
      departEdgeX       = leftPos;   // левая исчезает
      appearEdgeX       = rightPos;  // под правой появляется новая
    } else {
      // свайп влево: центр -> ПРАВО, левая -> ЦЕНТР
      xFromCenterToEdge = _lerp(centerPos, rightPos, u);
      xFromEdgeToCenter = _lerp(leftPos,  centerPos, u);
      departEdgeX       = rightPos;  // правая исчезает
      appearEdgeX       = leftPos;   // под левой появляется новая
    }

    // Цвета: текущая тухнет, соседняя загорается
    final Color colToEdge   = Color.lerp(widget.active,   widget.inactive, u)!;
    final Color colToCenter = Color.lerp(widget.inactive, widget.active,   u)!;

    // Прозрачности краёв
    final double aDepart = 1.0 - u; // уходящий край
    final double aAppear = u;       // появляющийся край

    return SizedBox(
      width: totalW,
      height: dot,
      child: Stack(
        clipBehavior: Clip.hardEdge, // ничего не вылетает наружу
        children: [
          // фиктивные «пустые» точки на краях — держат постоянную ширину
          const Positioned(left: leftPos,  top: 0, child: _Dot(color: Colors.transparent)),
          const Positioned(left: rightPos, top: 0, child: _Dot(color: Colors.transparent)),

          // Появляющаяся на краю (под соседней), просто проявляется
          Positioned(
            left: appearEdgeX,
            top: 0,
            child: Opacity(opacity: aAppear, child: _Dot(color: widget.inactive)),
          ),

          // Уходящая на противоположном краю, просто исчезает
          Positioned(
            left: departEdgeX,
            top: 0,
            child: Opacity(opacity: aDepart, child: _Dot(color: widget.inactive)),
          ),

          // Идёт ИЗ центра К краю (ниже по слоям)
          Positioned(left: xFromCenterToEdge, top: 0, child: _Dot(color: colToEdge)),

          // Идёт С края В центр (поверх всего — чтобы не «подпрыгивало» при пересечении)
          Positioned(left: xFromEdgeToCenter, top: 0, child: _Dot(color: colToCenter)),
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
      width: 12, height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}