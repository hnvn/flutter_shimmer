library shimmer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration period;

  Shimmer(
      {Key key,
        @required this.child,
        this.baseColor = const Color(0xFFBBDEFB),
        this.highlightColor = const Color(0xFF90CAF9),
        this.period = const Duration(milliseconds: 1500)})
      : super(key: key);

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
    AnimationController(vsync: this, duration: widget.period)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: widget.child,
      baseColor: widget.baseColor,
      highlightColor: widget.highlightColor,
      percent: controller.value,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final Color baseColor;
  final Color highlightColor;

  _Shimmer({Widget child, this.percent, this.baseColor, this.highlightColor})
      : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, baseColor, highlightColor);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  final _clearPaint = Paint();
  final Paint _gradientPaint;
  final LinearGradient _gradient;
  double _percent;

  _ShimmerFilter(this._percent, Color baseColor, Color highlightColor)
      : _gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.centerRight,
      colors: [
        baseColor,
        baseColor,
        highlightColor,
        baseColor,
        baseColor
      ],
      stops: [
        0.0,
        0.35,
        0.5,
        0.65,
        1.0
      ]),
        _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue != _percent) {
      _percent = newValue;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);
      final width = child.size.width;
      final height = child.size.height;
      final rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
      _gradientPaint.shader = _gradient.createShader(rect);
      context.canvas.saveLayer(offset & child.size, _clearPaint);
      context.paintChild(child, offset);
      context.canvas.translate(_offset(-width, width, _percent), 0.0);
      context.canvas.drawRect(rect, _gradientPaint);
      context.canvas.restore();
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
