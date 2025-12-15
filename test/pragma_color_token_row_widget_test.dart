import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  testWidgets('renders the label and preview color',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          body: PragmaColorTokenRowWidget(
            token: ModelColorToken(
              label: 'Primary',
              color: '#6750A4',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Hexadecimal'), findsOneWidget);

    final AnimatedContainer preview = tester.widget(
      find.byKey(PragmaColorTokenRowWidget.previewKey),
    );
    final BoxDecoration? decoration = preview.decoration as BoxDecoration?;
    expect(decoration?.color, const Color(0xFF6750A4));
  });

  testWidgets('changes the color and triggers the callback',
      (WidgetTester tester) async {
    ModelColorToken? latest;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: Scaffold(
          body: PragmaColorTokenRowWidget(
            token: ModelColorToken(
              label: 'Accent',
              color: '#FF0000',
            ),
            onChanged: (ModelColorToken token) => latest = token,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '00FF00');
    await tester.pumpAndSettle();

    expect(latest?.color, '#00FF00');

    final DecoratedBox decorated = tester.widget(
      find.byKey(PragmaColorTokenRowWidget.suffixPreviewKey),
    );
    final BoxDecoration? decoration = decorated.decoration as BoxDecoration?;
    expect(decoration?.color, const Color(0xFF00FF00));
  });
}
