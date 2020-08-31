///
/// * author: hunghd
/// * email: hunghd.yb@gmail.com
///
/// A package provides an easy way to add shimmer effect to Flutter application
///

library shimmer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/animation_controller_factory.dart';

///
/// An enum defines all supported directions of shimmer effect
///
/// * [ShimmerDirection.ltr] left to right direction
/// * [ShimmerDirection.rtl] right to left direction
/// * [ShimmerDirection.ttb] top to bottom direction
/// * [ShimmerDirection.btt] bottom to top direction
///
enum ShimmerDirection { ltr, rtl, ttb, btt }

///
/// An enum defines all supported states of shimmer effect
///
/// * [ShimmerState.running] shimmer effect is presenting and animation is running
/// * [ShimmerState.paused] shimmer effect is presenting and animation is paused
/// * [ShimmerState.stopped] shimmer effect isn't presenting and animation is paused
///
enum ShimmerState {
  running,
  paused,
  stopped,
}

///
/// A widget renders shimmer effect over [child] widget tree.
///
/// [child] defines an area that shimmer effect blends on. You can build [child]
/// from whatever [Widget] you like but there're some notices in order to get
/// exact expected effect and get better rendering performance:
///
/// * Use static [Widget] (which is an instance of [StatelessWidget]).
/// * [Widget] should be a solid color element. Every colors you set on these
/// [Widget]s will be overridden by colors of [gradient].
/// * Shimmer effect only affects to opaque areas of [child], transparent areas
/// still stays transparent.
///
/// [period] controls the speed of shimmer effect. The default value is 1500
/// milliseconds.
///
/// [direction] controls the direction of shimmer effect. The default value
/// is [ShimmerDirection.ltr].
///
/// [gradient] controls colors of shimmer effect.
///
/// [loop] the number of animation loop, set value of `0` to make animation run
/// forever.
///
/// [shimmerState] controls if shimmer effect is active/paused/removed.
/// The default value is [ShimmerState.running].
///
/// ## Pro tips:
///
/// * [child] should be made of basic and simple [Widget]s, such as [Container],
/// [Row] and [Column], to avoid side effect.
///
/// * use one [Shimmer] to wrap list of [Widget]s instead of a list of many [Shimmer]s
///
@immutable
class Shimmer extends StatefulWidget {
  final Widget child;
  final ShimmerDirection direction;
  final ShimmerState shimmerState;
  final Gradient gradient;
  final int loop;
  final AnimationControllerFactory animationControllerFactory;
  const Shimmer({
    Key key,
    this.animationControllerFactory = const PackageAnimationControllerFactory(),
    @required this.child,
    @required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.shimmerState = ShimmerState.running,
    this.loop = 0,
  })  : assert(animationControllerFactory != null),
        assert(child != null),
        assert(gradient != null),
        super(key: key);

  ///
  /// A convenient constructor provides an easy and convenient way to create a
  /// [Shimmer] which [gradient] is [LinearGradient] made up of `baseColor` and
  /// `highlightColor`.
  ///
  Shimmer.fromColors({
    Key key,
    this.animationControllerFactory = const PackageAnimationControllerFactory(),
    @required this.child,
    @required Color baseColor,
    @required Color highlightColor,
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.shimmerState = ShimmerState.running,
  })  : assert(animationControllerFactory != null),
        assert(child != null),
        assert(baseColor != null),
        assert(highlightColor != null),
        gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: const <double>[
              0.0,
              0.35,
              0.5,
              0.65,
              1.0
            ]),
        super(key: key);

  @override
  _ShimmerState createState() => _ShimmerState(animationControllerFactory);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(DiagnosticsProperty<AnimationControllerFactory>(
        'animationControllerFactory', animationControllerFactory,
        defaultValue: PackageAnimationControllerFactory));
    properties.add(DiagnosticsProperty<ShimmerState>(
        'shimmerState', shimmerState,
        defaultValue: null));
  }
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _count;

  _ShimmerState(AnimationControllerFactory factory) {
    _controller = factory.controller(this);
  }

  @override
  void initState() {
    super.initState();
    _count = 0;
    _controller.addStatusListener((AnimationStatus status) {
      if (status != AnimationStatus.completed) {
        return;
      }
      _count++;
      if (widget.loop <= 0) {
        _controller.repeat();
      } else if (_count < widget.loop) {
        _controller.forward(from: 0.0);
      }
    });
    _handleChange(widget.shimmerState);
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    if (oldWidget.shimmerState != widget.shimmerState) {
      _handleChange(widget.shimmerState);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleChange(ShimmerState shimmerState) {
    switch (shimmerState) {
      case ShimmerState.running:
        _controller.forward();
        break;
      case ShimmerState.stopped:
        _controller.reset();
        break;
      case ShimmerState.paused:
        _controller.stop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetToDisplay = widget.child;
    switch (widget.shimmerState) {
      case ShimmerState.running:
      case ShimmerState.paused:
        widgetToDisplay = AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (BuildContext context, Widget child) => _Shimmer(
            child: child,
            direction: widget.direction,
            gradient: widget.gradient,
            percent: _controller.value,
          ),
        );
        break;
      default:
        break;
    }
    return AnimatedSwitcher(
      child: widgetToDisplay,
      duration: const Duration(microseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  const _Shimmer({
    Widget child,
    this.percent,
    this.direction,
    this.gradient,
  }) : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) =>
      _ShimmerFilter(percent, direction, gradient);

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  final ShimmerDirection _direction;

  Gradient _gradient;
  double _percent;

  _ShimmerFilter(this._percent, this._direction, this._gradient);

  @override
  ShaderMaskLayer get layer => super.layer;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    assert(newValue != null);
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    assert(newValue != null);
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child.size.width;
      final double height = child.size.height;
      Rect rect;
      double dx, dy;
      if (_direction == ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();
      layer
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) =>
      start + (end - start) * percent;
}
