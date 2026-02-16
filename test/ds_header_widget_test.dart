import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget buildHeader({double? width, List<Widget> actions = const <Widget>[]}) {
    final Widget child = MaterialApp(
      theme: PragmaTheme.light(),
      home: Scaffold(
        body: DsHeaderWidget(
          title: 'Panel principal',
          actions: actions,
        ),
      ),
    );

    if (width == null) {
      return child;
    }

    return MaterialApp(
      theme: PragmaTheme.light(),
      home: Scaffold(
        body: SizedBox(
          width: width,
          child: DsHeaderWidget(
            title: 'Panel principal',
            actions: actions,
          ),
        ),
      ),
    );
  }

  testWidgets('renders title and actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildHeader(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            tooltip: 'Buscar',
            icon: const Icon(Icons.search),
          ),
          const CircleAvatar(child: Text('PD')),
        ],
      ),
    );

    expect(find.text('Panel principal'), findsOneWidget);
    expect(find.byTooltip('Buscar'), findsOneWidget);
    expect(find.text('PD'), findsOneWidget);
  });

  testWidgets('does not overflow on narrow width', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildHeader(
        width: 320,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            tooltip: 'Buscar',
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Alertas',
            icon: const Icon(Icons.notifications_outlined),
          ),
          const CircleAvatar(child: Text('PD')),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('allows interaction with action widgets',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      buildHeader(
        actions: <Widget>[
          IconButton(
            onPressed: () => tapped = true,
            tooltip: 'Buscar',
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );

    await tester.tap(find.byTooltip('Buscar'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
