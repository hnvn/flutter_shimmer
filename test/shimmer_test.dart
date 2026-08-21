import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  const Color baseColor = Color(0xFFFF0000);
  const Color highlightColor = Color(0xFFFFFF00);

  Widget buildShimmer({
    Key? key,
    Widget? child,
    Duration period = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.ltr,
    int loop = 0,
    bool enabled = true,
    Gradient? gradient,
  }) {
    final Widget content = child ??
        const SizedBox(
          key: Key('shimmer-child'),
          width: 100.0,
          height: 100.0,
        );
    final Widget shimmer = gradient != null
        ? Shimmer(
            key: key,
            gradient: gradient,
            period: period,
            direction: direction,
            loop: loop,
            enabled: enabled,
            child: content,
          )
        : Shimmer.fromColors(
            key: key,
            baseColor: baseColor,
            highlightColor: highlightColor,
            period: period,
            direction: direction,
            loop: loop,
            enabled: enabled,
            child: content,
          );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: shimmer,
    );
  }

  testWidgets('Shimmer.fromColors() can be constructed',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer());
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('default constructor accepts a custom gradient',
      (WidgetTester tester) async {
    const LinearGradient gradient = LinearGradient(
      colors: <Color>[Colors.black, Colors.white],
    );

    await tester.pumpWidget(buildShimmer(gradient: gradient));

    final Shimmer shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    expect(shimmer.gradient, gradient);
  });

  testWidgets('fromColors builds a five-stop linear gradient',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer());

    final Shimmer shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    expect(shimmer.gradient, isA<LinearGradient>());
    final LinearGradient gradient = shimmer.gradient as LinearGradient;
    expect(gradient.colors, const <Color>[
      baseColor,
      baseColor,
      highlightColor,
      baseColor,
      baseColor,
    ]);
    expect(gradient.stops, const <double>[0.0, 0.35, 0.5, 0.65, 1.0]);
  });

  testWidgets('renders the provided child', (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer(
      child: const Text('Loading'),
    ));

    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('uses expected defaults', (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer());

    final Shimmer shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    expect(shimmer.direction, ShimmerDirection.ltr);
    expect(shimmer.period, const Duration(milliseconds: 1500));
    expect(shimmer.loop, 0);
    expect(shimmer.enabled, isTrue);
  });

  testWidgets('animates when enabled', (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer());
    await tester.pump();

    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('does not animate when disabled', (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer(enabled: false));
    await tester.pump();

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('pauses and resumes when enabled changes',
      (WidgetTester tester) async {
    const Key key = Key('shimmer');
    await tester.pumpWidget(buildShimmer(key: key));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpWidget(buildShimmer(key: key, enabled: false));
    await tester.pump();
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(buildShimmer(key: key));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('keeps running after the first cycle when loop is 0',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildShimmer(period: const Duration(milliseconds: 50)),
    );
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('stops after the requested number of loops',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer(
      period: const Duration(milliseconds: 50),
      loop: 2,
    ));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('restarts a finished loop when enabled is toggled back on',
      (WidgetTester tester) async {
    const Key key = Key('shimmer');
    await tester.pumpWidget(buildShimmer(
      key: key,
      loop: 1,
      period: const Duration(milliseconds: 50),
    ));
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(buildShimmer(
      key: key,
      loop: 1,
      period: const Duration(milliseconds: 50),
      enabled: false,
    ));
    await tester.pumpWidget(buildShimmer(
      key: key,
      loop: 1,
      period: const Duration(milliseconds: 50),
    ));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('applies a new period without restarting the animation',
      (WidgetTester tester) async {
    const Key key = Key('shimmer');
    await tester.pumpWidget(buildShimmer(
      key: key,
      loop: 1,
      period: const Duration(milliseconds: 500),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpWidget(buildShimmer(
      key: key,
      loop: 1,
      period: const Duration(milliseconds: 1000),
    ));
    await tester.pump(const Duration(milliseconds: 250));
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('does not rebuild the child on every animation tick',
      (WidgetTester tester) async {
    final _BuildCounter counter = _BuildCounter();

    await tester.pumpWidget(buildShimmer(child: _BuildTracker(counter: counter)));
    await tester.pump();
    final int buildsAfterMount = counter.builds;

    await tester.pump(const Duration(milliseconds: 100));
    expect(counter.builds, buildsAfterMount);
  });

  testWidgets('debugFillProperties includes shimmer configuration',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildShimmer(
      direction: ShimmerDirection.rtl,
      loop: 3,
      enabled: false,
    ));

    final Shimmer shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    shimmer.debugFillProperties(builder);

    final Map<String, String?> values = <String, String?>{
      for (final DiagnosticsNode node in builder.properties)
        if (node.name != null) node.name!: node.toDescription(),
    };

    expect(values['direction'], contains('rtl'));
    expect(values['loop'], '3');
    expect(values['enabled'], 'false');
    expect(values['period'], isNotNull);
    expect(values['gradient'], isNotNull);
  });

  group('shimmerHighlightRect', () {
    const Size size = Size(100.0, 40.0);

    test('ltr travels from left to right', () {
      final Rect start = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.ltr,
        percent: 0.0,
      );
      final Rect end = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.ltr,
        percent: 1.0,
      );

      expect(start, const Rect.fromLTWH(-200.0, 0.0, 300.0, 40.0));
      expect(end, const Rect.fromLTWH(0.0, 0.0, 300.0, 40.0));
      expect(end.left, greaterThan(start.left));
    });

    test('rtl travels from right to left', () {
      final Rect start = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.rtl,
        percent: 0.0,
      );
      final Rect end = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.rtl,
        percent: 1.0,
      );

      expect(start, const Rect.fromLTWH(0.0, 0.0, 300.0, 40.0));
      expect(end, const Rect.fromLTWH(-200.0, 0.0, 300.0, 40.0));
      expect(end.left, lessThan(start.left));
    });

    test('ttb travels from top to bottom', () {
      final Rect start = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.ttb,
        percent: 0.0,
      );
      final Rect end = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.ttb,
        percent: 1.0,
      );

      expect(start, const Rect.fromLTWH(0.0, -80.0, 100.0, 120.0));
      expect(end, const Rect.fromLTWH(0.0, 0.0, 100.0, 120.0));
      expect(end.top, greaterThan(start.top));
    });

    test('btt travels from bottom to top', () {
      final Rect start = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.btt,
        percent: 0.0,
      );
      final Rect end = shimmerHighlightRect(
        size: size,
        direction: ShimmerDirection.btt,
        percent: 1.0,
      );

      expect(start, const Rect.fromLTWH(0.0, 0.0, 100.0, 120.0));
      expect(end, const Rect.fromLTWH(0.0, -80.0, 100.0, 120.0));
      expect(end.top, lessThan(start.top));
    });
  });
}

class _BuildCounter {
  int builds = 0;
}

class _BuildTracker extends StatelessWidget {
  const _BuildTracker({required this.counter});

  final _BuildCounter counter;

  @override
  Widget build(BuildContext context) {
    counter.builds++;
    return const SizedBox(width: 100.0, height: 100.0);
  }
}
