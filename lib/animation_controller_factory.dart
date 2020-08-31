import 'package:flutter/material.dart';

abstract class AnimationControllerFactory {
  AnimationController controller(TickerProvider provider);
  const AnimationControllerFactory();
}

class PackageAnimationControllerFactory extends AnimationControllerFactory {
  final Duration period;
  const PackageAnimationControllerFactory(
      {this.period = const Duration(milliseconds: 1500)})
      : super();

  @override
  AnimationController controller(TickerProvider provider) {
    return AnimationController(vsync: provider, duration: period);
  }
}
