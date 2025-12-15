import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  const List<PragmaDropdownOption<String>> options =
      <PragmaDropdownOption<String>>[
    PragmaDropdownOption<String>(label: 'UX Research', value: 'ux'),
    PragmaDropdownOption<String>(label: 'Mobile iOS', value: 'ios'),
  ];

  testWidgets('toggles selection and reports updated values',
      (WidgetTester tester) async {
    List<String>? lastSelection;

    await tester.pumpWidget(
      wrap(
        PragmaDropdownListWidget<String>(
          label: 'Equipo colaborador',
          placeholder: 'Selecciona perfiles',
          options: options,
          onSelectionChanged: (List<String> values) => lastSelection = values,
        ),
      ),
    );

    await tester.tap(find.text('Selecciona perfiles'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('UX Research').last);
    await tester.pumpAndSettle();

    expect(lastSelection, isNotNull);
    expect(lastSelection, contains('ux'));
  });

  testWidgets('removal action clears the option and emits callbacks',
      (WidgetTester tester) async {
    List<String>? lastSelection;
    String? removed;

    await tester.pumpWidget(
      wrap(
        PragmaDropdownListWidget<String>(
          label: 'Equipo colaborador',
          placeholder: 'Selecciona perfiles',
          options: options,
          initialSelectedValues: const <String>['ux'],
          onSelectionChanged: (List<String> values) => lastSelection = values,
          onItemRemoved: (String value) => removed = value,
        ),
      ),
    );

    await tester.tap(find.text('UX Research'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();

    expect(removed, 'ux');
    expect(lastSelection, isNotNull);
    expect(lastSelection, isEmpty);
  });
}
