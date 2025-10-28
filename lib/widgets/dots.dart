import 'package:flutter/material.dart';

class _DotsConveyor extends StatefulWidget {
  final double t; // -1..+1
  final Color active;
  final Color inactive;

  const _DotsConveyor({
    required this.t,
    required this.active,
    required this.inactive,
  });

  @override
  State<_DotsConveyor> createState() => _DotsConveyorState();
}

class _DotsConveyorState extends State<_DotsConveyor> {
  // последнее «надёжное» направление: 1 — вправо, -1 — влево
  int _lastDir = 1;
  // мёртвая зона вокруг нуля (подбери по ощущениям: 0.05..0.12)
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
    const totalW = dot * 3 + gap * 2; // 52
    const leftPos = 0.0;
    const centerPos = dot + gap;      // 20
    const rightPos = centerPos + dot + gap; // 40

    // плавная доля смещения 0..1 (без смены знака)
    final u = widget.t.abs().clamp(0.0, 1.0);
    // направление с гистерезисом
    final dir = _stickyDir(widget.t);

    late double xCurr, xNeighbor;
    if (dir > 0) {
      // «двигаемся вправо»: центр -> влево, правый -> в центр
      xCurr = _lerp(centerPos, leftPos, u);
      xNeighbor = _lerp(rightPos, centerPos, u);
    } else {
      // «двигаемся влево»: центр -> вправо, левый -> в центр
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
          // фиксированные крайние фоны
          const Positioned(left: leftPos,  top: 0, child: _Dot(color: Colors.transparent)), // «слот», можно убрать
          const Positioned(left: rightPos, top: 0, child: _Dot(color: Colors.transparent)), // «слот», можно убрать

          // текущий (из центра уходит)
          Positioned(left: xCurr, top: 0, child: _Dot(color: colCurr)),
          // сосед (входит в центр)
          Positioned(left: xNeighbor, top: 0, child: _Dot(color: colNeighbor)),
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