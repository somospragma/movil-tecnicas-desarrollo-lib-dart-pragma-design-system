import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme ??
          ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('renders icon and tooltip', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const PragmaIconButtonWidget(
          icon: Icons.add,
          tooltip: 'Añadir',
          onPressed: _noop,
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byTooltip('Añadir'), findsOneWidget);
  });

  testWidgets('outlined dark style exposes border',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const PragmaIconButtonWidget(
          icon: Icons.close,
          style: PragmaIconButtonStyle.outlinedDark,
          onPressed: _noop,
        ),
      ),
    );

    final IconButton iconButton =
        tester.widget<IconButton>(find.byType(IconButton));
    final ButtonStyle style = iconButton.style!;
    final BorderSide? side =
        style.side!.resolve(<WidgetState>{WidgetState.hovered});
    final BuildContext context =
        tester.element(find.byType(PragmaIconButtonWidget));
    final ColorScheme scheme = Theme.of(context).colorScheme;
    expect(side, isNotNull);
    expect(
      side!.color,
      scheme.onPrimary,
    );
  });

  testWidgets('disabled filled light uses muted palette',
      (WidgetTester tester) async {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    );
    await tester.pumpWidget(
      wrap(
        const PragmaIconButtonWidget(
          icon: Icons.favorite,
          onPressed: null,
        ),
        theme: theme,
      ),
    );

    final IconButton iconButton =
        tester.widget<IconButton>(find.byType(IconButton));
    final ButtonStyle style = iconButton.style!;
    final Color disabledBackground =
        style.backgroundColor!.resolve(<WidgetState>{WidgetState.disabled})!;
    final Color disabledForeground =
        style.foregroundColor!.resolve(<WidgetState>{WidgetState.disabled})!;

    expect(
      disabledBackground,
      theme.colorScheme.onSurface.withValues(alpha: 0.12),
    );
    expect(
      disabledForeground,
      theme.colorScheme.onSurface.withValues(alpha: 0.38),
    );
  });

  testWidgets('compact size clamps fixed size', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        const PragmaIconButtonWidget(
          icon: Icons.remove,
          size: PragmaIconButtonSize.compact,
          onPressed: _noop,
        ),
      ),
    );

    final IconButton iconButton =
        tester.widget<IconButton>(find.byType(IconButton));
    final Size size = iconButton.style!.fixedSize!.resolve(<WidgetState>{})!;
    expect(size, const Size.square(PragmaSpacing.xl));
  });

  testWidgets('tapping triggers callback', (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      wrap(
        PragmaIconButtonWidget(
          icon: Icons.share,
          onPressed: () => taps++,
        ),
      ),
    );

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(taps, 1);
  });
}

void _noop() {}
