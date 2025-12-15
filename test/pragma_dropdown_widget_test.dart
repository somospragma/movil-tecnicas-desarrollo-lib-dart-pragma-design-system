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
    PragmaDropdownOption<String>(label: 'Opción 1', value: 'opt1'),
    PragmaDropdownOption<String>(label: 'Opción 2', value: 'opt2'),
  ];

  testWidgets('renders label, hint, and helper text',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        PragmaDropdownWidget<String>(
          label: 'Rol asignado',
          placeholder: 'Selecciona un rol',
          helperText: 'Elige un único rol',
          options: options,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Rol asignado'), findsOneWidget);
    expect(find.text('Selecciona un rol'), findsOneWidget);
    expect(find.text('Elige un único rol'), findsOneWidget);
  });

  testWidgets('exposes error text when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        PragmaDropdownWidget<String>(
          label: 'Squad',
          errorText: 'Dato requerido',
          options: options,
          onChanged: (_) {},
        ),
      ),
    );

    final DropdownButtonFormField<String> field = tester.widget(
      find.byType(DropdownButtonFormField<String>),
    );
    expect(field.decoration.errorText, 'Dato requerido');
  });

  testWidgets('invokes onChanged when selecting an option',
      (WidgetTester tester) async {
    String? selected;

    await tester.pumpWidget(
      wrap(
        PragmaDropdownWidget<String>(
          label: 'Rol',
          placeholder: 'Selecciona',
          options: options,
          onChanged: (String? value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opción 2').last);
    await tester.pumpAndSettle();

    expect(selected, 'opt2');
  });
}
