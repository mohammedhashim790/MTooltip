import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtooltip/MTooltipCard.dart';

void main() {
  testWidgets('Render Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MTooltipCard(
            title: 'Test Title',
            titleColor: Colors.white,
            paginationLimit: 3,
            pagination: 1,
            index: 0,
            onTap: (index) {},
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
    expect(find.byIcon(Icons.navigate_next), findsOneWidget);
  });

  testWidgets('Tap Test',
      (WidgetTester tester) async {
    int tappedIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MTooltipCard(
            title: 'Test Title',
            titleColor: Colors.white,
            paginationLimit: 3,
            pagination: 1,
            index: 2,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.navigate_next));
    expect(tappedIndex, 2);
  });
}
