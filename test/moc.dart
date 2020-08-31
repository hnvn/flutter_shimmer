import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/animation_controller_factory.dart';

class TestPackageAnimationController extends AnimationControllerFactory {
  final AnimationController moc = AnimationController(
      vsync: const TestVSync(), duration: const Duration(seconds: 1));
  @override
  AnimationController controller(TickerProvider provider) {
    return moc;
  }
}
