import 'package:clean_movie_app/presentation/app/app_scroll_behavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<ScrollController> pumpCarousel(
    WidgetTester tester, {
    ScrollBehavior? scrollBehavior,
  }) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        scrollBehavior: scrollBehavior,
        home: Scaffold(
          body: SizedBox(
            height: 100,
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: 50,
              itemBuilder:
                  (_, index) => SizedBox(width: 100, child: Text('$index')),
            ),
          ),
        ),
      ),
    );
    return controller;
  }

  for (final kind in [PointerDeviceKind.mouse, PointerDeviceKind.trackpad]) {
    testWidgets('arrastar com ${kind.name} rola a lista horizontal', (
      tester,
    ) async {
      final controller = await pumpCarousel(
        tester,
        scrollBehavior: const AppScrollBehavior(),
      );

      await tester.drag(
        find.byType(ListView),
        const Offset(-300, 0),
        kind: kind,
      );
      await tester.pumpAndSettle();

      expect(controller.offset, greaterThan(0));
    });
  }

  testWidgets('sem o AppScrollBehavior o mouse não rola a lista', (
    tester,
  ) async {
    final controller = await pumpCarousel(tester);

    await tester.drag(
      find.byType(ListView),
      const Offset(-300, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();

    expect(controller.offset, 0);
  });
}