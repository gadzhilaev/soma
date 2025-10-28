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