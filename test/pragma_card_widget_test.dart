import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme ??
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('renders header, body, and actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        PragmaCardWidget(
          title: 'Estado',
          subtitle: 'Actualizado hoy',
          body: const Text('Detalle principal'),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: const Text('Abrir'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Estado'), findsOneWidget);
    expect(find.text('Actualizado hoy'), findsOneWidget);
    expect(find.text('Detalle principal'), findsOneWidget);
    expect(find.text('Abrir'), findsOneWidget);
  });

  testWidgets('small size applies compact padding',
      (WidgetTester tester) async {
    const Key bodyKey = ValueKey<String>('card-body');
    await tester.pumpWidget(
      wrap(
        const PragmaCardWidget(
          body: Text('Contenido compacto', key: bodyKey),
          size: PragmaCardSize.small,
        ),
      ),
    );

    final Finder paddingFinder = find.ancestor(
      of: find.byKey(bodyKey),
      matching: find.byType(Padding),
    );
    final Padding padding = tester.widget<Padding>(paddingFinder.first);

    expect(
      padding.padding,
      PragmaSpacing.insetSymmetric(
        horizontal: PragmaSpacing.lg,
        vertical: PragmaSpacing.md,
      ),
    );
  });

  testWidgets('tonal variant honors the color scheme',
      (WidgetTester tester) async {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    );
    const ValueKey<String> cardKey = ValueKey<String>('tonal-card');

    await tester.pumpWidget(
      wrap(
        const PragmaCardWidget(
          key: cardKey,
          body: SizedBox.shrink(),
          variant: PragmaCardVariant.tonal,
        ),
        theme: theme,
      ),
    );

    final Finder materialFinder = find.descendant(
      of: find.byKey(cardKey),
      matching: find.byType(Material),
    );
    final Material material = tester.widget<Material>(materialFinder.first);

    expect(material.color, theme.colorScheme.secondaryContainer);
  });

  testWidgets('tap callback is triggered', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      wrap(
        PragmaCardWidget(
          body: const Text('Tap me'),
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Tap me'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
