import 'package:shimmer/shimmer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Shimmer.fromColors() can be constructed',
      (WidgetTester tester) async {
    await tester.pumpWidget(Shimmer.fromColors(
        child: Container(
          width: 100.0,
          height: 100.0,
        ),
        baseColor: Colors.red,
        highlightColor: Colors.yellow));
  });
}
