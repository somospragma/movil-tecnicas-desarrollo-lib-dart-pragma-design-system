import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme ??
          ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('renders label and icon for tertiary hierarchy',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        PragmaButton.icon(
          label: 'Ver detalles',
          icon: Icons.check,
          hierarchy: PragmaButtonHierarchy.tertiary,
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Ver detalles'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('small size enforces compact height',
      (WidgetTester tester) async {
    const Key buttonKey = ValueKey<String>('small-button');
    await tester.pumpWidget(
      wrap(
        PragmaSecondaryButton(
          key: buttonKey,
          label: 'Compact',
          size: PragmaButtonSize.small,
          onPressed: () {},
        ),
      ),
    );

    final Size size = tester.getSize(find.byKey(buttonKey));
    expect(size.height, PragmaSpacing.xl);
  });

  testWidgets('inverse primary swaps colors', (WidgetTester tester) async {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    );
    await tester.pumpWidget(
      wrap(
        const PragmaPrimaryButton(
          label: 'Inverse',
          tone: PragmaButtonTone.inverse,
          onPressed: _noop,
        ),
        theme: theme,
      ),
    );

    final TextButton button =
        tester.widget<TextButton>(find.byType(TextButton));
    final ButtonStyle style = button.style!;
    final Color background = style.backgroundColor!.resolve(<WidgetState>{})!;
    final Color foreground = style.foregroundColor!.resolve(<WidgetState>{})!;

    expect(background, theme.colorScheme.onPrimary);
    expect(foreground, theme.colorScheme.primary);
  });

  testWidgets('disabled button uses muted palette',
      (WidgetTester tester) async {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    );
    await tester.pumpWidget(
      wrap(
        const PragmaPrimaryButton(
          label: 'Disabled',
          onPressed: null,
        ),
        theme: theme,
      ),
    );

    final TextButton button =
        tester.widget<TextButton>(find.byType(TextButton));
    final ButtonStyle style = button.style!;
    final Color background =
        style.backgroundColor!.resolve(<WidgetState>{WidgetState.disabled})!;
    final Color foreground =
        style.foregroundColor!.resolve(<WidgetState>{WidgetState.disabled})!;

    expect(background, theme.colorScheme.onSurface.withValues(alpha: 0.12));
    expect(foreground, theme.colorScheme.onSurface.withValues(alpha: 0.38));
  });
}

void _noop() {}
