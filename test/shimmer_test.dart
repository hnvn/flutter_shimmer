import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/animation_controller_factory.dart';
import 'package:shimmer/shimmer.dart';

import 'moc.dart';

void main() {
  Future<void> _prepareWidgetFor(
      WidgetTester tester,
      AnimationControllerFactory animationControllerFactory,
      ShimmerState state) async {
    await tester.pumpWidget(
      Shimmer.fromColors(
          child: Container(
            width: 100.0,
            height: 100.0,
          ),
          animationControllerFactory: animationControllerFactory,
          shimmerState: state,
          baseColor: Colors.red,
          highlightColor: Colors.yellow),
    );
  }

  testWidgets('Shimmer.fromColors() can be constructed',
      (WidgetTester tester) async {
    await tester.pumpWidget(Shimmer.fromColors(
        child: Container(
          width: 100.0,
          height: 100.0,
        ),
        animationControllerFactory: TestPackageAnimationController(),
        baseColor: Colors.red,
        highlightColor: Colors.yellow));
  });

  testWidgets('Shimmer stopped state', (WidgetTester tester) async {
    final TestPackageAnimationController animationControllerFactory =
        TestPackageAnimationController();
    final AnimationController animationController =
        animationControllerFactory.moc;

    await _prepareWidgetFor(
        tester, animationControllerFactory, ShimmerState.stopped);

    expect(find.byType(AnimatedBuilder), findsNothing);
    expect(animationController.isAnimating, false);
  });

  testWidgets('Shimmer running state', (WidgetTester tester) async {
    final TestPackageAnimationController animationControllerFactory =
        TestPackageAnimationController();
    final AnimationController animationController =
        animationControllerFactory.moc;
    await _prepareWidgetFor(
        tester, animationControllerFactory, ShimmerState.running);

    expect(find.byType(AnimatedBuilder), findsOneWidget);
    expect(animationController.isAnimating, true);
  });
}
