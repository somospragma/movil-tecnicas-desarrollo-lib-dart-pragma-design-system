import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  testWidgets('edits primary color and emits updated theme',
      (WidgetTester tester) async {
    ModelThemePragma? latest;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PragmaThemeEditorWidget(
            theme: ModelThemePragma(),
            onChanged: (ModelThemePragma value) => latest = value,
          ),
        ),
      ),
    );

    expect(find.text('Constructor de tema'), findsOneWidget);

    final Finder textFieldFinder = find.byType(TextField).first;
    await tester.enterText(textFieldFinder, '123ABC');
    await tester.pumpAndSettle();

    expect(latest, isNotNull);
    expect(latest!.colorFor('primary').color, '#123ABC');
    expect(find.textContaining('typographyFamily'), findsAtLeastNWidgets(1));
  });
}
