import 'package:flutter/foundation.dart'; // Necesario para FlutterExceptionHandler
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

Future<BuildContext> _pumpHost(WidgetTester tester) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return capturedContext;
}

void main() {
  testWidgets('shows a toast and auto dismisses after its duration',
      (WidgetTester tester) async {
    final BuildContext context = await _pumpHost(tester);

    PragmaToastService.showToast(
      context: context,
      title: 'Guardado',
      message: 'Los cambios fueron aplicados',
      duration: const Duration(milliseconds: 120),
    );

    await tester.pump();
    expect(find.text('Guardado'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Guardado'), findsNothing);
  });

  testWidgets('queues toasts and closing one keeps the rest visible',
      (WidgetTester tester) async {
    final BuildContext context = await _pumpHost(tester);
    bool closePressed = false;

    PragmaToastService.showToast(
      context: context,
      title: 'Primero',
      duration: const Duration(milliseconds: 400),
      onCloseIconPressed: () => closePressed = true,
    );
    final PragmaToastHandle cleanupHandle = PragmaToastService.showToast(
      context: context,
      title: 'Segundo',
      duration: const Duration(milliseconds: 700),
    );

    await tester.pump();
    expect(find.byType(PragmaToastWidget), findsNWidgets(2));

    await tester.tap(find.byTooltip('Cerrar').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(closePressed, isTrue);
    expect(find.text('Primero'), findsNothing);
    expect(find.text('Segundo'), findsOneWidget);

    cleanupHandle.dismiss();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('variants wire up their default icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: Scaffold(
          body: Center(
            child: PragmaToastWidget(
              config: const PragmaToastConfig(
                title: 'Listo',
                variant: PragmaToastVariant.success,
              ),
              onClose: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('manual handles dismiss a toast without user interaction',
      (WidgetTester tester) async {
    final BuildContext context = await _pumpHost(tester);

    final PragmaToastHandle handle = PragmaToastService.showToast(
      context: context,
      title: 'Temporal',
    );

    await tester.pump();
    expect(find.text('Temporal'), findsOneWidget);

    handle.dismiss();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Temporal'), findsNothing);
    expect(handle.isActive, isFalse);
  });

  group('regresión overlays/toasts', () {
    testWidgets(
        'Cerrar toasts de arriba hacia abajo no deja overlays ni errores',
        (WidgetTester tester) async {
      await tester.pumpWidget(const _TestAppToastStack());
      await tester.tap(find.text('Show 3'));
      await tester.pump();

      // Cierra el de arriba
      await tester.tap(find.byTooltip('Cerrar').first);
      await tester.pump(const Duration(milliseconds: 400));
      // Cierra el siguiente
      await tester.tap(find.byTooltip('Cerrar').first);
      await tester.pump(const Duration(milliseconds: 400));
      // Cierra el último
      await tester.tap(find.byTooltip('Cerrar').first);
      await tester.pump(const Duration(milliseconds: 400));

      await tester.pumpAndSettle();
      // Espera incremental tolerante a la animación de salida del Tooltip
      const int maxTries = 30;
      int tries = 0;
      while (
          find.byTooltip('Cerrar').evaluate().isNotEmpty && tries < maxTries) {
        await tester.pump(const Duration(milliseconds: 200));
        tries++;
      }
      expect(find.byTooltip('Cerrar'), findsNothing);
    });

    testWidgets('Cerrar toast del medio y luego otro no deja errores',
        (WidgetTester tester) async {
      FlutterErrorDetails? captured;
      final FlutterExceptionHandler? old = FlutterError.onError;
      try {
        FlutterError.onError = (FlutterErrorDetails details) {
          captured = details;
        };

        await tester.pumpWidget(const _TestAppToastStack());
        await tester.tap(find.text('Show 3'));
        await tester.pump();

        // Cierra el del medio
        await tester.tap(find.byTooltip('Cerrar').at(1));
        await tester.pump(const Duration(milliseconds: 400));
        // Cierra otro
        await tester.tap(find.byTooltip('Cerrar').first);
        await tester.pump(const Duration(milliseconds: 400));
        // Cierra el último
        await tester.tap(find.byTooltip('Cerrar').first);
        await tester.pump(const Duration(milliseconds: 400));

        await tester.pumpAndSettle();
        // Espera incremental tolerante a la animación de salida del Tooltip
        const int maxTries = 30;
        int tries = 0;
        while (find.byTooltip('Cerrar').evaluate().isNotEmpty &&
            tries < maxTries) {
          await tester.pump(const Duration(milliseconds: 200));
          tries++;
        }
        expect(captured, isNull);
        expect(find.byTooltip('Cerrar'), findsNothing);
      } finally {
        FlutterError.onError = old;
      }
    });
  });
}

class _TestAppToastStack extends StatelessWidget {
  const _TestAppToastStack();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              child: const Text('Show 3'),
              onPressed: () {
                for (int i = 0; i < 3; i++) {
                  PragmaToastService.showToast(
                    context: context,
                    title: 'Toast $i',
                    message: 'Mensaje $i',
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
