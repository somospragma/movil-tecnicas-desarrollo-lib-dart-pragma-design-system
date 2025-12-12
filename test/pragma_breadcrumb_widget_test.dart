import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  List<PragmaBreadcrumbItem> items({VoidCallback? onTap}) {
    return <PragmaBreadcrumbItem>[
      const PragmaBreadcrumbItem(label: 'Home'),
      PragmaBreadcrumbItem(label: 'Library', onTap: onTap),
      const PragmaBreadcrumbItem(label: 'Detail', isCurrent: true),
    ];
  }

  testWidgets('renders breadcrumb items and separators',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        PragmaBreadcrumbWidget(items: items()),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Detail'), findsOneWidget);
    expect(find.text('/'), findsNWidgets(2));
  });

  testWidgets('invokes callback when tapping a breadcrumb',
      (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      wrap(
        PragmaBreadcrumbWidget(
          items: items(onTap: () => taps++),
        ),
      ),
    );

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(taps, 1);
  });

  testWidgets('does not tap when disabled', (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      wrap(
        PragmaBreadcrumbWidget(
          disabled: true,
          items: items(onTap: () => taps++),
        ),
      ),
    );

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(taps, 0);
  });

  testWidgets('underline variant applies text decoration',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        PragmaBreadcrumbWidget(
          type: PragmaBreadcrumbType.underline,
          items: items(),
        ),
      ),
    );

    final Text textWidget = tester.widget<Text>(find.text('Library'));
    expect(textWidget.style?.decoration, TextDecoration.underline);
  });
}
