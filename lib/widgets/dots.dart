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
  final double t;       // от -1 до +1 (как у тебя)
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
    // геометрия ровно как у твоего 2-точечного варианта: ●─8─●─8─●
    const double dot = 12.0;
    const double gap = 8.0;
    const double totalW = dot * 3 + gap * 2;
    const double leftPos = 0.0;
    const double centerPos = dot + gap;              // 20
    const double rightPos = centerPos + dot + gap;   // 40
    const double step = dot + gap;                   // 20

    final double u = widget.t.abs().clamp(0.0, 1.0);
    final int dir = _stickyDir(widget.t); // +1 вправо, -1 влево

    // Позиции и альфы:
    late double xCurr, xNeighbor, xDepart, xIncoming; // координаты
    late double aDepart, aIncoming;                   // альфы «уходящей» и «приходящей»
    // Цвета: текущая меняет active->inactive, соседняя inactive->active.
    // Уходящая и приходящая — неактивные (как фоновые).
    final Color colCurr = Color.lerp(widget.active, widget.inactive, u)!;
    final Color colNeighbor = Color.lerp(widget.inactive, widget.active, u)!;

    if (dir > 0) {
      // свайп ВПРАВО:
      // центр -> лево, правая -> центр, левая исчезает, новая точка появляется справа от rightPos
      xCurr     = _lerp(centerPos, leftPos, u);
      xNeighbor = _lerp(rightPos,  centerPos, u);
      xDepart   = leftPos;
      xIncoming = rightPos + step;

      aDepart   = 1.0 - u;   // левая исчезает
      aIncoming = u;         // правая «из ниоткуда» проявляется
    } else {
      // свайп ВЛЕВО:
      // центр -> право, левая -> центр, правая исчезает, новая точка появляется слева от leftPos
      xCurr     = _lerp(centerPos, rightPos, u);
      xNeighbor = _lerp(leftPos,  centerPos, u);
      xDepart   = rightPos;
      xIncoming = leftPos - step;

      aDepart   = 1.0 - u;   // правая исчезает
      aIncoming = u;         // левая «из ниоткуда» проявляется
    }

    return SizedBox(
      width: totalW,
      height: dot,
      child: Stack(
        clipBehavior: Clip.none, // чтобы «приходящая» могла появляться из-за границы
        children: [
          // Уходящая неактивная точка (на краю) — просто плавно исчезает
          Positioned(
            left: xDepart,
            top: 0,
            child: Opacity(
              opacity: aDepart,
              child: _Dot(color: widget.inactive),
            ),
          ),

          // Текущая (центр -> край) с переходом active -> inactive
          Positioned(
            left: xCurr,
            top: 0,
            child: _Dot(color: colCurr),
          ),

          // Соседняя (край -> центр) с переходом inactive -> active
          Positioned(
            left: xNeighbor,
            top: 0,
            child: _Dot(color: colNeighbor),
          ),

          // Приходящая неактивная точка — появляется из-за границы и проявляется
          Positioned(
            left: xIncoming,
            top: 0,
            child: Opacity(
              opacity: aIncoming,
              child: _Dot(color: widget.inactive),
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