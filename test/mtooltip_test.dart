import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtooltip/mtooltip.dart';

void main() {
  testWidgets('MTooltip to render its child', (tester) async {
    final controller = MTooltipController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return MTooltip(
              context: context,
              mTooltipController: controller,
              tooltipContent: const Text('tooltip-content'),
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              child: const Text('tooltip-child'),
            );
          }),
        ),
      ),
    );

    expect(find.text('tooltip-child'), findsOneWidget);
  });

  testWidgets('MTooltip- show and remove via controller', (tester) async {
    final controller = MTooltipController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return MTooltip(
              context: context,
              mTooltipController: controller,
              tooltipContent: const Text('tooltip-content'),
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              child: const Text('tooltip-child'),
            );
          }),
        ),
      ),
    );

    expect(find.text('tooltip-content'), findsNothing);

    controller.show();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('tooltip-content'), findsOneWidget);

    controller.remove();
    await tester.pumpAndSettle();
    expect(find.text('tooltip-content'), findsNothing);
  });

  testWidgets('MTooltip show and dismiss action', (tester) async {
    final controller = MTooltipController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return MTooltip(
              context: context,
              mTooltipController: controller,
              tooltipContent: const Text('auto-dismiss-content'),
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              showDuration: const Duration(milliseconds: 100),
              child: const Text('tooltip-child'),
            );
          }),
        ),
      ),
    );

    controller.show();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('auto-dismiss-content'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    controller.remove();
    await tester.pumpAndSettle();
    expect(find.text('auto-dismiss-content'), findsNothing);
  });
}
