library shimmer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum ShimmerDirection { ltr, rtl, ttb, btt }

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;

  Shimmer({
    Key key,
    @required this.child,
    @required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
  }) : super(key: key);

  Shimmer.fromColors(
      {Key key,
      @required this.child,
      @required Color baseColor,
      @required Color highlightColor,
      this.period = const Duration(milliseconds: 1500),
      this.direction = ShimmerDirection.ltr})
      : gradient = LinearGradient(
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
        super(key: key) {
    if (period.inMilliseconds != null &&
        period.inMilliseconds < Duration(milliseconds: 0).inMilliseconds) {
      throw _ShimmerException("Period cannot be negative, recieved $period");
    }
  }

  @override
  _ShimmerState createState() => _ShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(new DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(new EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(new DiagnosticsProperty<Duration>('period', period,
        defaultValue: null));
  }
}

class _ShimmerState extends State<Shimmer> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.period)
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
      direction: widget.direction,
      gradient: widget.gradient,
      percent: controller.value,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

@visibleForTesting
class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  _Shimmer({Widget child, this.percent, this.direction, this.gradient})
      : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
  }
}

@visibleForTesting
class _ShimmerFilter extends RenderProxyBox {
  final _clearPaint = Paint();
  final Paint _gradientPaint;
  final Gradient _gradient;
  final ShimmerDirection _direction;
  double _percent;
  Rect _rect;

  _ShimmerFilter(this._percent, this._direction, this._gradient)
      : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

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
      Rect rect;
      double dx, dy;
      if (_direction == ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
      } else if (_direction == ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(offset.dx, offset.dy - height, width, 3 * height);
      } else if (_direction == ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(offset.dx, offset.dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
      }
      if (_rect != rect) {
        _gradientPaint.shader = _gradient.createShader(rect);
        _rect = rect;
      }

      context.canvas.saveLayer(offset & child.size, _clearPaint);
      context.paintChild(child, offset);
      context.canvas.translate(dx, dy);
      context.canvas.drawRect(rect, _gradientPaint);
      context.canvas.restore();
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}

class _ShimmerException implements Exception {
  String cause;
  _ShimmerException([this.cause]);

  @override
  String toString() {
    if (cause == null) return "Exception";
    return "ShimmerException: $cause";
  }
}
