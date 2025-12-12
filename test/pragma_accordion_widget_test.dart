import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  testWidgets('PragmaAccordionWidget toggles its body on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PragmaAccordionWidget(
            text: 'Detalle de sprint',
            child: Text('Checklist interno'),
          ),
        ),
      ),
    );

    expect(find.text('Checklist interno'), findsNothing);

    await tester.tap(find.text('Detalle de sprint'));
    await tester.pumpAndSettle();

    expect(find.text('Checklist interno'), findsOneWidget);
  });

  testWidgets('honors the `open` parameter when rebuilding',
      (WidgetTester tester) async {
    Widget buildAccordion({required bool open}) {
      return MaterialApp(
        home: Scaffold(
          body: PragmaAccordionWidget(
            text: 'FAQ',
            open: open,
            child: const Text('Respuesta extendida'),
          ),
        ),
      );
    }

    await tester.pumpWidget(buildAccordion(open: true));
    await tester.pumpAndSettle();
    expect(find.text('Respuesta extendida'), findsOneWidget);

    await tester.pumpWidget(buildAccordion(open: false));
    await tester.pumpAndSettle();
    expect(find.text('Respuesta extendida'), findsNothing);
  });

  testWidgets('notifies listeners via onToggle', (WidgetTester tester) async {
    bool? received;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PragmaAccordionWidget(
            text: 'Estado',
            onToggle: (bool value) => received = value,
            child: const Text('Body'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Estado'));
    await tester.pumpAndSettle();

    expect(received, isTrue);
  });

  testWidgets('disabled accordions ignore taps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PragmaAccordionWidget(
            text: 'Bloqueado',
            disable: true,
            child: Text('No visible'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Bloqueado'));
    await tester.pumpAndSettle();

    expect(find.text('No visible'), findsNothing);
  });
}
