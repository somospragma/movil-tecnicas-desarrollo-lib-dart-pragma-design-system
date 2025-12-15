import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  String textFieldValue(WidgetTester tester) {
    final TextField field = tester.widget<TextField>(find.byType(TextField));
    return field.controller?.text ?? '';
  }

  testWidgets('keeps the controller and text field in sync',
      (WidgetTester tester) async {
    final PragmaInputController controller = PragmaInputController(
      ModelFieldState(value: 'Inicial'),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        PragmaInputWidget(
          label: 'Nombre',
          controller: controller,
          onChanged: (_) {},
        ),
      ),
    );

    expect(textFieldValue(tester), 'Inicial');

    await tester.enterText(find.byType(TextField), 'Nuevo valor');
    await tester.pumpAndSettle();
    expect(controller.value.value, 'Nuevo valor');

    controller.setValue('Controlador');
    await tester.pumpAndSettle();
    expect(textFieldValue(tester), 'Controlador');
  });

  testWidgets('shows error text when controller exposes one',
      (WidgetTester tester) async {
    final PragmaInputController controller = PragmaInputController(
      ModelFieldState(
        errorText: 'Dato requerido',
        isDirty: true,
        isValid: false,
      ),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        PragmaInputWidget(
          label: 'Proyecto',
          controller: controller,
        ),
      ),
    );

    expect(find.text('Dato requerido'), findsOneWidget);

    controller.setError('Campo obligatorio');
    await tester.pumpAndSettle();
    expect(find.text('Campo obligatorio'), findsOneWidget);
  });

  testWidgets('filters suggestions and selects a value',
      (WidgetTester tester) async {
    final PragmaInputController controller = PragmaInputController(
      ModelFieldState(suggestions: const <String>['Discovery', 'Delivery']),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        PragmaInputWidget(
          label: 'Squad',
          controller: controller,
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'di');
    await tester.pumpAndSettle();

    expect(find.text('Discovery'), findsWidgets);

    await tester.tap(find.text('Discovery').last);
    await tester.pumpAndSettle();

    expect(controller.value.value, 'Discovery');
    expect(textFieldValue(tester), 'Discovery');
  });

  testWidgets('obscure toggle switches the TextField state',
      (WidgetTester tester) async {
    final PragmaInputController controller = PragmaInputController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        PragmaInputWidget(
          label: 'Contraseña',
          controller: controller,
          enablePasswordToggle: true,
          obscureText: true,
        ),
      ),
    );

    TextField field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();

    field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isFalse);
  });
}
